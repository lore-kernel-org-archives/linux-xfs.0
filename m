Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5530F7F37
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 17:40:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4B46AC005
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 15:40:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gHq2F1PTVFfNov7J for
	<xfs@oss.sgi.com>; Wed, 11 Sep 2013 15:40:51 -0700 (PDT)
Date: Wed, 11 Sep 2013 12:19:29 +1000
From: Dave Chinner <dchinner@redhat.com>
Subject: Re: xfs: recovery of swap extents operations for CRC filesystems
Message-ID: <20130911021929.GF2445@devil.localdomain>
References: <20130911211819.GB10527@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130911211819.GB10527@elgon.mountain>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: mtinguely@sgi.com, xfs@oss.sgi.com

On Thu, Sep 12, 2013 at 12:18:19AM +0300, Dan Carpenter wrote:
> Hello Dave Chinner,
> 
> The patch 638f44163d57: "xfs: recovery of swap extents operations for
> CRC filesystems" from Aug 30, 2013, leads to the following
> static checker warning: "fs/xfs/xfs_log_recover.c:2999
> xlog_recover_inode_pass2()
> 	 info: ignoring unreachable code."
> 
> fs/xfs/xfs_log_recover.c
>   2992  out_release:
>   2993          xfs_buf_relse(bp);
>   2994  error:
>   2995          if (need_free)
>   2996                  kmem_free(in_f);
>   2997          return XFS_ERROR(error);
>                 ^^^^^^^^^^^^^^^^^^^^^^^
>   2998  
>   2999          xfs_buf_relse(bp);
>   3000          goto error;
> 
> These two added lines are unreachable.  Sometimes people add dead code
> for later, so this might be intentional.  It's not clear.

It's dead code. I reworked the error handling of the function and
didn't clean up all the mess.

Mark, I'm away from my upstream dev environment until next week -
can you send a followup patch to fix this?

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
