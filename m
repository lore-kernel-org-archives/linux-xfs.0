Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FC277F5D
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 18:06:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07A89AC003
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 16:06:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	W6Kvb4KtkIj5FtPK for <xfs@oss.sgi.com>;
	Wed, 12 Mar 2014 16:06:33 -0700 (PDT)
Date: Thu, 13 Mar 2014 10:06:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Possible XFS bug encountered in 3.14.0-rc3+
Message-ID: <20140312230631.GF6851@dastard>
References: <33A0129EBFD46748804DE81B354CA1B21C0DC77A@SACEXCMBX06-PRD.hq.netapp.com>
	<5320D4FE.3070002@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5320D4FE.3070002@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "Mears, Morgan" <Morgan.Mears@netapp.com>, Jie Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Mar 12, 2014 at 04:43:26PM -0500, Mark Tinguely wrote:
> On 03/12/14 15:14, Mears, Morgan wrote:
> >I was unable to umount, even with -f; failed with EBUSY and couldn't unbusy
> >as the fs was unresponsive (and happens to contain the Oracle management
> >tools necessary to close all open descriptors).  Accordingly I rebooted.
> 
> You are the second person in 2-3 weeks to hit this unmount issue.
> Unmatched EFI in the AIL keeps the unmount from completing.
> 
> Jeff are you still looking at this?

I'd say the answer is no. Last time you pointed out this problem I
last asked you to provide patches to fix the problem, mark. Can
you please provide patches to fix this, Mark?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
