Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCE5358388;
	Mon, 25 May 2026 05:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779688409; cv=none; b=UZQzCLOLIJJEf6U+9KTDz7sLYdrYJ5ONd1T6H7B4PI+8q+k41KhOvEKJ6f+E1o5jnarE0PvL+XM/yyiYwxiBOZCsfJ9pl5Ru++1rr5RBTsiV1T7gs6pcq9OjHY3Ihl5fKpEq5iJkJUa5zAlI3j5QZQuuYV7o70YNyqIopuQqJis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779688409; c=relaxed/simple;
	bh=VqnqfM5JRdCnP8OqgyGUpiZMaborgwh7Dqt2Yzo6ClI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfOVOmty2U/HXTFwEvYhOcvPbettoyY79s6YamLZmUKaDTar5WIg/PwDaLfT5w5GwMI4i+xaZLn2MU5FnOGJ5feCx1dAiA/McUDWXXMpJdGE8s10qtIsXzeenmW5nRhvVGuKtWCQMNoHfm+yqsNGZ2PDEJS0Rr/nZgpQrIJVF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YBpY0Vee; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YBpY0Vee"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DNnm6uON4ElQK2cQDHmHIp2XCM9lRWOT2u5V1xpH1lE=; b=YBpY0Veelnz1HLa1zOExoIMkTe
	UxFgAbeG440UGGZ0blpsKi0qmY56nwBQ3jWr1vTFfCsL4kR4mzz83KXfxf+jFqvGo78TENaGCIgOT
	gokQ6+iQ7oGH3xVvwaXoMIhWMsI8+35bQ87qerPEiIf7s8mh/QlHxiDCDEqBVeNsSqOL+rQwQpti9
	4oYSxkDwK485dqG1GLXptMWJG5Op5fYsZK+4WN6K+4Bl+OvYh40qCwMoxV1khkrJq4smCxo6weCn/
	lxByTISWBEgVq4UMqy0XJZvc550/3wM0dSO/OK2SozSrGLkDVnx9aETkBiW84GEeG7KphfWlMOKj3
	A+d+S1fQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wROFk-0000000GMa4-2JsX;
	Mon, 25 May 2026 05:53:28 +0000
Date: Sun, 24 May 2026 22:53:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qing Ming <a0yami@mailbox.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH] xfs: remove file privileges after XFS_IOC_SWAPEXT
Message-ID: <ahPj2PLdjNC9QWIF@infradead.org>
References: <20260524063820.45459-1-a0yami@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260524063820.45459-1-a0yami@mailbox.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, May 24, 2026 at 02:38:20PM +0800, Qing Ming wrote:
> XFS_IOC_SWAPEXT exchanges the data forks of two regular files. This
> changes file contents and therefore needs the same privilege stripping
> that ordinary write paths apply.
> 
> The legacy ioctl currently completes the exchange without removing
> SUID/SGID bits or file capabilities. As a result, a privileged inode can
> retain those attributes after its data fork has been replaced.
> 
> Pass the file objects into xfs_swap_extents() and call file_remove_privs()
> for both files after the exchange commits, before dropping the outer
> inode and mapping locks. This matches the XFS_IOC_EXCHANGE_RANGE finish
> path.

Not sure this makes much sense, as xfs_swap_extents is used for
defragmentation, including system-wide one, and this would drop the
suid bit from existing suid bit files and break the system.

I don't think there is a security issue as the target file needs to
be writable to the user performing the operation, and the owning uid/gid
has to match as well.

I think the issue is more that XFS_IOC_COMMIT_RANGE drops the suid
and could thus cause problems when used by fsr.

