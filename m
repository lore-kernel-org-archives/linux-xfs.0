Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 09:12:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IGBvXZ005982
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:11:58 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6B91CE6AF4
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:12:54 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id tEslOOzGkEfoZSw4 for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 09:12:54 -0700 (PDT)
Date: Thu, 19 Jun 2008 02:12:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: 2.6.26-rc6 link count mismatch for inode
Message-ID: <20080618161252.GV3700@disturbed>
References: <BAY103-DAV69C0718B7EDB534D9337FB2A90@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV69C0718B7EDB534D9337FB2A90@phx.gbl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 16, 2008 at 11:11:31AM +0200, Marco Berizzi wrote:
> Hi Folk,
> 
> I was tring to compile firefox 3.0rc3
> and while I was erasing a previous
> /tmp/mozilla tree, I started a new
> tar xjf mozilla-blabla.
> After a while linux 2.6.26-rc6 was
> unresponsive: I have unplugged the
> power cable. No problem at startup,
> but:

What are your mount options? Are you using barriers (what does XFS
output in dmesg when mounting the filesystem)?  I ask because I've
seen this sort of directory corruption before when using volatile
write caches and yanking the power....

i.e. the corruption could have been caused by the way you reset the
system, not because of the hang. Do you have any information on what
caused the hang?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
