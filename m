Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A910B7F72
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 23:17:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A408304064
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 21:17:26 -0700 (PDT)
Received: from mail-vc0-f179.google.com (mail-vc0-f179.google.com
	[209.85.220.179]) by cuda.sgi.com with ESMTP id
	QzQhVQfO5iGTj0Ie (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Mar 2013 21:17:22 -0700 (PDT)
Received: by mail-vc0-f179.google.com with SMTP id gf12so2633790vcb.38
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 21:17:22 -0700 (PDT)
Message-ID: <5146954A.20802@gmail.com>
Date: Mon, 18 Mar 2013 00:17:14 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix ASSERTION failure in xfs_vm_write_failed()
References: <5145DAB4.40007@oracle.com>
In-Reply-To: <5145DAB4.40007@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 03/17/2013 11:01 AM, Jeff Liu wrote:
> On 32-bit system, if the request pos is 64-bit and evaluate block_offset
> with (pos & PAGE_MASK) will result in overflows, therefore the assertion
> will failed.  We have to check the write offset against (pos & ~0UL) to
> avoid this issue as it can evaluate the highest 20 bits on 32-bit correctly
> if the pos request is 64-bit and keep the expected result of 64-bit pos request
> on 64-bit system unchanged.
>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Cc: Dave Chinner <david@fromorbit.com>
> ---
>   fs/xfs/xfs_aops.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 5f707e5..2fc7367 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1501,7 +1501,12 @@ xfs_vm_write_failed(
>   	loff_t			to = from + len;
>   	struct buffer_head	*bh, *head;
>
> -	ASSERT(block_offset + from == pos);
> +	/*
> +	 * Evaluate block_offset via (pos & PAGE_MASK) on 32-bit system
> +	 * can cause overflow if the request pos is 64-bit.  Hence we
> +	 * have to verify the write offset with (pos & ~0UL) to avoid it.
> +	 */
> +	ASSERT(block_offset + from == (pos & ~0UL));
>
>   	head = page_buffers(page);
>   	block_start = 0;

Thanks!  I can't help but admire the effort.  That stated, I did read 
Dave's review and now understand the "..." that he left as comments to 
the original bug report...

My original reason for writing was to refine the test case a little bit. 
  On this 32-bit Pentium III PC, xfstests #078 succeeds on a 560MB 
device-mapper linear target (1146880 sectors), but it fails with an oops 
on a 544MB dm-linear target (1114112 sectors).  Looking at the output of 
the `df` command over and over during the test, the data does stop 
growing at a point between those two numbers, proving Dave's initial 
observation correct.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
