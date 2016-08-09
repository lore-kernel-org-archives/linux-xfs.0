Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 864A17CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 02:28:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A95C304039
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 00:28:39 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id WdFDaPaxRgTjWm0E (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 00:28:36 -0700 (PDT)
Date: Tue, 9 Aug 2016 00:28:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] iomap: fiemap should honor the FIEMAP_FLAG_SYNC flag
Message-ID: <20160809072836.GA25647@infradead.org>
References: <1470637351-27933-1-git-send-email-david@fromorbit.com>
	<1470637351-27933-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470637351-27933-2-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 08, 2016 at 04:22:30PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The flag is checked as supported, but then we do an unconditional
> sync of the file, regardless of whether the flag is set or not. Make
> the sync conditional on having the FIEMAP_FLAG_SYNC flag set.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
