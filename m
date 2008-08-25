Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 16:14:57 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7PNEthI032437
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 16:14:55 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6662D1A478FB
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 16:16:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 0DyGWs45AkPo4idO for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 16:16:17 -0700 (PDT)
Message-ID: <48B33D40.6020104@sandeen.net>
Date: Mon, 25 Aug 2008 18:16:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS_BUF_ORDERED instead of XFS_BUF_ISORDERED?
References: <48B32E36.7060305@houseofnate.net>
In-Reply-To: <48B32E36.7060305@houseofnate.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Nathaniel W. Turner" <nate@houseofnate.net>
Cc: xfs@oss.sgi.com

Nathaniel W. Turner wrote:
> Hi folks,
> 
> While doing a little light reading, I noticed the following in 
> fs/xfs/xfs_log.c:1011 (in the 2.6.26.3 Linux kernel tree).  Am I missing 
> something, or should XFS_BUF_ORDERED be replaced with XFS_BUF_ISORDERED 
> in this check?
> 
> nate
> 
> 
>         /*
>          * If the ordered flag has been removed by a lower
>          * layer, it means the underlyin device no longer supports
>          * barrier I/O. Warn loudly and turn off barriers.
>          */
>         if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && 
> !XFS_BUF_ORDERED(bp)) {
>                 l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
>                 xfs_fs_cmn_err(CE_WARN, l->l_mp,
>                                 "xlog_iodone: Barriers are no longer 
> supported"
>                                 " by device. Disabling barriers\n");
>                 xfs_buftrace("XLOG_IODONE BARRIERS OFF", bp);
>         }
> 
> 

wow, I think you're right.

Fortunately I dont' think this does much harm in most cases - the buffer
is usually ordered here anyway, and we're re-setting it instead of
testing it, as you noticed.  But it's making this whole
dynamic-lack-of-barrier detection pointless/broken.

modest proposal:  change the macro (and friends) to XFS_BUF_SETORDERED
or somesuch.  :)

-Eric
