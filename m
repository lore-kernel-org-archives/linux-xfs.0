Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 082D929E30
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 13:47:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA4D5304048
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 11:47:42 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	G4n7dmc8wFHPvYGu for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 11:47:41 -0800 (PST)
Date: Thu, 7 Nov 2013 06:47:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: add generated crc files to .gitignore
Message-ID: <20131106194738.GG6188@dastard>
References: <20131106102539.GA9481@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106102539.GA9481@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 02:25:39AM -0800, Christoph Hellwig wrote:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/.gitignore b/.gitignore
> index 446d84e..913b371 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -67,3 +67,8 @@ cscope.*
>  /quota/xfs_quota
>  /repair/xfs_repair
>  /rtcp/xfs_rtcp
> +
> +# generated crc files
> +/libxfs/crc32selftest
> +/libxfs/crc32table.h
> +/libxfs/gen_crc32table

Ah, I've never noticed that because I don't build in the source
trees I work in.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
