Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AEGPK8192239 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 09:16:26 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2EA51BB3CF4
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 07:16:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RQHiCavpDQpLw5gi for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 07:16:23 -0700 (PDT)
Date: Thu, 11 Aug 2011 00:16:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110810141619.GA26978@dastard>
References: <20110806122556.GB20341@schmorp.de> <20110807102625.GJ3162@dastard>
	<20110808190222.GB7087@schmorp.de> <201108091210.50204@zmi.at>
	<20110809111526.GA7631@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110809111526.GA7631@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Tue, Aug 09, 2011 at 01:15:27PM +0200, Marc Lehmann wrote:
> On Tue, Aug 09, 2011 at 12:10:48PM +0200, Michael Monnerie <michael.monnerie@is.it-management.at> wrote:
> > (rw,nodiratime,relatime,logbufs=8,logbsize=256k,attr2,barrier,largeio,swalloc)
> > and sometimes also 
> > ,allocsize=64m
> 
> As has been reported on this list, this option is really harmful on
> current xfs - in my case, it lead to xfs causing ENOSPC even when the disk
> was 40% empty (~188gb).

Seeing you keep stating this is a problem, I'll ask again whether
commit 778e24b ("xfs: reset inode per-lifetime state when recycling
it") fixed this problem for you?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
