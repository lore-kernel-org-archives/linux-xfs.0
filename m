Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4547C801D
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 16:19:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8709DAC002
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 14:19:15 -0800 (PST)
Received: from radon.swed.at (a.ns.miles-group.at [95.130.255.143]) by
	cuda.sgi.com with ESMTP id MTJDcR56Tt815L48 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 14:19:11 -0800 (PST)
Date: Sun, 3 Mar 2013 23:19:05 +0100
From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] Do not check ocfs2
Message-ID: <20130303231905.0efd6d08@spider.haslach.nod.at>
In-Reply-To: <5133C900.9050300@sandeen.net>
References: <1362269150-21478-1-git-send-email-richard@nod.at>
	<20130303011917.GI23616@dastard>
	<20130303100254.500b076f@spider.haslach.nod.at>
	<5133C900.9050300@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Am Sun, 03 Mar 2013 16:04:48 -0600
schrieb Eric Sandeen <sandeen@sandeen.net>:
 > > Using xfstests I was able to trigger dlm issues in ocfs2.
> > I ran xfstests on one node and other nodes had it mounted too.
> 
> Just for my own education, how does that happen?
> 
> Were you testing on filesystems already configured into a cluster,
> or did the cluster somehow pick up your newly-defined test
> fileystems and mount them?

The cluster is already configured. But a single node can mount/unmount
the fs as it wants.

I know, xfstests is not a perfect test case for ocfs2 but it allowed me
to trigger issues...
These issues can also be triggered without xfstests. But in my case I
found them using xfstests.

> How does fsck.ocfs2 behave when you run it on one node, when the
> fs is mounted on others?  Will it proceed w/ no knowledge of the
> fact that it's mounted elsewhere?

It refuses to check the fs and exists with an error code != 0.

>From the manpage:
       -F     By default fsck.ocfs2 will check with the cluster
services to ensure that the volume is not in-use (mounted) on any node
in the cluster before proceeding.  -F skips this check and should only
be used when it can be guaranteed that the volume is not mounted on any
node in the cluster. WARNING: If the cluster check is disabled and the
volume  is mounted on one or more nodes, file system corruption is very
likely. If unsure, do not use this option.

Thanks,
//richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
