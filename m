Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A1D47F5F
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 03:42:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1605C8F804C
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 01:42:09 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bRjvk0uQaaIsM2zh (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 01:42:08 -0800 (PST)
Date: Tue, 3 Dec 2013 01:42:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/15] mkfs: validate all input values
Message-ID: <20131203094207.GB4906@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-5-git-send-email-david@fromorbit.com>
	<20131202170420.GA14935@infradead.org>
	<20131202231202.GA10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202231202.GA10988@dastard>
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

On Tue, Dec 03, 2013 at 10:12:02AM +1100, Dave Chinner wrote:
> How does this make sense, though?
> 
> # mkfs.xfs -s size=4s /dev/vda
> 
> Specifying the sector size in *sectors* is currently considered a
> valid thing to do. That's insane and fundamentally broken, because
> this
> 
> # mkfs.xfs -b size=4s -s size=2s /dev/vda
> 
> results in the block size conversion using a 512 byte sector size,
> and everything else using a 1024 byte sector size for conversions.
> e.g:
> 
> # mkfs.xfs -b size=4s -s size=2s -n size=2s /dev/vda
> 
> results in a block size of 2k (4*512) and a directory block size of
> 2k (2*1024). i.e. the result of unit conversion is dependent on
> where the sector size is specified on the command line!

True.  Guess we should indeed just outright rejecting it.  I was more
concerned about using the sector size before defined for other
parameters, but given how seldomly we specify it on the command line
anyway we're probably better off just using the normal table based
validation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
