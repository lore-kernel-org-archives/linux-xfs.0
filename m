Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 32AA77F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 15:03:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1F9BAC002
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:03:21 -0700 (PDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
	[209.85.215.45]) by cuda.sgi.com with ESMTP id JCu5mGZiLbt0JoSR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:03:13 -0700 (PDT)
Received: by mail-la0-f45.google.com with SMTP id er20so6680854lab.18
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:03:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51469C90.1000001@oracle.com>
References: <51469C90.1000001@oracle.com>
Date: Mon, 18 Mar 2013 16:03:11 -0400
Message-ID: <CAJzLF9nCHckm-2W3cVW9E=HK1JtC67rxMCeJqVnRit23yLCK6w@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: fix assertion failure in xfs_vm_write_failed()
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Looks good in limited testing.  I set some extra debug code somewhere,
causing every failed mount in xfstests #078 to show up, so the
original test cases were double-checked, both on the main partition
(mid-upgrade) and on a backup boot partition:

Before Liu Patch v2:

#078, 32-bit Linux, larger partitions: PASS
#078, 32-bit Linux, smaller partitions: soft oops before test could fail

After Liu Patch v2:

#078, 32-bit Linux, larger partitions: PASS
#078, 32-bit Linux, smaller partitions: FAIL, no space left on device (CORRECT)

64-bit cases were not tested.  Additionally, tests 001-005 were run
(for my sake), and test 112 was run (pass).

The main partition on this PC for / is XFS, and I still have a file
system, so that's a good sign.  A gcc compile was left running because
I had to go to work, and I'll let you know if I don't have a file
system when I get back home.

Conclusion: Success on 32-bit, and failure is not seen for the near
future.  Testing in the next 24 hours may change this conclusion.

Thanks!

Michael

On Mon, Mar 18, 2013 at 12:48 AM, Jeff Liu <jeff.liu@oracle.com> wrote:
> Hello,
>
> Here is the v2 patch for fixing ASSERTION failed at xfs_vm_write_failed() according
> to Dave's comments, so I added Dave as SOB for credit.
>
> Hi Michael,
> Please kindly try at your at your convenience.
>
> Thanks,
> -Jeff

> This patch fix the block_offset evaluation to clear the lower 12 bits as:
> block_offset = pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT
> Hence, the ASSERTION should be correct because the from offset in a page
> is evaluated to have the lower 12 bits only.
>
> Thanks Dave Chinner for pointing this out.
>
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_aops.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 5f707e5..a418e17 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1494,7 +1494,8 @@ xfs_vm_write_failed(
>         loff_t                  pos,
>         unsigned                len)
>  {
> -       loff_t                  block_offset = pos & PAGE_MASK;
> +       loff_t                  block_offset = (pos >> PAGE_CACHE_SHIFT) <<
> +                                               PAGE_CACHE_SHIFT;
>         loff_t                  block_start;
>         loff_t                  block_end;
>         loff_t                  from = pos & (PAGE_CACHE_SIZE - 1);
> --
> 1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
