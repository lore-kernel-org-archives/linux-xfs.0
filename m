Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E5977F77
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 02:39:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D6F4304062
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 00:39:38 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	S46kr5kgCcsxKJ12 for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 00:39:35 -0700 (PDT)
Date: Fri, 8 Aug 2014 17:39:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs hang in 3.14.15
Message-ID: <20140808073931.GD26465@dastard>
References: <53E02495.4080208@sbcglobal.net> <20140805011800.GC20518@dastard>
	<53E372AA.4030304@sbcglobal.net> <20140807211052.GD17105@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140807211052.GD17105@kroah.com>
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
To: Greg KH <gregkh@linuxfoundation.org>
Cc: xfs@oss.sgi.com, Bill <billstuff2001@sbcglobal.net>

On Thu, Aug 07, 2014 at 02:10:52PM -0700, Greg KH wrote:
> On Thu, Aug 07, 2014 at 07:35:54AM -0500, Bill wrote:
> > On 08/04/2014 08:18 PM, Dave Chinner wrote:
> > >On Mon, Aug 04, 2014 at 07:25:57PM -0500, Bill wrote:
> > >>Hi,
> > >>
> > >>I've been running a stress test on 3.14.15 and eventually my xfs
> > >>filesystem hangs. Both 3.10.50 and 3.16 seem to work ok.
> > >log space hang.
> > >
> > >110dc24 xfs: log vector rounding leaks log space
> > >
> > >Cheers,
> > >
> > >Dave.
> > 
> > Thanks Dave, that helped.
> > 
> > Greg, Please consider this for inclusion in 3.14.y. It fixed an xfs hang I
> > had on 3.14.15
> 
> Dave, any objection for me to include it?

Go ahead, Greg. FWIW, if you are doing another 3.15 release, it is
needed there as well as this fix didn't go in until 3.16-rc1....

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
