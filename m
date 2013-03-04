Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A965D804E
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 15:05:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68D25304059
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 13:05:40 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id wcXrzqhxV7GRrDkG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 13:05:38 -0800 (PST)
Date: Mon, 4 Mar 2013 13:05:23 -0800
From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH] Do not check ocfs2
Message-ID: <20130304210522.GA7783@localhost>
References: <1362269150-21478-1-git-send-email-richard@nod.at>
	<20130303011917.GI23616@dastard>
	<20130303100254.500b076f@spider.haslach.nod.at>
	<5133C900.9050300@sandeen.net>
	<20130303231905.0efd6d08@spider.haslach.nod.at>
	<5133D15A.9010600@sandeen.net>
	<20130303235341.7470085e@spider.haslach.nod.at>
	<5133D573.3050106@sandeen.net> <20130304004229.GK23616@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130304004229.GK23616@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Mar 04, 2013 at 11:42:29AM +1100, Dave Chinner wrote:
> On Sun, Mar 03, 2013 at 04:57:55PM -0600, Eric Sandeen wrote:
> > On 3/3/13 4:53 PM, Richard Weinberger wrote:
> > 
> > >> Anyway, what if you did something more along the lines of [pseudocode]
> > >>
> > >> ocfs2)
> > >> 	if mounted.ocfs2 -f $TEST-DEV | frob_as_necessary[1]
> > >> 		;
> > >> 	else
> > >> 		fsck.ocfs2 $TEST-DEV
> > >> 	fi
> > >> 	;;
> > >>
> > >> so that *if* it's mounted on some other node, the fsck won't run.
> > >> That has downsides as Dave mentioned, but for the case where the
> > >> xfstests node is the only one with it in use, it'll still do the
> > >> beneficial consistency check.
> > >>
> > >> Just tweaking the fsck action bsed on *if* it's mounted (or,
> > >> maybe, if the node is in a cluster?) might be a more generic solution
> > >> that is widely applicable to all ocfs2 test environments.
> > > 
> > > Good point. mounted.ocfs2 really makes sense. I'll implement this on my
> > > test suite and submit a new patch.
> > 
> > Sounds good to me.
> > 
> > It'd be most preferable to do a cluster-wide unmount and fsck,
> 
> Which makes no sense to me, because ./check will then do a cluster
> wide unmount as it runs the test harness initialisation. Hence all
> the subsequent tests will run with the filesystem only mounted on
> the local node....
> 
> Really, xfstests is not designed for testing cluster filesystems in
> clustered environments. If we really want to support clustered
> filesystems and cluster wide operations, then we need to think
> about how to architect multi-host support into xfstests sanely.
> Clustered filesystems are not the only people that could make use of
> such functionality (NFS and CIFS come to mind).... ;)

I'm much happier with the "check for other cluster mounts" approach
rather than avoiding fsck entirely.  We like xfstests in the local or
single-node cases to behave exactly as one would expect.

We do run xfstests on multiple nodes in a cluster, but by hand and with
our own cleanup.  Obviously support for automating that would be awesome
:-)

Joel

> 
> Cheers,
> 
> Dave/
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

			http://www.jlbec.org/
			jlbec@evilplan.org

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
