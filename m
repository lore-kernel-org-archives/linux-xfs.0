Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1413A29DF8
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 11:49:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4DB88F8052
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 09:49:51 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HsNkV1iI41PkzGeP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 09:49:51 -0800 (PST)
Date: Fri, 7 Feb 2014 09:49:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/033: add golden output for CRC enaled filesystems
Message-ID: <20140207174950.GB31464@infradead.org>
References: <1391588590-6035-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391588590-6035-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 05, 2014 at 07:23:10PM +1100, Dave Chinner wrote:
> diff --git a/common/filter b/common/filter
> index 04d12c4..bb7fb33 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -152,6 +152,9 @@ _filter_mkfs()
>      if (/^\s+=\s+sectsz=(\d+)\s+attr=(\d+)/) {
>          print STDERR "sectsz=$1\nattr=$2\n";
>      }
> +    if (/^\s+=\s+crc=(\d)/) {
> +        print STDERR "crc=$1\n";
> +    }

I think this variable is named way to genericly.  And that probably
applies to others as well.

I'd suggest at least xfs_feature_crc or similar.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
