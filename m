Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SNdOxi013727 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 18:39:24 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C86FC1775C6D
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 16:39:23 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id cMCyui3uoVX53ATl for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 16:39:23 -0700 (PDT)
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5SNGRc0001663
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 19:16:27 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5SNdMbw1658906
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 19:39:22 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5SJdAEx032003 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 16:39:10 -0300
Subject: Re: xfstests test case 180 fails often
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1308259762.2717.31.camel@doink>
References: <1308077464.7661.473.camel@chandra-lucid.beaverton.ibm.com>
	<1308259762.2717.31.camel@doink>
Date: Tue, 28 Jun 2011 16:39:21 -0700
Message-ID: <1309304361.5505.6211.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: aelder@sgi.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

Hi Alex,

I tried git bisect and it ended up in a qla2xxx fix (and I do not even
have qlogic card in that system).

I did it couple more times and landed on different patches.

My latest (fourth ot fifth, I forgot :) bisect landed on the patch with
commit 546a1924224078c6f582e68f890b05b387b42653 ( writeback:
write_cache_pages doesn't terminate at nr_to_write <= 0)

I verified that this is valid patch by running the test script 180 for
nearly 500 times on the tree just prior to this patch.
 
chandra
On Thu, 2011-06-16 at 16:29 -0500, Alex Elder wrote:
> On Tue, 2011-06-14 at 11:51 -0700, Chandra Seetharaman wrote:
> > Hello All,
> > 
> > test case 180 fails often (4 out of 5) in my x86_64 system.
> > Any suggestions on how to proceed to debug ?
> 
> I have been seeing failures like that sometimes
> (more often recently I think) for a while.  I
> have not had the chance to really chase it down.
> 
> If you can reproduce it pretty relibly you could
> use "git bisect" to try to find out whether the
> failures started to occur after a particular
> commit.
> 
> 					-Alex
> 
> > regards,
> > 
> > chandra
> > 
> > 80 176s ... - output mismatch (see 180.out.bad)^M
> > --- 180.out     2011-04-20 08:34:36.000000000 -0700^M
> > +++ 180.out.bad 2011-06-03 14:10:45.000000000 -0700^M
> > @@ -1 +1,4 @@^M
> >  QA output created by 180^M
> > +file /mnt/xfsScratchMntPt/656 has incorrect size - sync failed^M
> > +file /mnt/xfsScratchMntPt/818 has incorrect size - sync failed^M
> > +file /mnt/xfsScratchMntPt/899 has incorrect size - sync failed^M
> > Ran: 180^M
> > Failures: 180^M
> > Failed 1 of 1 tests^M
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
