Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E9C67F7C
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 02:34:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF716304053
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 00:34:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id a0gqRt9z2rJx3ESp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Apr 2014 00:34:49 -0700 (PDT)
Date: Fri, 11 Apr 2014 00:34:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: zeroing space needs to punch delalloc blocks
Message-ID: <20140411073447.GA6397@infradead.org>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
	<1397106053-7489-5-git-send-email-david@fromorbit.com>
	<20140410104001.GG17641@infradead.org>
	<20140410122259.GC27519@dastard>
	<20140410123332.GA15577@infradead.org>
	<20140410223546.GE27519@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140410223546.GE27519@dastard>
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

On Fri, Apr 11, 2014 at 08:35:46AM +1000, Dave Chinner wrote:
> Fixed it.

Reviewed-by: Christoph Hellwig <hch@lst.de>

with that little tweak.  And yes, we'll need that series ASAP - I not
hit the asserts everytime I do an xfstests run.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
