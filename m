Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A87867F8A
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 15:00:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 884F830405F
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 13:00:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	dffXEx3gw4oRZKvN for <xfs@oss.sgi.com>;
	Tue, 30 Sep 2014 13:00:52 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XZ3bK-000763-9N
	for xfs@oss.sgi.com; Wed, 01 Oct 2014 06:00:46 +1000
Date: Wed, 1 Oct 2014 06:00:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Why not move xfs infra-structure to "public" services
Message-ID: <20140930200046.GQ4758@dastard>
References: <20140930141857.GA2053@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140930141857.GA2053@localhost.localdomain>
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
To: xfs@oss.sgi.com

On Tue, Sep 30, 2014 at 11:18:57AM -0300, Carlos Maiolino wrote:
> Hi guys,
> 
> I'm sorry for this kind of "fancy" question from my side, but I'm wondering why
> xfs project infra-structure (mailing list, git trees), does not use the "usual
> public" services. I mean, does anyone thought about moving xfs mailing list to
> vger.kernel.org, and the git trees to git.kernel.org?

I'm already using git.kernel.org for my master XFS trees. The ones
on oss.sgi.com are simply now downstream mirrors. There's still a
few things I need to organise (e.g. where release tarballs are put)
before we make the kernel.org trees the official source of XFS
source code.

We already have a linux-xfs@vger.kernel.org mailing list - we just
don't use it. Again, more organisation stuff to do to switch over
(i.e. forwarding from xfs@oss.sgi.com to the vger list) and then
updating documentation everywhere and getting people to start using
it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
