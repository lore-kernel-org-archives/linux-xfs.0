Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3EIYr1R210584 for <xfs@oss.sgi.com>; Tue, 14 Apr 2009 13:35:04 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 79AB38F80D7
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2009 11:34:37 -0700 (PDT)
Message-Id: <BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <49E4A131.5040309@isg.de>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: XFS support for TRIM / blkdev_issue_discard?
Date: Tue, 14 Apr 2009 13:32:35 -0500
References: <20090331053013.7642414167108@attica.americas.sgi.com>
	<49E4A131.5040309@isg.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Niemayer <niemayer@isg.de>
Cc: xfs@oss.sgi.com


On Apr 14, 2009, at 9:44 AM, Peter Niemayer wrote:

> Dear Felix Blyakher,

Hi Peter,

> do you know whether there are plans to support the ATA TRIM command /
> blkdev_issue_discard() call in XFS for Linux anytime soon?

This topic was indeed brought up in xfs discussions.
Though, we don't have any definite plans on supporting it yet.
That doesn't mean that we oppose to it, just the lack of
resources at the moment.
Your mail will bring it up for discussion again.

Stay tuned,
Felix

>
>
> I ask because as someone who is currently benchmarking solid state  
> disks
> for certain usage scenarios I noticed that other filesystems are  
> starting
> to support the discarding of unused blocks, which allows to prevent
> performance-degradation of SSDs during heavy use.
> (See e.g. http://www.mail-archive.com/cluster-devel@redhat.com/msg03401.html
> on the GFS2 support for the discard feature, it seems not too hard
> to implement the support)
>
> Amongst other SSDs, we have one in our tests that supports the ATA  
> TRIM command,
> and I would like to test the benefits of it, even if that requires me
> to install an early kernel pre-release.
>
> (Currently, XFS is our favorite filesystem for several reasons, so  
> it would
> be great if we could run our TRIM-support-benchmarks using it)
>
> Regards,
>
> Peter Niemayer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
