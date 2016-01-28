Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2AFF07CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 13:30:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0748D8F8039
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:30:22 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id I9GTNR2i9ASWBdl1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:30:15 -0800 (PST)
Date: Thu, 28 Jan 2016 11:30:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfstests: also treat EINVAL as reflink/dedup not
	supported
Message-ID: <20160128193010.GD20038@birch.djwong.org>
References: <1454001236-2600-1-git-send-email-hch@lst.de>
	<1454001236-2600-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454001236-2600-4-git-send-email-hch@lst.de>
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

On Thu, Jan 28, 2016 at 06:13:55PM +0100, Christoph Hellwig wrote:
> This can be returned by various implementations of the ioctl.

Looks reasonable, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/reflink | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/reflink b/common/reflink
> index de8e56d..8638aba 100644
> --- a/common/reflink
> +++ b/common/reflink
> @@ -92,6 +92,8 @@ _require_test_dedupe()
>  		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
>  	echo $testio | grep -q "Inappropriate ioctl for device" && \
>  		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
> +	echo $testio | grep -q "Invalid argument" && \
> +		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
>  	rm -rf "$TEST_DIR/file1" "$TEST_DIR/file2"
>  }
>  
> @@ -110,6 +112,8 @@ _require_scratch_dedupe()
>  		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
>  	echo $testio | grep -q "Inappropriate ioctl for device" && \
>  		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
> +	echo $testio | grep -q "Invalid argument" && \
> +		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
>  	_scratch_unmount
>  }
>  
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
