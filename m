Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E8107CBE
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 19:04:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08BA4AC003
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 17:03:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7euKPubcNVRDbpSu for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 17:03:58 -0700 (PDT)
Date: Mon, 12 Aug 2013 10:03:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH 06/49] libxfs: fix byte
	swapping on constants
Message-ID: <20130812000334.GG12779@dastard>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-7-git-send-email-david@fromorbit.com>
	<51FBB978.2040207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51FBB978.2040207@sgi.com>
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
Cc: xfs@oss.sgi.com

On Fri, Aug 02, 2013 at 08:51:52AM -0500, Mark Tinguely wrote:
> On 07/19/13 01:44, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The kernel code uses cpu_to_beXX() on constants in switch()
> >statements for magic numbers in the btree code. Th ebyte swapping
> >infratructure isn't hooked up to the proper byte swap macros to make
> >this work, so fix it and then swap all the generic btree code over
> >to match the kernel code.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> sync to include/uapi/linux/swab.h and (IMO backwards) switch/case
> statements in xfs_allocbt_verify() like kernel commit ee1a47ab.

The reason they are done that way is so that the compiler evalutes
the byte swap rather than doing it at runtime. i.e runtime only
requires a comparisons, instead of a endian swap then a
comparison. Hence we end up with smaller, faster code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
