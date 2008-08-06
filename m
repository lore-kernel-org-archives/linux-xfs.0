Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Aug 2008 10:21:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m76HLPuH002542
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2008 10:21:25 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D3F2365BCF
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2008 10:22:39 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.234]) by cuda.sgi.com with ESMTP id 5I2eVLR70zy4dREz for <xfs@oss.sgi.com>; Wed, 06 Aug 2008 10:22:39 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id 57so20820wri.12
        for <xfs@oss.sgi.com>; Wed, 06 Aug 2008 10:22:39 -0700 (PDT)
Message-ID: <cc7060690808061022i1dce01dfx9e43ad3a75e5c936@mail.gmail.com>
Date: Wed, 6 Aug 2008 22:52:38 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 981498 - use KM_MAYFAIL in xfs_mountfs
In-Reply-To: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com>
MIME-Version: 1.0
References: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Why are we going to block for ever? Mounting a file-system
requires in-core log space buffers, reading of other buffers
which needs allocation of memory greater than per ag
structures.

I am trying to understand why xfs_perag_t? Mount/Unmount
are not frequent activities, it is better for them to succeed
if operating system can allocate memory and take them
forward.

-Saradhi.

On Wed, Aug 6, 2008 at 11:11 AM, Lachlan McIlroy <lachlan@sgi.com> wrote:

> use KM_MAYFAIL in xfs_mountfs
>
> Use KM_MAYFAIL for the m_perag allocation, we can deal with the error
> easily and blocking forever during mount is not a good idea either.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Date:  Wed Aug  6 15:40:44 AEST 2008
> Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
> Inspected by:
> hch
> lachlan
> Author:  lachlan
>
> The following file(s) were checked into:
>  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
>
>
> Modid:  xfs-linux-melb:xfs-kern:31837a
> fs/xfs/xfs_mount.c - 1.445 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_mount.c.diff?r1=text&tr1=1.445&r2=text&tr2=1.444&f=h
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.445&r2=text&tr2=1.444&f=h
>        - use KM_MAYFAIL in xfs_mountfs
>
>
>
>
>


[[HTML alternate version deleted]]
