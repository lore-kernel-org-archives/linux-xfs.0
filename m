Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E6DE7F8E
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 19:12:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 502FC304053
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 17:12:39 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IPVpEbM836f5MVGw for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 17:12:37 -0700 (PDT)
Date: Fri, 11 Apr 2014 10:12:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4/306: disable 64bit feature too
Message-ID: <20140411001235.GB15995@dastard>
References: <1397044147-15727-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397044147-15727-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 09, 2014 at 07:49:07PM +0800, Eryu Guan wrote:
> mke2fs ext4 without extent feature will fail if 64bit feature is
> enabled in mke2fs.conf
> 
> mke2fs 1.42.9 (28-Dec-2013)
> Extents MUST be enabled for a 64-bit filesystem.  Pass -O extents to rectify.
> 
> So disable 64bit feature together with extent explicitly.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/ext4/306 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/ext4/306 b/tests/ext4/306
> index 9559cf2..fd50b0e 100755
> --- a/tests/ext4/306
> +++ b/tests/ext4/306
> @@ -48,7 +48,7 @@ _require_scratch
>  rm -f $seqres.full
>  
>  # Make a small ext4 fs with extents disabled & mount it
> -yes | mkfs.ext4 -O ^extents $SCRATCH_DEV 512m >> $seqres.full 2>&1
> +yes | mkfs.ext4 -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1
>  _scratch_mount || _fail "couldn't mount fs"
>  
>  # Create a small non-extent-based file
> -- 
> 1.9.0

Looks fine to me, but you should CC ext4 test changes to
linux-ext4@vger.kernel.org as well so that the ext4 developers can
review such changes are well...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
