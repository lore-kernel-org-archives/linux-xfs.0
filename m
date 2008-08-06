Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Aug 2008 10:11:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m76HB5Qc029677
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2008 10:11:06 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8917EF0BAE7
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2008 10:12:19 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.228]) by cuda.sgi.com with ESMTP id 2LUX5fjDZvbYLq8E for <xfs@oss.sgi.com>; Wed, 06 Aug 2008 10:12:19 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id 57so16231wri.12
        for <xfs@oss.sgi.com>; Wed, 06 Aug 2008 10:12:19 -0700 (PDT)
Message-ID: <cc7060690808061012x43511581m15c794e72129becc@mail.gmail.com>
Date: Wed, 6 Aug 2008 22:42:15 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 981498 - Use KM_NOFS for debug trace buffers
In-Reply-To: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com>
MIME-Version: 1.0
References: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

I couldn't get a chance to read the diff's completely. If I click on
Lachlan's url for diff's, I couldn't access them. It looks to me that
the issue is not just with trace buffers. It can extend to xfs_iformat
as well. The same dead-lock can spring via

xfs_iread -> xfs_iformat -> xfs_iformat_extents -> xfs_iext_add ->
xfs_iext_inline_to_direct -> which can do kmem_alloc with
KM_SLEEP flag.


The source of the problem is that holding a lock and entering into
file-system once again. This can lead to dead-lock on the same
clustered buffer during cleaning of log space.

Cheers,
Bhagi.


On Wed, Aug 6, 2008 at 11:45 AM, Lachlan McIlroy <lachlan@sgi.com> wrote:

> Use KM_NOFS for debug trace buffers
>
> Use KM_NOFS to prevent recursion back into the filesystem which can
> cause deadlocks.
>
> In the case of xfs_iread() we hold the lock on the inode cluster buffer
> while allocating memory for the trace buffers.  If we recurse back into
> XFS to flush data that may require a transaction to allocate extents
> which needs log space.  This can deadlock with the xfsaild thread which
> can't push the tail of the log because it is trying to get the inode
> cluster buffer lock.
>
> Date:  Wed Aug  6 16:15:14 AEST 2008
> Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
> Inspected by:  david@fromorbit.com
> Author:  lachlan
>
> The following file(s) were checked into:
>  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
>
>
> Modid:  xfs-linux-melb:xfs-kern:31838a
> fs/xfs/xfs_log.c - 1.362 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_log.c.diff?r1=text&tr1=1.362&r2=text&tr2=1.361&f=h
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.362&r2=text&tr2=1.361&f=h
> fs/xfs/xfs_buf_item.c<http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.362&r2=text&tr2=1.361&f=hfs/xfs/xfs_buf_item.c>- 1.168 - changed
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.168&r2=text&tr2=1.167&f=h
> fs/xfs/xfs_inode.c<http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.168&r2=text&tr2=1.167&f=hfs/xfs/xfs_inode.c>- 1.518 - changed
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.518&r2=text&tr2=1.517&f=h
> fs/xfs/quota/xfs_dquot.c<http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.518&r2=text&tr2=1.517&f=hfs/xfs/quota/xfs_dquot.c>- 1.38 - changed
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
> fs/xfs/linux-2.6/xfs_buf.c<http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=hfs/xfs/linux-2.6/xfs_buf.c>- 1.262 - changed
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.262&r2=text&tr2=1.261&f=h
> fs/xfs/xfs_filestream.c<http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.262&r2=text&tr2=1.261&f=hfs/xfs/xfs_filestream.c>- 1.9 - changed
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
>        - Use KM_NOFS for debug trace buffers
>
>
>
>
>


[[HTML alternate version deleted]]
