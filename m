Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D9D17F3F
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2014 09:27:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F02D304043
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2014 07:27:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qi5XSBs40TrV4YD1 for <xfs@oss.sgi.com>;
	Fri, 20 Jun 2014 07:27:00 -0700 (PDT)
Message-ID: <53A444B4.2010803@sandeen.net>
Date: Fri, 20 Jun 2014 09:27:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Create superblock
References: <1403246832932-35023.post@n7.nabble.com>
In-Reply-To: <1403246832932-35023.post@n7.nabble.com>
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
To: metaverse <metaverse@artikel-140.nl>, xfs@oss.sgi.com

On 6/20/14, 1:47 AM, metaverse wrote:
> Last week a harddrive in a NAS crashed in our office.  Long story short: We
> have been trying everything. In the end we where able to pull an image of
> the hard drive. Also we found out there's no superblock or secondary blocks.
> Since I have recovered successfully the data I was wondering if it was
> possible to create a new superblock and secondary block. If not I'll create
> a new partition and place all the data back. 

Not really enough info to go on here.  How did you recover the data if
you have no valid superblock?

If you've got your data back, just mkfs a fresh filesystem and repopulate it.

Or by "recovered the data" do you just mean you have a dd image of the broken
drive?

> Scary that only a power outage can do this...

It shouldn't, unless the storage was configured in an unreliable way.

> TL;DR: Is it possible to create a new superblock from scratch?

Not in general, but rather than jumping to the proposed solution, perhaps
it would be better to describe the problem in detail:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

At an absolute bare minimum, what happened when you ran xfs_repair?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
