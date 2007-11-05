Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Nov 2007 11:41:25 -0800 (PST)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.232])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA5JfEdg019444
	for <xfs@oss.sgi.com>; Mon, 5 Nov 2007 11:41:16 -0800
Received: by nz-out-0506.google.com with SMTP id x3so1002294nzd
        for <xfs@oss.sgi.com>; Mon, 05 Nov 2007 11:41:19 -0800 (PST)
Message-ID: <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com>
Date: Tue, 6 Nov 2007 00:12:52 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 972756 - Implement fallocate.
In-Reply-To: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
MIME-Version: 1.0
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

David, What happens if offset is not aligned to 4k? Let's say we have a file
whose size is
not aligned to 4k. It could have blocks beyond the eof which haven't been
zero'ed out.
fallocate may increase the size and we can read garbage from disk-block if
it hasn't
been zero'ed out.

-Thanks,
 Bhagi.

On 11/2/07, David Chinner <dgc@sgi.com> wrote:
>
> Implement fallocate.
>
> Implement the new generic callout for file preallocation.
> Atomically change the file size if requested.
>
>
> Date:  Fri Nov  2 13:42:52 AEDT 2007
> Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
> Inspected by:  hch@infradead.org
>
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
>
>
> Modid:  xfs-linux-melb:xfs-kern:30009a
> fs/xfs/linux-2.6/xfs_iops.c - 1.268 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.268&r2=text&tr2=1.267&f=h
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.268&r2=text&tr2=1.267&f=h
>         - implement ->fallocate()
>
>
>
>


[[HTML alternate version deleted]]
