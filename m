Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1QKdwgH207818 for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 14:39:58 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF1EA13DEEF0
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 12:41:22 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id nbGUFvMCQP1JyGRB for
	<xfs@oss.sgi.com>; Fri, 26 Feb 2010 12:41:22 -0800 (PST)
Message-ID: <4B8831F1.4050300@sandeen.net>
Date: Fri, 26 Feb 2010 14:41:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 4k sector sizes
References: <4B882F5D.5090901@uwyo.edu>
In-Reply-To: <4B882F5D.5090901@uwyo.edu>
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
To: "Walter R. Fletcher" <fletcher@uwyo.edu>
Cc: xfs@oss.sgi.com

Walter R. Fletcher wrote:
> 
> Western Digital has announced hard drives that will
> have 4K sized sectors instead of 512 bytes.  I'm sure
> other manufacturers will do so too...
> 
> I wonder about potential effects on performance one
> might see re: xfs with a 4k block size and the WD hard
> drives with the 4k sectors.  Is this a valid question?
> 
> Just a curious (xfs-using) fly on the wall...

Totally valid question; by and large, XFS should detect
this and cope just fine.  There may be one hole where
if you manually specify a block size < 4k at mkfs time,
it will continue without complaint, when in fact this
may be sub-optimal for the drive.

A lot of work has been done upstream and in Fedora,
at least, to be sure that partitioning and mkfs tools
can and do query the block device for this (and other)
information, to be sure that the results are well-aligned
and efficient.

Recent userspace & kernel is needed for all this to work
nicely together, though.

-Eric

> __Reid__
> 
> Reid Fletcher
> Chief Engineer, Wyoming Public Radio
> University of Wyoming
> Laramie, WY


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
