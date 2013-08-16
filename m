Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D72CD7F55
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 09:55:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B46568F8070
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 07:55:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7VEu9Wfl7UsPndC9 for <xfs@oss.sgi.com>;
	Fri, 16 Aug 2013 07:55:41 -0700 (PDT)
Message-ID: <520E3D6C.8070007@sandeen.net>
Date: Fri, 16 Aug 2013 09:55:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: silence btrfs balance in btrfs/003
References: <1376664680-16046-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1376664680-16046-1-git-send-email-sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 8/16/13 9:51 AM, Stefan Behrens wrote:
> This test failed for me with output from 'btrfs balance':
>      QA output created by 003
>     +Done, had to relocate 4 out of 4 chunks
>     +Done, had to relocate 5 out of 5 chunks
>      Silence is golden
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  tests/btrfs/003 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> index 3790935..795badb 100755
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -109,7 +109,7 @@ _test_add()
>  	for i in `seq 1 $n`; do
>  		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
>  	done
> -	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "balance failed"
> +	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT > /dev/null 2>&1 || _fail "balance failed"

It'd be better to redirect to $seqres.full; that way when it fails,
you'll have something to look at with more info than /dev/null contains :)

You'd need just a little prep work there to rm -f $seqres.full at the beginning
of the test so it doesn't grow forever.

-Eric

>  	umount $SCRATCH_MNT
>  }
>  
> @@ -152,7 +152,7 @@ _test_replace()
>  	# in some system balance fails if there is no delay (a bug)
>  	# putting sleep 10 to work around as of now
>  	# sleep 10
> -	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "dev balance failed"
> +	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev balance failed"
>  
>  	# cleaup. add the removed disk
>  	umount $SCRATCH_MNT
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
