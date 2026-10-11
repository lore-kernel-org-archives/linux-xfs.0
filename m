Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127BA2F1FD0
	for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2026 07:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791703447; cv=none; b=FIPVAHBE/WmVoYztbOQL1dx03zQdqUiV6MFwhBKS7sjRoXkZBQAAtUWX2A5mi/Uiw6IeCD3RbYnWkwzzfaJyBMFsw7tKm6yF1QZBIthHAWJSW/pBQRCN/itJJDXxcH+3JQ8W0grthYFOMiGBviDSfputgeViAm7Mw+fHL5BXPyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791703447; c=relaxed/simple;
	bh=Ot1eBJjiJRsFCdR6VhFedLgKlNle0Y/IF4tyoLEVWhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGpSy2UEjuBq4zAkNq9LizUKSCU1zdDkB7lBYTK4oDlaZHnpNYgwXT8Q1oF9ecPv1mFF0We+kp/gTN7g7FE/pn3FfrlE9fHWeNuQm0YGGO7Nxp7tOGgl9VsmP/WXAHBktCzH0hpYgtJpPK1KrBORamhf2T2l4DTxk9fLF2hGXYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BbOFApIu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BbOFApIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6A91F0089B;
	Sun, 11 Oct 2026 07:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791703446;
	bh=9oclz1XdUcqGRy0Iu0bEQYhqCct6U/5n0liTwgxCUC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BbOFApIuvOFgXfOa0SYYVszFj/EkWEvUaXz9wbQ+pQfktxRLTwYpHhGnHf65hLZ03
	 wbcpSFC4xhgxK9/zv5GJWtiuiBSgBq81LgQrPhABXc70SeH9ZcEY8dwb3rEId5iOVR
	 pvV+9HUqbY/3QlYgslIi+L8aCtInyNmhREGumv9C+dk7mQGf522KLVvs6DqFs3DtzR
	 jcNoH0W8XqJoRQIvuFi0CEIZddqN/5lgUdi+MATklM7AIfAyVHFLkBWaUeAtHJiatf
	 m88tG/61uOcVHyFr53DQ2U5VvPcV2y/4VRdYjROeBl0rgLoYL49JmQkoDtZlmJvfBQ
	 rVCxjXvopdzEw==
Date: Sun, 11 Oct 2026 09:24:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <dchinner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH for-next v3] xfs: fix NOFS state corruption in btree
 split worker
Message-ID: <ass3LRLEFJDlFIoh@cronus.toxiclabs.cc>
References: <20260921071030.3214538-1-wangkefeng.wang@huawei.com>
 <179122359071.102066.15509293508787425638.b4-ty@kernel.org>
 <f15d804d-f3d8-433f-97d1-5dfcabcc381c@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f15d804d-f3d8-433f-97d1-5dfcabcc381c@huawei.com>

On Sat, Oct 10, 2026 at 06:46:42PM +0800, Kefeng Wang wrote:
> 
> 
> On 10/6/2026 2:06 AM, Carlos Maiolino wrote:
> > On Mon, 21 Sep 2026 15:10:30 +0800, Kefeng Wang wrote:
> > > xfs_btree_split_worker() calls xfs_trans_set_context() and
> > > xfs_trans_clear_context() on the caller's transaction, overwriting
> > > tp->t_pflags with the worker's NOFS state. When the caller already has
> > > PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> > > the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> > > the caller's NOFS protection.
> > > 
> > > [...]
> > 
> > Applied to for-next, thanks!
> 
> Thank，I checked linux-next's next-20261009, and there was a commit
> 23f91a51425e, but the code was incorrect during the conflict resolution.
> I don't know if this is the correct state for linux-next, just a reminder.

Linux-next appears to have removed all changes from this patch. I don't
know why it happened honestly, I'll need to dig into it later. IIRC
there was a conflict with -mm patches.

Patches staged for xfs are in xfs-linux/xfs-7.4-merge. Code there is
correct.
I always attempt a merge against Linus's tree before sending him the
patches and at the time if I see any conflict, I'll give him a heads up.

Thanks for letting me know though. I don't keep comparing xfs-linux
state against linux-next.

> 
> 
> > 
> > [1/1] xfs: fix NOFS state corruption in btree split worker
> >        commit: 23f91a51425ed3d4a5c42978fc25f1087611e4ba
> > 
> > Best regards,
> 
> 
