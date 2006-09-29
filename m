Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Sep 2006 10:07:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8TH7KaG007480
	for <xfs@oss.sgi.com>; Fri, 29 Sep 2006 10:07:21 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21C44D11900E
	for <xfs@oss.sgi.com>; Fri, 29 Sep 2006 10:06:39 -0700 (PDT)
Message-ID: <451D527A.6080904@sandeen.net>
Date: Fri, 29 Sep 2006 12:06:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Remove unused stuff
References: <20060929032916.AB75B18001A5F@sandeen.net>
In-Reply-To: <20060929032916.AB75B18001A5F@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sandeen@sandeen.net
Cc: xfs@oss.sgi.com

sandeen@sandeen.net wrote:
> And now that things are static, remove things that are not used.
> 
>  xfs_bmap.c       |   36 ------------------
>  xfs_bmap_btree.c |   74 -------------------------------------
>  xfs_bmap_btree.h |   11 -----
>  xfs_da_btree.c   |   15 -------
>  xfs_da_btree.h   |    1 
>  xfs_error.c      |   26 -------------
>  xfs_error.h      |    1 
>  xfs_rtalloc.c    |  108 -------------------------------------------------------
>  xfs_rtalloc.h    |   18 ---------
>  9 files changed, 290 deletions(-)
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


I suppose that if this code is deemed useful, maybe it could be moved to
some xfs_*_debug.[ch] files so it's not lost....

Hm, or looks like some of it is used in userspace (xfs_da_log2_roundup)
it could be moved there if not ever used in the kernel.  (although from
a quick look I'm not sure that's doing anything useful there either,
anymore).

-Eric
