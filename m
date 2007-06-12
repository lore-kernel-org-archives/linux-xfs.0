Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 23:40:44 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5C6eeWt015497
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 23:40:41 -0700
Subject: Re: Review: factor extracting extent size hints from the inode
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070612060800.GP86004887@sgi.com>
References: <20070604052333.GR85884050@sgi.com> <466E2B76.7010707@sgi.com>
	 <20070612060800.GP86004887@sgi.com>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 16:39:46 +1000
Message-Id: <1181630386.3758.90.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Vlad Apostolov <vapo@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, 2007-06-12 at 16:08 +1000, David Chinner wrote:
> 
> If you use this method of setting the extent size hint, then you will
> *always* get the XFS_DIFLAG_EXTSIZE flag set when you have an extent
> size hint, regardless of whether it is a realtime file or not. 

The extsize flag is relatively recent though, and traditionally
realtime files could have had their extsize explicitly set with
no associated extsize flag (thats just how it was implemented,
originally, in realtime).

But, not many people use realtime, even fewer would be using the
extent size option with realtime (like, none?, on Linux anyway)
... so, you could pretty much make whatever rule you like.

cheers.

-- 
Nathan
