Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FD3471D02;
	Thu, 10 Sep 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058671; cv=none; b=jIjxhNfbTCzKTG/AbMqlx4iAdfGK5UWFQw9sps+MaRK+CUP/UdjABsjQCwsu6kdgwo0RmVuqModX8m5il4fG/uNHi8rfHtpRp4o5xkrxgjBBagAZNcEb0TtErtT9EtMTzj53YF6JEY9g+VmJ+T2Uqj1zEYCxzSUuWGxOLbZ4tWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058671; c=relaxed/simple;
	bh=9hTIZhgPZ7icsIv9IxbqeKZD4i9qoBmrTaUAInRUbTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEKHkCvgJ3n3YWo/EYWm2zhzsrae2TIXJhN3D/BSDgqkfd0UnSAmBqRk3ucTHeDm9VzV5xXfTGCTY7cIJ5ndFwmmUWatW/E0twJI45mWr20iCYfMQ0OApjf26+tnjqrbqxiD6hpVb3Ex78kSsr63F4fP58FgSNV3QTMNzGp4N1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JK+AJTBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JK+AJTBW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6FDB71F000FF;
	Thu, 10 Sep 2026 16:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789058669;
	bh=KWnVAe55byeENCc4MjVjXA9LZiuyS+dCQJBWhBpsuZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JK+AJTBWAKGMCPJxOJxhlojdYFzxkV3XuHeY20QX4IXiNDxrIik2FdkYA46mB49EK
	 QmNsu6q3rsZTZI3Pi6unlm8e/CvuQglrvHHaDLSrTqYXinXYmhibROjrEfHJ7arjUI
	 Tth8JHj4rzZlumVe3emF4FfN//LkI9mjFbWdb3RtH6qIEE3NUestNgHfvpG0n8L0ok
	 WY8x2+BV0S75FSO9/z8lbe3Om8afvSCyw2IN7TAkUDhZN1ndljEtFjTDI/3QmMn7pU
	 kZisMiLLH6/tRvq+4Mtl8m0Lp/YYnlVWbSixDvnKBvezQQZYqvWnMPqHpKsYqZrBAX
	 azo5092rEtT3w==
Date: Thu, 10 Sep 2026 09:44:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-man@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-api@vger.kernel.org
Subject: Re: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <20260910164428.GF6238@frogsfrogsfrogs>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
 <aqLY-1do_4hmZpfI@devuan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqLY-1do_4hmZpfI@devuan>

On Thu, Sep 10, 2026 at 06:31:48PM +0200, Alejandro Colomar wrote:
> Hi Darrick,
> 
> > Date: 2026-09-10 09:12:04-0700
> > From: "Darrick J. Wong" <djwong@kernel.org>
> >
> > On Thu, Sep 10, 2026 at 03:20:25PM +0200, Alejandro Colomar wrote:
> > > 
> > > > Date: 2026-09-10 12:41:18+0200
> > > > From: Andrey Albershteyn <aalbersh@kernel.org>
> [...]
> > > > +.SH DESCRIPTION
> > > > +The
> > > > +.BR file_getattr ()
> > > > +system call retrieves filesystem file attributes
> > > > +from the file specified by
> > > > +.IR pathname .
> > > > +.P
> > > > +This system call provides functionality similar to the
> > > > +.B FS_IOC_FSGETXATTR
> > > > +.BR ioctl (2)
> > > > +operation,
> > > 
> > > Should we document FS_IOC_FSGETXATTR in a new FS_IOC_FSGETXATTR(2const)
> > > manual page?
> > 
> > https://www.man7.org/linux/man-pages/man2/ioctl_xfs_fssetxattr.2.html
> 
> Thanks!  I didn't know that page.
> 
> I see the page uses the constants as XFS_ instead of FS_?  I think the

The sorded history of the xfs(ish) file attributes calls is that they
began their lives as XFS_IOC_FSGETXATTR since they were XFS-specific.
Then we tried to make them "generic" by removing the 'X', and that's how
we got FS_IOC_FSGETXATTR.  Finally Andrey came along and made them
proper syscalls with path-lookup abilities ... but for now they use the
same struct as the old XFS_IOC_FSGETXATTR.

Personally I think we should only document XFS_IOC_FSGETXATTR (in
xfsprogs) and file_getattr (in man-pages).  And leave FS_IOC_FSGETXATTR
unmentioned.

> page should have some mention about it, especially since it says non-xfs
> filesystems also implement this.  Is it the same as (or related to)
> what's mentioned in quotactl(2)?
> 
> 	NOTES
> 	   Alternative XFS header
> 	     Instead of <xfs/xqm.h> one  can  use  <linux/dqblk_xfs.h>,
> 	     taking into account that there are several naming discrep‐
> 	     ancies:
> 
> 	     •  Quota       enabling       flags       (of       format
> 		XFS_QUOTA_[UGP]DQ_{ACCT,ENFD}) are  defined  without  a
> 		leading "X", as FS_QUOTA_[UGP]DQ_{ACCT,ENFD}.
> 
> 	     •  The  same is true for XFS_{USER,GROUP,PROJ}_QUOTA quota
> 		type     flags,     which      are      defined      as
> 		FS_{USER,GROUP,PROJ}_QUOTA.
> 
> 	     •  The  dqblk_xfs.h  header  file  defines its own XQM_US‐
> 		RQUOTA, XQM_GRPQUOTA, and  XQM_PRJQUOTA  constants  for
> 		the  available  quota  types,  but their values are the
> 		same as for constants without the XQM_ prefix.
> 
> I think we should probably have a xfs-xqm(2head) manual page documenting
> these conventions, I think.

quotactl (and xattrs) have a similar weird history of originating in XFS
and later getting yanked into the vfs.  Every time I have to go look up
the quota syscalls I just get a headache. :/

--D

> Also, given it doesn't seem exclusive of xfs, should we move the manual
> page to the Linux man-pages (from xfsprogs)?
> 
> > > > +but with the advantage that the file does not need to be opened.
> > > > +By using a pathname,
> > > > +.BR file_getattr ()
> > > > +can retrieve filesystem file attributes
> > > > +from all file types,
> > > > +including special files such as FIFOs, sockets, block devices, character
> > > > +devices, and symlinks, where opening the targeted inode may not be possible.
> > > 
> > > This seems to be a limitation of FS_IOC_FSGETXATTR(2const), and would be
> > > more appropriately documented in that page (if we add it).  There, I'd
> > > document it in CAVEATS.  Then, file_getattr(2) wouldn't need to mention
> > > this at all, because it's not an issue here.
> > 
> > Agreed, that belongs in ioctl_xfs_fssetxattr.2, not here.
> 
> Thanks!
> 
> > 
> > --D
> 
> Have a lovely day!
> Alex
> 
> -- 
> <https://www.alejandro-colomar.es>


