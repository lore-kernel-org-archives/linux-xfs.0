Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B6897F5A
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 02:03:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB1A7304032
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 00:03:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	48iE7WfVtMBDYEIH for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 00:03:14 -0700 (PDT)
Date: Mon, 18 Aug 2014 17:03:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD]: Help in setting up XFS
Message-ID: <20140818070312.GM20518@dastard>
References: <BLU181-W3698AB216D54D0CCE5A9739CD40@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BLU181-W3698AB216D54D0CCE5A9739CD40@phx.gbl>
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
To: Prithvi Rathore <prithvi_rathore@outlook.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 18, 2014 at 10:22:37AM +0530, Prithvi Rathore wrote:
> Hi,
> As the subject states, I would like to setup and use XFS on an external USB drive. I am currently using Ubuntu 14.04 on MacBook Air 2013.
> My understanding is:
> 
> 1) I will have to install the packages
> $ sudo apt-get install xfsprogs
> $ sudo apt-get install xfsdump
> 
> 2) I will have to create the filesystem for the USB drive
> $ mkfs.xfs -f dev/sdab1
> -f option needed to overwrite any exisitng filesytem

And then mount it appropriately and it will be ready to use.
Nothing more.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
