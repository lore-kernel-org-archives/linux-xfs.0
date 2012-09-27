Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RNPxjr152664 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 18:25:59 -0500
Message-ID: <5064E0CC.1000203@sgi.com>
Date: Thu, 27 Sep 2012 18:27:08 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
References: <20120924171159.GG1140@sgi.com>
	<201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
	<20120927224852.GJ13214@sgi.com> <5064DE7A.6000608@sgi.com>
In-Reply-To: <5064DE7A.6000608@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 09/27/12 18:17, Mark Tinguely wrote:

> I will run a x86_64 machine overnight to see if I can get a hang
> on that box too.
>
> We are dealing with multiple AGs here, so analysing this one may take
> more time.
>
> Rarely but sometimes, this machine will save core upon receiving a NMI.
> I will try to get as much information before trying that.
>
> --Mark.

Sorry, I am tired. This does not have to be multiple AGs.

Anyway, the clearing of the xfs_alloc_args structure does not prevent
the hang. More tomorrow.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
