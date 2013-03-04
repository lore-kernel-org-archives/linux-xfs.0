Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C0627802E
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 18:46:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F012AC003
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 16:46:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	35bThwSScwRS7Z6y for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 16:46:35 -0800 (PST)
Date: Mon, 4 Mar 2013 11:42:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Do not check ocfs2
Message-ID: <20130304004229.GK23616@dastard>
References: <1362269150-21478-1-git-send-email-richard@nod.at>
	<20130303011917.GI23616@dastard>
	<20130303100254.500b076f@spider.haslach.nod.at>
	<5133C900.9050300@sandeen.net>
	<20130303231905.0efd6d08@spider.haslach.nod.at>
	<5133D15A.9010600@sandeen.net>
	<20130303235341.7470085e@spider.haslach.nod.at>
	<5133D573.3050106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5133D573.3050106@sandeen.net>
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
Cc: linux-fsdevel@vger.kernel.org, Richard Weinberger <richard@nod.at>, xfs@oss.sgi.com

On Sun, Mar 03, 2013 at 04:57:55PM -0600, Eric Sandeen wrote:
> On 3/3/13 4:53 PM, Richard Weinberger wrote:
> 
> >> Anyway, what if you did something more along the lines of [pseudocode]
> >>
> >> ocfs2)
> >> 	if mounted.ocfs2 -f $TEST-DEV | frob_as_necessary[1]
> >> 		;
> >> 	else
> >> 		fsck.ocfs2 $TEST-DEV
> >> 	fi
> >> 	;;
> >>
> >> so that *if* it's mounted on some other node, the fsck won't run.
> >> That has downsides as Dave mentioned, but for the case where the
> >> xfstests node is the only one with it in use, it'll still do the
> >> beneficial consistency check.
> >>
> >> Just tweaking the fsck action bsed on *if* it's mounted (or,
> >> maybe, if the node is in a cluster?) might be a more generic solution
> >> that is widely applicable to all ocfs2 test environments.
> > 
> > Good point. mounted.ocfs2 really makes sense. I'll implement this on my
> > test suite and submit a new patch.
> 
> Sounds good to me.
> 
> It'd be most preferable to do a cluster-wide unmount and fsck,

Which makes no sense to me, because ./check will then do a cluster
wide unmount as it runs the test harness initialisation. Hence all
the subsequent tests will run with the filesystem only mounted on
the local node....

Really, xfstests is not designed for testing cluster filesystems in
clustered environments. If we really want to support clustered
filesystems and cluster wide operations, then we need to think
about how to architect multi-host support into xfstests sanely.
Clustered filesystems are not the only people that could make use of
such functionality (NFS and CIFS come to mind).... ;)

Cheers,

Dave/
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
