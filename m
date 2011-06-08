Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p585IlCh073924 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 00:18:48 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB44616C54CF
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 22:18:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qf794Kjpw1KD4e74 for <xfs@oss.sgi.com>;
	Tue, 07 Jun 2011 22:18:45 -0700 (PDT)
Date: Wed, 8 Jun 2011 15:18:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: I/O hang, possibly XFS, possibly general
Message-ID: <20110608051842.GO32466@dastard>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
	<19945.24042.711472.158523@tree.ty.sabi.co.UK>
	<201106060929.06814@zmi.at>
	<19950.12549.541440.285348@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19950.12549.541440.285348@tree.ty.sabi.co.UK>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_mh@sabi.co.UK>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Tue, Jun 07, 2011 at 03:09:09PM +0100, Peter Grandi wrote:
> Personally I'd rather have a file system design with space
> reservations (on detecting an append-like access pattern) and
> truncate-on-close than delayed allocation like XFS;

Welcome to the 1990s, Peter. XFS has been doing this for 15 years.
It is an optimisation used by the delayed allocation mechanism,
not a replacement for it. You might have heard the term
"speculative preallocation" before - this is what it does.

FYI, ext3 has a space reservation infrastructure to try to ensure
contiguous allocation occurs without using delayed allocation. It
doesn't work nearly as well as delayed allocation in ext4, btrfs or
XFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
