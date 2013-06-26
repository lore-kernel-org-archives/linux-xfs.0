Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD7EE7F51
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 11:30:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD4A78F8040
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 09:30:53 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Wks7ymIdzOHjddGF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 09:30:52 -0700 (PDT)
Date: Wed, 26 Jun 2013 12:30:44 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH] xfstests: 313,314: user namespace uid/gids in inode, ACL
Message-ID: <20130626123044.2fc6ee53@oracle.com>
In-Reply-To: <20130626010931.GA29376@dastard>
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 26 Jun 2013 11:09:31 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jun 25, 2013 at 03:34:43PM -0400, Dwight Engen wrote:
> > These tests verify that the uid/gids in an inode and in ACLs get
> > translated from/to a user namespace to/from disk correctly.
> > 
> > I had to use getfacl instead of the chacl -l because I need numeric
> > uids to make the output consistent.
> > 
> > A new program nsexec was added to facilitate creating/entering a
> > user namespace for testing. The orignal source for the program is
> > https://lwn.net/Articles/539940. I added the -s option to become
> > "root" in the user namespace.
> > 
> > Tested against btrfs, ext4, and xfs with my proposed user namespace
> > changes.
> 
> Can you split it out into a patch per test? It's easier to review
> that way...

Sure, I'll split out adding the nsexec program separately as well.

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
