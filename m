Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 403047F5D
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 16:10:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 111DF304043
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 14:10:55 -0700 (PDT)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	ASddJZBshTtTlHXl (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Aug 2014 14:10:54 -0700 (PDT)
Date: Thu, 7 Aug 2014 14:10:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: xfs hang in 3.14.15
Message-ID: <20140807211052.GD17105@kroah.com>
References: <53E02495.4080208@sbcglobal.net> <20140805011800.GC20518@dastard>
	<53E372AA.4030304@sbcglobal.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53E372AA.4030304@sbcglobal.net>
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
To: Bill <billstuff2001@sbcglobal.net>
Cc: xfs@oss.sgi.com

On Thu, Aug 07, 2014 at 07:35:54AM -0500, Bill wrote:
> On 08/04/2014 08:18 PM, Dave Chinner wrote:
> >On Mon, Aug 04, 2014 at 07:25:57PM -0500, Bill wrote:
> >>Hi,
> >>
> >>I've been running a stress test on 3.14.15 and eventually my xfs
> >>filesystem hangs. Both 3.10.50 and 3.16 seem to work ok.
> >log space hang.
> >
> >110dc24 xfs: log vector rounding leaks log space
> >
> >Cheers,
> >
> >Dave.
> 
> Thanks Dave, that helped.
> 
> Greg, Please consider this for inclusion in 3.14.y. It fixed an xfs hang I
> had on 3.14.15

Dave, any objection for me to include it?

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
