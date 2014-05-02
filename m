Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BAA617F55
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 23:54:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47005AC001
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 21:54:47 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wGyKejAWxbBLV9fD (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 May 2014 21:54:44 -0700 (PDT)
Date: Thu, 1 May 2014 21:54:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: truncate_setsize should be outside transactions
Message-ID: <20140502045443.GA8867@infradead.org>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398983979-23696-1-git-send-email-david@fromorbit.com>
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

On Fri, May 02, 2014 at 08:39:39AM +1000, Dave Chinner wrote:
> This issue with xfs_setattr_size() was introduced back in 2010 by
> commit fa9b227 ("xfs: new truncate sequence") which moved the page
> cache truncate from outside the transaction context (what was
> xfs_itruncate_data()) to inside the transaction context as a call to
> truncate_setsize().

And it was moved because we should only call truncate_setsize once
the truncate can't fail any more.  So to move it out of transaction
context it needs to move after the commit of the transaction(s).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
