Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B082D29DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 11:06:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8BC578F8049
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 09:06:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4j08ZlvBGPfKMqmj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 09:06:01 -0800 (PST)
Date: Mon, 2 Dec 2013 09:06:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/15] mkfs: validate logarithmic parameters sanely
Message-ID: <20131202170601.GB14935@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385689430-10103-7-git-send-email-david@fromorbit.com>
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

On Fri, Nov 29, 2013 at 12:43:41PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Testing logarithmic paramters like "-n log=<num>" shows that we do a
> terrible job of validating such input. e.g.:
> 
> # mkfs.xfs -f -n log=456858480 /dev/vda
> .....
> naming   =version 2              bsize=65536  ascii-ci=0 ftype=0
> ....
> 
> Yeah, I just asked for a block size of 2^456858480, and it didn't
> get rejected. Great, isn't it?
> 
> So, factor out the parsing of logarithmic parameters, and pass in
> the maximum valid value that they can take. These maximum values
> might not be completely accurate (e.g. block/sector sizes will
> affect the eventual valid maximum) but we can get rid of all the
> overflows and stupidities before we get to fine-grained validity
> checking later in mkfs once things like block and sector sizes have
> been finalised.

Btw, is there any good reason not to deprecate the logarithmic
parameters?  I can't see why anyone would want to use them, but I see
lots of potential for confusion (happened to myself in the past).

The patch itself looks good:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
