Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AA61E7FAF
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 01:27:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 96FAF8F8037
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 23:27:20 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id eo9lu1k7ETpwk1Q8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 23:27:19 -0800 (PST)
Date: Mon, 2 Feb 2015 08:27:16 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: don't allocate an ioend for direct I/O completions
Message-ID: <20150202072716.GA9378@lst.de>
References: <1422485661-520-1-git-send-email-hch@lst.de>
	<20150130144223.GA27441@laptop.bfoster>
	<20150201230403.GD4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150201230403.GD4251@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Feb 02, 2015 at 10:04:03AM +1100, Dave Chinner wrote:
> > A nit, but I guess you could kill the braces here now too.
> 
> Given it's a multi-line return statement, the braces are fine. FWIW,
> when we have a if () { return ...} else { return ... } we normally
> kill the else. i.e:
> 
> 	if (rw & WRITE) {
> 		return foo(
> 			bar,
> 			baz);
> 	}
> 	return .....;
> 
> So I modified it like this.

For an if/else that is 100% symmetric like read vs write I prefer
to keep the else, otherwise I agree.  But in the end it's a very
minor point, so it doesn't really matter.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
