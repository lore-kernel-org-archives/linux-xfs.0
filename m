Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B08DC7F4E
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 18:39:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DCBCAC001
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 16:39:22 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HySej8csMwBrFy33 for <xfs@oss.sgi.com>;
	Sun, 03 Nov 2013 16:39:20 -0800 (PST)
Date: Mon, 4 Nov 2013 11:39:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to use increased number of ACL entries?
Message-ID: <20131104003915.GN6188@dastard>
References: <20131103081704.GE9974@fit.vutbr.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131103081704.GE9974@fit.vutbr.cz>
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
To: Kasparek Tomas <kasparek@fit.vutbr.cz>
Cc: xfs@oss.sgi.com

On Sun, Nov 03, 2013 at 09:17:04AM +0100, Kasparek Tomas wrote:
> Hello,
> 
> I'm trying to get more then 25 ACLs entries to work according to
> http://oss.sgi.com/pipermail/xfs/2013-May/026544.html . I'm running 3.10.x
> kernel which seems to contain these changes. I understand, that this is
> on-disk format change, so I expect to need new xfsprogs too. I tried the
> version from CentOS 6.4 (3.1.1) and one from git repo (
> git://oss.sgi.com/xfs/cmds/xfsprogs), but still it fails to create more then
> 25 ACL entries (21 user defined). Is there something I'm still missing?

You haven't told mkfs to change the on disk format to enable more
than 25 ACLs. Only the version from git will do it, and your CentOS
kernel will not support it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
