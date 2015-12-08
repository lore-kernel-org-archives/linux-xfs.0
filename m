Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA75D7F50
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 16:52:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A71BA30405F
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 14:52:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	W31nxOaE4r3C1dr1 for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 14:52:25 -0800 (PST)
Date: Wed, 9 Dec 2015 09:52:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata corruption detected at xfs_attr3_leaf_write_verify /
	Internal error xfs_attr3_leaf_write_verify
Message-ID: <20151208225221.GF19802@dastard>
References: <5666F521.5060602@3qmedien.net> <20151208205759.GE19802@dastard>
	<56675637.2050608@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56675637.2050608@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Dec 08, 2015 at 04:14:15PM -0600, Eric Sandeen wrote:
> 
> 
> On 12/8/15 2:57 PM, Dave Chinner wrote:
> > On Tue, Dec 08, 2015 at 04:20:01PM +0100, Dietmar Putz wrote:
> >> similar reports are existing :
> >> http://oss.sgi.com/archives/xfs/2015-11/msg00459.html
> >> https://bugs.launchpad.net/ubuntu/+source/linux-lts-trusty/+bug/1468039
> > 
> > Following a  couple of clicky links in that bug leads to:
> > 
> > http://oss.sgi.com/archives/xfs/2015-06/msg00457.html
> > 
> > in which I comment:
> > 
> > | Probably fixed by commit c88547a ("xfs: fix directory hash ordering
> > | bug"), which also affected attributes in leaf format.
> > 
> > Hence this was probably fixed in 3.15 and pushed back to 3.13.11i
> > via th eupstream stable kernel process. I have no idea if the ubuntu
> > maintainers have added that fix to their kernel...
> 
> But:
> 
> > After upgrade to kernel 3.19.0-39 the error message turns from "Internal error xfs_attr3_leaf_write_verify...." to 
> > "Metadata corruption detected at xfs_attr3_leaf_write_verify..." as shown below for gluster-ger-ber-11-int.
> 
> and that's 3.19 ...?  (and repair found nothing on-disk?)

Ah, missed that. too early in the morning/not enough coffee.

I guess we need a reproducer at this point, then...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
