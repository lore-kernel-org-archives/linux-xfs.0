Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 586747F69
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 08:14:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38A308F8039
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 06:14:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id kG9V2ZJmREGGEN7H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 06:14:38 -0700 (PDT)
Date: Mon, 4 Aug 2014 06:14:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6 V2] xfs: kill VN_DIRTY()
Message-ID: <20140804131437.GA22365@infradead.org>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-4-git-send-email-david@fromorbit.com>
	<20140731171302.GA22173@infradead.org>
	<20140804032016.GW20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140804032016.GW20518@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Aug 04, 2014 at 01:20:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Only one user and the use of a dirty page cache check is redundant,
> so just get rid of it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
