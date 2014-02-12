Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0432F7F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 19:55:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B1CEAC014
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 17:55:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nwJVYUEkxtBeAvdU for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 17:55:50 -0800 (PST)
Date: Wed, 12 Feb 2014 12:55:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [NOISE] merge window blues, XFS broken
Message-ID: <20140212015546.GP13647@dastard>
References: <52E56386.5040802@gmail.com> <20140127015614.GD2212@dastard>
	<52E62ADA.2040800@gmail.com> <20140127233039.GF2212@dastard>
	<52E768CF.5040908@gmail.com> <20140128095559.GJ2212@dastard>
	<alpine.LNX.2.11.1402111853440.12612@bpserver.ds>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1402111853440.12612@bpserver.ds>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 11, 2014 at 07:15:47PM -0500, Michael L. Semon wrote:
> On Tue, 28 Jan 2014, Dave Chinner wrote:
> >Ok, so xfs_inode_item_format+0x4a is inside the very first call to
> >preapre the ilf structure. That tells us that the initial
> >xfs_log_vec/xfs_log_iovec array are resulting in an unaligned
> >buffer.
> >
> >Can you try the patch below, Michael?
> 
> This patch still works fine.  This reply is only in hopes that the
> patch doesn't get lost for being in a subthread of a [NOISE] post.
> I'm having to use this patch quite a bit in order to use XFS at all
> on 32-bit x86.

It's in xfs-fixes-for-3.14-rc3 anf for-next right now. It'll go
upstream in the next couple of days.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
