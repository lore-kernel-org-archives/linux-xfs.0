Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5FCA29DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:14:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C76B5304092
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 15:14:48 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pAzaHzTwefQqUs4Y for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 15:14:47 -0800 (PST)
Date: Tue, 3 Dec 2013 10:14:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/15] mkfs: validate logarithmic parameters sanely
Message-ID: <20131202231436.GC10988@dastard>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-7-git-send-email-david@fromorbit.com>
	<20131202170601.GB14935@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202170601.GB14935@infradead.org>
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

On Mon, Dec 02, 2013 at 09:06:01AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 29, 2013 at 12:43:41PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Testing logarithmic paramters like "-n log=<num>" shows that we do a
> > terrible job of validating such input. e.g.:
> > 
> > # mkfs.xfs -f -n log=456858480 /dev/vda
> > .....
> > naming   =version 2              bsize=65536  ascii-ci=0 ftype=0
> > ....
> > 
> > Yeah, I just asked for a block size of 2^456858480, and it didn't
> > get rejected. Great, isn't it?
> > 
> > So, factor out the parsing of logarithmic parameters, and pass in
> > the maximum valid value that they can take. These maximum values
> > might not be completely accurate (e.g. block/sector sizes will
> > affect the eventual valid maximum) but we can get rid of all the
> > overflows and stupidities before we get to fine-grained validity
> > checking later in mkfs once things like block and sector sizes have
> > been finalised.
> 
> Btw, is there any good reason not to deprecate the logarithmic
> parameters?  I can't see why anyone would want to use them, but I see
> lots of potential for confusion (happened to myself in the past).

Yup, I can't see a good reason for keeping them. Indeed, we could
just add a conversion identifier to indicate the value is in a power
of 2 and have cvtnum() do the conversion for us...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
