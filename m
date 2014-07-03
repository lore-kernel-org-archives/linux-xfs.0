Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 865097F54
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 04:03:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14126AC001
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 02:03:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dfSOB1dWB1AMIGM6 for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 02:03:20 -0700 (PDT)
Date: Thu, 3 Jul 2014 19:02:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Realtime Replication problem
Message-ID: <20140703090253.GT4453@dastard>
References: <53B4E20C.60602@cmcltd.com> <20140703061525.GF9508@dastard>
	<53B4F7B7.4080807@cmcltd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53B4F7B7.4080807@cmcltd.com>
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
To: Jignesh <jignesh.prajapati@cmcltd.com>
Cc: "Bhavin.Joshi@Cmcltd.Com" <bhavin.joshi@cmcltd.com>, "Gaurang.Patel@Cmcltd.Com" <gaurang.patel@cmcltd.com>, Ravi <m.ravindran@cmcltd.com>, xfs@oss.sgi.com

On Thu, Jul 03, 2014 at 11:57:03AM +0530, Jignesh wrote:
> Dear Dave,
> 
> Thanks for your quick response.
> 
> This is not SGI Proprietary Storage product and not using any SGI
> proprietary kernel module. SGI IS3500 is normal Intel Server with 36
> HDDs. ( Storage Server), We have installed RHEL 6.2 on this Server
> and configured XVM and XFS.

XVM is SGI proprietary software:

http://www.sgi.com/products/storage/software/xvm.html

As it is, if you are using RHEL, you should talk to your Red Hat
support contact. They'll be able to tell you if it's a known problem
w/ XFS on RHEL and which version of RHEL 6.x it is fixed in. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
