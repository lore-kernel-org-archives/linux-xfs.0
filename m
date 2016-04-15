Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 97B4C7CA0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 13:28:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5429B8F8033
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:28:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OABPTB1qpon8aHC3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:28:30 -0700 (PDT)
Date: Fri, 15 Apr 2016 14:28:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: buffer ->bi_end_io function requires irq-safe lock
Message-ID: <20160415182828.GA39792@bfoster.bfoster>
References: <1460736519-39428-1-git-send-email-bfoster@redhat.com>
	<20160415180820.GA20260@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160415180820.GA20260@infradead.org>
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

On Fri, Apr 15, 2016 at 11:08:20AM -0700, Christoph Hellwig wrote:
> How about just doing a cmpxchg on bi_error?

Hmm, good idea. Something like this I take it..?

	if (bio->bi_error)
		cmpxchg(&bp->b_io_error, 0, bio->bi_error);

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
