Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 788C97F53
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:17:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15E01AC002
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 01:17:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 0aB2pkNYwT8pIFmo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 01:17:26 -0700 (PDT)
Date: Mon, 2 Sep 2013 01:17:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: ensure we copy buffer type in da btree root
	splits
Message-ID: <20130902081725.GB11210@infradead.org>
References: <1378081921-18570-1-git-send-email-david@fromorbit.com>
	<1378081921-18570-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378081921-18570-3-git-send-email-david@fromorbit.com>
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

On Mon, Sep 02, 2013 at 10:32:01AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When splitting the root of the da btree, we shuffled data between
> buffers and the structures that track them. At one point, we copy
> data and state from one buffer to another, including the ops
> aasociated with the buffer. When we do this, we also need to copy
> the buffer type associated with the buf log item so that the buffer
> is logged correctly. If we don't do that, log recovery won't
> recognise it and hence it won't recalculate the CRC on the buffer
> after recovery. This leads to a directory block that can't be read
> after recovery has run.
> 
> Found by inspection after finding the same problem with remote
> symlink buffers.

It would be great to find a way to trigger this in QA as this shows
another area lacking coverage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
