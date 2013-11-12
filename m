Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 70A007F75
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 11:33:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 487B88F8033
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:33:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id gOeZ5ig4amscOxbZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 09:33:46 -0800 (PST)
Date: Tue, 12 Nov 2013 09:33:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: increase inode cluster size for v5 filesystems
Message-ID: <20131112173345.GA19554@infradead.org>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
	<1383280040-21979-6-git-send-email-david@fromorbit.com>
	<20131105164307.GD32110@infradead.org>
	<20131105195650.GA6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131105195650.GA6188@dastard>
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

On Wed, Nov 06, 2013 at 06:56:50AM +1100, Dave Chinner wrote:
> > printing this on every mount seem a bit too verbose.
> 
> I'd like to leave it there until we remove the experimental tag from
> the v5 superblock configuration, as there is no good way of
> determining that someone is using a mkfs patched to enable this
> feature yet...

I tend to disagree, but given that it's not actively harmful I'm fine
with merging it as-is.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
