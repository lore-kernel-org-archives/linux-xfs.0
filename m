Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837AE32C937;
	Tue, 14 Jul 2026 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051206; cv=none; b=n0y19x363pCvr/Zd5hTbbdBmY8M3RX27j2IfaAwtnuiXUsqGFx7YSMnJZqg9atyngaMCCgWN/thSMhwj72joLFOxKpv1EWqEBq86uSep+d08VtG8E3taiuhuXkINnKCyAmzXGtmMUI7bf99H6/nRj4K2t4BQfQjc7v+DNpzmnYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051206; c=relaxed/simple;
	bh=gAe7/K5W7BZdOxMmZUcU3kRP1vsJ/w6KBHpQH+kAk7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jhc4wtm3xfb9lQ5G6exvQSRG+OVhm+t4Dh4cxZenZZZGYJE7umH3xKCexgV7yl8kUA0qlozch4XH/Apo5shp/EdEt7B9TL/h15ikT8+QMrAy5zLZf5Xfby6dP5vGvqH2gGQwLk+rXZncSvFU2ykNZFZ9Wecx81f0lGHQ130RDCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmpYU8ZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmpYU8ZW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CD2991F000E9;
	Tue, 14 Jul 2026 17:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784051191;
	bh=XQmO8+EmMXSGTYjFcE0BhTQRAlDjxFq7vR7Gr0hnfiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bmpYU8ZWwbKFyYPGSGvgwZi+VhBmXFC43LY4nzh+honvnc02aXyF+v3nAfHhNXODS
	 lJMpnmk2HxTjEwi7MVrGaY3VyNfZ1io1vdJz88ep/JvL+jeDvSaHh13MRn9qUhJV5q
	 wo5REwiT5K+pqOo5iNNkYugCznS6sy62vDsj7qKliUQFj5MBp5srYD1WZbwtVAYdSe
	 zvlOAmM2QbfwYWdbXlFTmpQYqJGAwYZt5cYmds/aq8xNBnG0u3PAnDvJssSiOj1mY0
	 gpK6vzUYDQokh2f2UTEW+Hm+iKoKAR3hfJWwqei1/2pBmWTiAk3cx//00WS3wTxkpT
	 csv+2kV7dbQcQ==
Date: Tue, 14 Jul 2026 10:46:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: cem@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
Message-ID: <20260714174630.GF7380@frogsfrogsfrogs>
References: <20260713145002.1627608-1-yun.zhou@windriver.com>
 <20260713220436.GH7195@frogsfrogsfrogs>
 <54dae2e9-6341-4d58-a92e-11852a12b027@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54dae2e9-6341-4d58-a92e-11852a12b027@windriver.com>

On Tue, Jul 14, 2026 at 09:41:11AM +0800, Zhou, Yun wrote:
> 
> Thanks a lot for your review.
> 
> On 7/14/26 06:04, Darrick J. Wong wrote:
> > 
> > On Mon, Jul 13, 2026 at 10:50:02PM +0800, Yun Zhou wrote:
> > > xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
> > > xfs_trans_commit(), which flushes the CIL push workqueue internally.
> > > If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
> > > lock these buffers to fail them, causing a deadlock:
> > > 
> > >    setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
> > >    CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
> > > 
> > > Remove the xfs_trans_bhold() calls so that commit releases the buffer
> > > locks normally.  After the sync commit, re-acquire the buffers via
> > > mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.
> > 
> > Is there a risk of writing out the wrong superblock contents if
> > something else grabs the buffer lock(s) between the xfs_trans_commit and
> > the xfs_buf_lock calls?  Can we walk off a garbage
> > xfs_mount::m_{rt,}sb_bp pointer if the filesystem is being torn down, or
> > does something prevent that?
> > 
> 
> There shouldn't be a risk of inconsistent contents. Each update to the sb
> buffer is a full overwrite of mp->m_sb via xfs_sb_to_disk(), performed under
> the buffer lock. So when we re-lock after commit, the buffer  always
> contains a complete, consistent snapshot — we may see a newer version if
> someone else updated it in between, but never a partially written one.
> 
> For the pointer lifetime: mp->m_sb_bp is allocated at mount and freed in
> xfs_unmountfs(). The caller holds mnt_want_write_file(), which prevents
> unmount from making progress, so the pointer should remain valid throughout
> xfs_sync_sb_buf().

<nod> Ok then.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> BR,
> Yun
> 
