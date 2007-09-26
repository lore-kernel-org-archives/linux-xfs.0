Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 05:25:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QCPCdR008557
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 05:25:14 -0700
Message-ID: <46FA4FA5.5040405@sandeen.net>
Date: Wed, 26 Sep 2007 07:25:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 971050 - Remove linux-2.4 build support
References: <20070926082614.D92CE300F406@linuxbuild.melbourne.sgi.com>
In-Reply-To: <20070926082614.D92CE300F406@linuxbuild.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: donaldd@sgi.com
Cc: xfs@oss.sgi.com

donaldd@sgi.com wrote:
> Remove fs/xfs/linux-2.4 as building for 2.4 kernels is no longer supported from this tree
> 
> Date:  Wed Sep 26 18:24:41 AEST 2007
> Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
> Inspected by:  tes
> 
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
> 

Yay! :)

So, what's to be done about xfs_refcache.c... right now it's 2.4-only,
but i'm not convinced that there is similar generic nfs functionality in
2.6, anyone know for sure?

-Eric
