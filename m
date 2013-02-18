Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 126EA7F53
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 16:06:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1575AC002
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 14:06:45 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vACRvtmCSdsP07L3 for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 14:06:43 -0800 (PST)
Date: Tue, 19 Feb 2013 09:06:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 32bit apps and inode64
Message-ID: <20130218220639.GB26694@dastard>
References: <4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
	<4FAA153D.1030606@hardwarefreak.com>
	<20120509070450.GP5091@dastard> <511E4F00.2010703@profihost.ag>
	<20130215214653.GP22182@sgi.com>
	<F4526E0F-2DDC-4FB4-927D-BFD8AD489D55@profihost.ag>
	<20130217213359.GA26694@dastard> <5121E253.8000400@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5121E253.8000400@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Feb 18, 2013 at 09:12:03AM +0100, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> Am 17.02.2013 22:33, schrieb Dave Chinner:
> 
> >>> xfs_reno was ported to linux in '07 and was most recently reposted by Jeff Liu:
> >>> http://oss.sgi.com/archives/xfs/2012-11/msg00425.html
> >>>
> >>> It isn't in xfsprogs today.
> > 
> > Simple answer: mount with inode32, run find to print out all the
> > filenames in the filesystem and their inode number, copy the files
> > with inodes numbers greater than 32 bit to a temporary file and then
> > rename them over the top of the original.
> 
> Thanks, what about directories? Is renaming / moving using mv enough?

Same thing - create a new temp directory, mv all the entries (which
will be  a rename operation, anyway) from the old directory into the
temp directory, rename the temp dir over the top of the old one.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
