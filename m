Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FF377F6F
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 12:16:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1C2068F804B
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 10:16:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id LkgyXtEaKPCybNnZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Dec 2013 10:16:13 -0800 (PST)
Date: Mon, 9 Dec 2013 10:16:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] xfs: add xfs_ilock_attr_map_shared
Message-ID: <20131209181612.GA22183@infradead.org>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.663030833@bombadil.infradead.org>
	<20131208223610.GE31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131208223610.GE31386@dastard>
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

On Mon, Dec 09, 2013 at 09:36:10AM +1100, Dave Chinner wrote:
> > +			/*
> > +			 * Even after flushing the inode, there can still be
> > +			 * delalloc blocks on the inode beyond EOF due to
> > +			 * speculative reallocation.  These are not removed
> 
> "speculative preallocation"

I just re-indented the comment, the wording is the original one.  Maybe
we'll get a commit that cares enought to fix it on the fly..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
