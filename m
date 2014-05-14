Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D57B7F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 16:28:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7986AC00D
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 14:28:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MR6iSP25DpUH35kl for <xfs@oss.sgi.com>;
	Wed, 14 May 2014 14:28:25 -0700 (PDT)
Date: Thu, 15 May 2014 07:28:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/9] xfs: error sign fixes for 3.15-rc6
Message-ID: <20140514212822.GS26353@dastard>
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
	<53731B07.9040606@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53731B07.9040606@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, May 14, 2014 at 03:28:07PM +0800, Jeff Liu wrote:
> Hi Dave,
> 
> On 05/13/2014 04:56 PM, Dave Chinner wrote:
> > Hi folks,
> > 
> > I've been working through the mess that is the
> > error sign impedance mismatch between the core XFS code and the rest
> > of the kernel. I'm about half way through the codebase, and I've
> > found a bunch of incorrect error signs throughout the VFS interface
> > layers.
> > 
> > These were effectively all found by inspection, and is
> > further evidence that we need to convert all of XFS to negative
> > errors as quickly as possible. 
> 
> Would you like to find a volunteer to deal with that? I have a colleague
> is trying to study XFS these days, looks this is a good task to him.

Thanks for the offer, but I've already done half the conversion of
the codebase.  Hence I may as well finish it.  Indeed, The sooner
I've done it, the sooner we can get it into the dev tree for
testing....

> BTW, before doing negative errors converting, should we have
> libxfs infrastructure support at first?

Makes no difference - the libxfs structural changes are just moving
files about and futzing with makefiles. It'll only take me an hour
to redo those patches from scratch, so it doesn't matter what state
the code base is in to start with. I'd prefer that the kernel libxfs
uses negative errors from the start, though ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
