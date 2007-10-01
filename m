Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 00:49:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l917nd9b000545
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 00:49:43 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA21432; Mon, 1 Oct 2007 17:49:31 +1000
Message-ID: <4700A68A.8070609@sgi.com>
Date: Mon, 01 Oct 2007 17:49:30 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] refactor xfs_mountfs for clarity & stack savings
References: <46D37A82.2080608@sandeen.net> <20070828195221.GA7237@infradead.org> <46D48BDE.5000903@sandeen.net>
In-Reply-To: <46D48BDE.5000903@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Refactoring xfs_mountfs() to call sub-functions for logical
> chunks can help save a bit of stack, and can make it easier to
> read this long function.

Finally got around to reviewing this one, sorry for the delay.

I think we've lost something in the refactoring.

> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
...
> -	/*
> -	 * XFS uses the uuid from the superblock as the unique
> -	 * identifier for fsid.  We can not use the uuid from the volume
> -	 * since a single partition filesystem is identical to a single
> -	 * partition volume/filesystem.
> -	 */
> -	if ((mfsi_flags & XFS_MFSI_SECOND) == 0 &&
> -	    (mp->m_flags & XFS_MOUNT_NOUUID) == 0) {
> -		if (xfs_uuid_mount(mp)) {
> -			error = XFS_ERROR(EINVAL);
> -			goto error1;
> -		}
> -		uuid_mounted=1;

The patch removes uuid_mounted=1, but doesn't put it back in anywhere.
I think we need that bit for error handling :)

Don
