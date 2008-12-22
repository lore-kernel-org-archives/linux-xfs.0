Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMD8Qs9017619 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 07:08:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF54F3EB6C
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 05:08:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RwSlie1GTiaot522 for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 05:08:25 -0800 (PST)
Date: Mon, 22 Dec 2008 08:08:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: couple small xfstest patches
Message-ID: <20081222130824.GC12367@infradead.org>
References: <a2da1d27af9a31cc891cfeeafc27abf4.squirrel@mail.voxel.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a2da1d27af9a31cc891cfeeafc27abf4.squirrel@mail.voxel.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthew Kent <mkent@magoazul.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 21, 2008 at 01:45:23PM -0800, Matthew Kent wrote:
> * 189 fails with external devices
> * add a unified diff output option, find it easier on the eyes ;)

Thanks, I'll put these into my queue.  Question to the list:  any
arguments against just making unified diffs the default for xfsqa
output?

> 
> Thanks!
> -- 
> Matthew Kent <mkent@magoazul.com>
> http://magoazul.com
> --- xfs-cmds/xfstests/common.orig	2008-11-21 13:19:47.000000000 -0800
> +++ xfs-cmds/xfstests/common	2008-11-21 13:22:04.000000000 -0800
> @@ -107,7 +107,7 @@
>      -nfs                test NFS
>      -l			line mode diff (default)
>      -xdiff		graphical mode diff
> -    -diffu		show unified diff
> +    -udiff		show unified diff
>      -n			show me, do not run tests
>      -q			quick [deprecated]
>      -T			output timestamps
> @@ -158,7 +158,7 @@
>  	    fi
>  	    ;;
>  
> -	-diffu)	# show unified diff
> +	-udiff)	# show a unified diff
>  	    xpand=false
>  	    diff="$diff -u"
>  	    ;;
> --- xfs-cmds/xfstests/189.orig	2008-11-21 13:43:33.000000000 -0800
> +++ xfs-cmds/xfstests/189	2008-11-21 13:42:48.000000000 -0800
> @@ -188,8 +188,8 @@
>  _need_to_be_root
>  _require_scratch
>  
> -unset SCRATCH_OPTIONS
> -unset MOUNT_OPTIONS
> +unset SCRATCH_RTDEV
> +unset SCRATCH_LOGDEV
>  
>  _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
>  
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
