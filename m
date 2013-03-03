Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BE1D8024
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 16:53:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53EEA304032
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 14:53:46 -0800 (PST)
Received: from radon.swed.at (a.ns.miles-group.at [95.130.255.143]) by
	cuda.sgi.com with ESMTP id zPSc37d8dpUsPZqF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 14:53:44 -0800 (PST)
Date: Sun, 3 Mar 2013 23:53:41 +0100
From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] Do not check ocfs2
Message-ID: <20130303235341.7470085e@spider.haslach.nod.at>
In-Reply-To: <5133D15A.9010600@sandeen.net>
References: <1362269150-21478-1-git-send-email-richard@nod.at>
	<20130303011917.GI23616@dastard>
	<20130303100254.500b076f@spider.haslach.nod.at>
	<5133C900.9050300@sandeen.net>
	<20130303231905.0efd6d08@spider.haslach.nod.at>
	<5133D15A.9010600@sandeen.net>
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

Am Sun, 03 Mar 2013 16:40:26 -0600
schrieb Eric Sandeen <sandeen@sandeen.net>:
> On 3/3/13 4:19 PM, Richard Weinberger wrote:
> > Am Sun, 03 Mar 2013 16:04:48 -0600
> > schrieb Eric Sandeen <sandeen@sandeen.net>:
> >  > > Using xfstests I was able to trigger dlm issues in ocfs2.
> >>> I ran xfstests on one node and other nodes had it mounted too.
> >>
> >> Just for my own education, how does that happen?
> >>
> >> Were you testing on filesystems already configured into a cluster,
> >> or did the cluster somehow pick up your newly-defined test
> >> fileystems and mount them?
> > 
> > The cluster is already configured. But a single node can
> > mount/unmount the fs as it wants.
> 
> Ok, so:
> a) your cluster is already configured, and 
> b) other nodes can mount cluster filesystems

Correct.
 
> Sure, but - how *did* other nodes mount your xfstest filesystems?
> Or did you configure xfstests to use something already configured
> to be mounted on multiple nodes?
> 
> Perhaps another related question - did the fs *need* to be mounted
> on other nodes to expose the problems you found?

Yes, seems so.

> I'm just trying to understand if this is a common case, or unique to
> how you have configured things.
> 
> > I know, xfstests is not a perfect test case for ocfs2 but it
> > allowed me to trigger issues...
> > These issues can also be triggered without xfstests. But in my case
> > I found them using xfstests.
> 
> I understand, I'm not suggesting that you not run xfstests; I'm sure
> it is useful.  It's supposed to be.  :)  We just need to keep it
> useful & not disable the consistency checks unless it's necessary.

Fair point.

> >> How does fsck.ocfs2 behave when you run it on one node, when the
> >> fs is mounted on others?  Will it proceed w/ no knowledge of the
> >> fact that it's mounted elsewhere?
> > 
> > It refuses to check the fs and exists with an error code != 0.
> 
> Ok, then that confuses me a little, because earlier you said:
> 
> > To ensure that fsck.ocfs2 will not corrupt the filesystem 
> 
> but just now you said it won't run at all?  Anyway...

In the first test run I faced a filesystem corruption and blamed
fsck.ocfs2. After writing the mail I realized that fsck.ocfs2 aborted
and the corruption came from another issue.
Sorry for being imprecise.

> > From the manpage:
> >        -F     By default fsck.ocfs2 will check with the cluster
> > services to ensure that the volume is not in-use (mounted) on any
> > node in the cluster before proceeding.  -F skips this check and
> > should only be used when it can be guaranteed that the volume is
> > not mounted on any node in the cluster. WARNING: If the cluster
> > check is disabled and the volume  is mounted on one or more nodes,
> > file system corruption is very likely. If unsure, do not use this
> > option.
> 
> Ok, but xfstests wasn't *using* -F was it?

Correct.

> Anyway, what if you did something more along the lines of [pseudocode]
> 
> ocfs2)
> 	if mounted.ocfs2 -f $TEST-DEV | frob_as_necessary[1]
> 		;
> 	else
> 		fsck.ocfs2 $TEST-DEV
> 	fi
> 	;;
> 
> so that *if* it's mounted on some other node, the fsck won't run.
> That has downsides as Dave mentioned, but for the case where the
> xfstests node is the only one with it in use, it'll still do the
> beneficial consistency check.
> 
> Just tweaking the fsck action bsed on *if* it's mounted (or,
> maybe, if the node is in a cluster?) might be a more generic solution
> that is widely applicable to all ocfs2 test environments.

Good point. mounted.ocfs2 really makes sense. I'll implement this on my
test suite and submit a new patch.

> Thanks,
> -Eric
> 
> [1] I know next to nothing about ocfs2, but presumably one can detect
> if the device in question is configured into, or mounted in, a
> cluster?

I'll find out!

Thanks,
//richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
