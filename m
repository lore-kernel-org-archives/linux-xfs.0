Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8D5A7CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 13:28:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A26D1304039
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:27:59 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7HnDPovMP3rorjfP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:27:57 -0800 (PST)
Date: Thu, 28 Jan 2016 11:27:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfstests: require dedup ioctl support in 182
Message-ID: <20160128192753.GC20038@birch.djwong.org>
References: <1454001236-2600-1-git-send-email-hch@lst.de>
	<1454001236-2600-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454001236-2600-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Jan 28, 2016 at 06:13:54PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/182 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/generic/182 b/tests/generic/182
> index bf5cd38..eb80b43 100755
> --- a/tests/generic/182
> +++ b/tests/generic/182
> @@ -46,6 +46,7 @@ _cleanup()
>  # real QA test starts here
>  _supported_os Linux
>  _require_test_reflink
> +_require_test_dedupe
>  _require_cp_reflink

The _require_*_reflink bits are unnecessary.  I must've been going too fast
when I wrote 181/182; I'll fix that in my repo and send patches.

Also 182's comments should s/reflink/dedupe/.

--D

>  
>  rm -f "$seqres.full"
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
