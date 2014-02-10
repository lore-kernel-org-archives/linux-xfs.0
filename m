Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3A3A7F52
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 04:44:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBCA18F8033
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 02:44:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id nnlI8HG09Tq5gKBs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 02:44:27 -0800 (PST)
Date: Mon, 10 Feb 2014 02:44:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/033: add golden output for CRC enaled filesystems
Message-ID: <20140210104426.GA9840@infradead.org>
References: <1391588590-6035-1-git-send-email-david@fromorbit.com>
	<20140207174950.GB31464@infradead.org>
	<20140210015105.GN13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140210015105.GN13647@dastard>
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

On Mon, Feb 10, 2014 at 12:51:05PM +1100, Dave Chinner wrote:
> I can't say I like adding that prefix to the mkfs varaibles. I'll
> change this one to something less generic, but I'm going to ignore
> the others right now because changing them involves modifying 30+
> tests....

In that case let's keep the crc one without prefix for now.  But I think
introducing very generic variables into the environment implicitly is
a bad idea and will bite us long term.

Reluctantly:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
