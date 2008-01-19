Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 22:00:41 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0J60ZlB005707
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 22:00:37 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4D8BC9C60B
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 22:00:54 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id alNV448KQ9W27JlH for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 22:00:54 -0800 (PST)
Message-ID: <47919214.9000807@sandeen.net>
Date: Sat, 19 Jan 2008 00:00:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW 2/2] Case insensitive support for XFS - user-space
References: <op.t43zfeiz3jf8g2@pc-bnaujok.melbourne.sgi.com> <479118CF.1020302@sandeen.net>
In-Reply-To: <479118CF.1020302@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Eric Sandeen wrote:

> Also, if I specify -nutf8=default on a 500m fs:
> 
> # mkfs.xfs -dfile,name=fsfile,size=500m -nutf8=default
> meta-data=fsfile                 isize=256    agcount=4, agsize=32000 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=128000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   utf8=default
> log      =internal log           bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> mkfs.xfs: cannot reserve space: No space left on device

        /*
         * allocate the inode
         */
        tp = libxfs_trans_alloc(mp, 0);
        error =  libxfs_trans_reserve(tp, XFS_CREATE_LOG_RES(mp), 0, 0,
0, 0);
        if (error) {
                fprintf(stderr, _("%s: 1: cannot reserve space: %s (%d)\n"),
                        progname, strerror(error), XFS_CREATE_LOG_RES(mp));
                exit(1);
        }


I think there are some wrong arguments to that trans_reserve... at least
XFS_CREATE_LOG_RES should be 3rd arg, no?

-Eric
