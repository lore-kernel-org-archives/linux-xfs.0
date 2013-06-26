Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D93277F3F
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 20:10:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B947430405F
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 18:10:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sriDGvLXeUF7EztJ for <xfs@oss.sgi.com>;
	Tue, 25 Jun 2013 18:10:23 -0700 (PDT)
Date: Wed, 26 Jun 2013 11:09:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 313,314: user namespace uid/gids in inode, ACL
Message-ID: <20130626010931.GA29376@dastard>
References: <20130625153443.08142635@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130625153443.08142635@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 25, 2013 at 03:34:43PM -0400, Dwight Engen wrote:
> These tests verify that the uid/gids in an inode and in ACLs get translated
> from/to a user namespace to/from disk correctly.
> 
> I had to use getfacl instead of the chacl -l because I need numeric uids
> to make the output consistent.
> 
> A new program nsexec was added to facilitate creating/entering a user
> namespace for testing. The orignal source for the program is
> https://lwn.net/Articles/539940. I added the -s option to become "root"
> in the user namespace.
> 
> Tested against btrfs, ext4, and xfs with my proposed user namespace changes.

Can you split it out into a patch per test? It's easier to review
that way...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
