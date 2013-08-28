Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FC3429DFB
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 11:32:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5EBE08F8039
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 09:32:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7EwPXC8o0jjKuO08 for
	<xfs@oss.sgi.com>; Wed, 28 Aug 2013 09:32:22 -0700 (PDT)
Message-ID: <521E260E.4020005@redhat.com>
Date: Wed, 28 Aug 2013 11:32:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: _test_generic_punch: Obtain block size from
	$TEST_DIR
References: <2632380.gCujKLhaaV@localhost.localdomain>
In-Reply-To: <2632380.gCujKLhaaV@localhost.localdomain>
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
To: chandan <chandan@linux.vnet.ibm.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sekharan@linux.vnet.ibm.com, xfs@oss.sgi.com

On 8/28/13 1:24 AM, chandan wrote:
> The current code incorrectly gets block size information from $TEST_DEV
> instead of from $TEST_DIR. This returns the block size of the filesystem
> hosting the device file rather than that of the filesystem on $TEST_DEV.
> 
> Signed-off-by: chandan <chandan@linux.vnet.ibm.com>

Oof, yes, this looks right.  Seems strange, I thought < 4k was working
on x86; maybe just by accident.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I'll take another look at your other patch in light of this fix.

Thanks!

-Eric

> ---
>  common/punch | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/punch b/common/punch
> index 7b3c009..a49638c 100644
> --- a/common/punch
> +++ b/common/punch
> @@ -520,7 +520,7 @@ _test_generic_punch()
>  	if [ "$remove_testfile" ]; then
>  		rm -f $testfile
>  	fi
> -	block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	block_size=`stat -f $TEST_DIR | grep "Block size" | cut -d " " -f3`
>  	$XFS_IO_PROG -f -c "truncate $block_size" \
>  		-c "pwrite 0 $block_size" $sync_cmd \
>  		-c "$zero_cmd 128 128" \
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
