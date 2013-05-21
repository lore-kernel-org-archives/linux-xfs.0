Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 12BD529DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 16:32:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B369CAC003
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 14:32:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gdA4hMBhEd6W3YDt for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 14:32:16 -0700 (PDT)
Date: Wed, 22 May 2013 07:32:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: btrfs 308: regression test for btrfs send V2
Message-ID: <20130521213215.GR24543@dastard>
References: <1369169947-13748-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369169947-13748-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 04:59:07PM -0400, Josef Bacik wrote:
> I'm not sure how the numbering is supposed to work now that we've split
> everything out so I'm just going with the next number in the directory.

Number them however you want - numbers are unique within a
subdirectory.

> This is
> a regression test for btrfs send, we had a problem where we'd try to send a file
> that had been deleted in the source snapshot.  This is just to make sure we
> don't have the same problem in the future.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2: 
> -added a -x optoin to multi_open_unlink to make it not check for existing
>  files
> -made all the normal output go to $seqres.full
....
> @@ -73,6 +74,9 @@ main(int argc, char *argv[])
>  			case 'v':  /* value size on eas */
>  				value_size = atoi(optarg);
>  				break;
> +			case 'x': /* don't use O_EXCL, for use with exsint files */

Typo - "exsint"

.....
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount

You probably want to remove $seqres.full here, so that on failure
only the output of the current run is in the file.

Other than those two minor things, it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
