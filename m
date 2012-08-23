Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7NNe7VS100034 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 18:40:07 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pL3WzBN49jqSnzSH for <xfs@oss.sgi.com>;
	Thu, 23 Aug 2012 16:40:53 -0700 (PDT)
Date: Fri, 24 Aug 2012 09:40:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFE] xfstests: Add support for tmpfs filesystem
Message-ID: <20120823234051.GX19235@dastard>
References: <CAFZPdfipr3FkLJ3B7zDPXRA5Nw3Qerpri05gsnJopyMQwQfGUw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFZPdfipr3FkLJ3B7zDPXRA5Nw3Qerpri05gsnJopyMQwQfGUw@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Boris Ranto <ranto.boris@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2012 at 10:42:56PM +0200, Boris Ranto wrote:
> This is resent with the improved subject line.
> This is just a simple patch to get the tmpfs working. I've made the full
> xfstests run with the tmpfs as the target filesystem and it works quite
> well. Some tests passed properly, some tests failed (and some of them due
> to the nature of tmpfs).
> 
> I didn't change the xfstests logic to recognize a proper SCRATCH_DEV so the
> SCRATCH_DEV for tmpfs should be in the nfs form (with the : in it) for this
> to work properly.

The patch format isn't quite right. it is normally:

 Subject: One-line description

 <description>

 Signed-off-by: ....

 ---
 <diff>

As it is, it would be nice if you could rebase this on top of my
series that reworks xfstests - all the option parsing is changed,
the common.rc file is now in common/rc, and so on.

>           fi
>           ;;
> +    tmpfs)
> +        if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_MNT" ];
> +        then
> +            _notrun "this test requires a valid \$SCRATCH_MNT and unique
> $SCRATCH_DEV"
> +        fi
> +        ;;

The patch also has line wrap issues.

> @@ -1552,6 +1604,10 @@ _cleanup_testdir()
>      # umount testdir as it is $SCRATCH_MNT which could be used by xfs next
>      [ -n "$testdir" ] && $UMOUNT_PROG $testdir
>      ;;
> +    tmpfs)
> +    # umount testdir since it is actually a scrath mount

scratch mount.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
