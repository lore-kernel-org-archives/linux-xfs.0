Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E5CE29DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 20:32:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B0B330407F
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 18:32:42 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id kHkLO4jvwAG5y93m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 18:32:40 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4F7497C067C
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 19:32:40 -0600 (MDT)
Date: Thu, 25 Apr 2013 21:32:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [BULK]  Re: [PATCH] xfstests 311: test fsync with dm flakey V2
Message-ID: <20130426013237.GO2631@localhost.localdomain>
References: <1366899176-12876-1-git-send-email-jbacik@fusionio.com>
	<20130425224556.GS30622@dastard>
	<20130426002404.GN2631@localhost.localdomain>
	<20130426010829.GV30622@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130426010829.GV30622@dastard>
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
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Josef Bacik <JBacik@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Apr 25, 2013 at 07:08:29PM -0600, Dave Chinner wrote:
> On Thu, Apr 25, 2013 at 08:24:04PM -0400, Josef Bacik wrote:
> > On Thu, Apr 25, 2013 at 04:45:56PM -0600, Dave Chinner wrote:
> > > On Thu, Apr 25, 2013 at 10:12:56AM -0400, Josef Bacik wrote:
> .....
> > > > +	$here/src/fsync-tester -s $SEED -r -t $test_num $extra $testfile
> > > > +	if [ $? -ne 0 ]; then
> > > > +		_unmount_flakey
> > > > +		_cleanup
> > > > +		exit
> > > > +	fi
> > > > +
> > > > +	_md5_checksum $testfile
> > > > +	_drop_writes
> > > > +	_unmount_flakey
> > > 
> > > So, _drop_writes suspends the dm-flakey device, freezes the
> > > filesystem, turns off writes then thaws the filesystem, right?
> > >
> > > If so, doesn't that mean you're not actually testing fsync() as the
> > > freeze will effectively sync the entire filesystem before you start
> > > dropping writes?
> > > 
> > > I can see why you want to stop unmount from writing back metadata to
> > > simulate a crash, but if you've already frozen the filesystem then
> > > writeback has already occurred before you stop the writes. So I
> > > can't see how this is actually testing fsync - what it appears to be
> > > testing is the fileystem freeze code...
> > > 
> > > [ This is precisely the issue that XFS shutdown ioctls deal with to
> > > trigger an immediate forced shutdown of the filesystem that prevents
> > > *any* further writes from being issued by the filesystem - no sync
> > > operations get in the way and change the state of the filesystem
> > > after then fsync call, so we know that what is on disk is what was
> > > written by the sync/fsync calls being tested.
> > > 
> > > This is how we test sync/fsync in other XFS tests (e.g.
> > > xfs/137-140), and this is the reason why us XFS people have
> > > suggested that other filesystems should implement the ioctls for
> > > this functionality rather than try to invent new ways of trying
> > > to stop filesystems from writing back dirty metadata for fsync/sync
> > > testing....
> > > 
> > > Besides, if a corruption is detected, you need a method of stopping
> > > all dirty metadata from being written back in the filesystem to
> > > prevent propagation of the corruption.  These ioctls should just be
> > > an interface into that mechanism. ]
> > >
> > 
> > So I need to look at what this does.  I don't think it freezes the file system,
> 
> `dmsetup suspend` ends up in dm_suspend(). This calls lock_fs(), which
> calls freeze_bdev()....
> 
> If you do `dmsetup suspend --nolockfs` then it won't freeze the
> filesystem during the suspend...
>

Ok so I think I'll just make this test do all the iterations of the fsync tester
with and without --nolockfs, since without --nolockfs I'm still seeing problems,
does that sound reasonable?
 
> > because I've run this test and I definitely have a tree log on the file system
> > after I unmount, which means we didn't actually sync().  Either that or freeze()
> > is broken for btrfs and it's not actually causing the transaction to commit.
> 
> Entirely possible.
> 
> /me muses randomly about why we call them bugs when they are almost
> always layered like onions.....
> 

No kidding, I've spent all week unraveling various problems that this test has
uncovered.

> > If
> > it turns out that it is freeze() then it's not actually a fsync tester, but it
> > seems to still be a valid test since it's definitely causing problems for all
> > the file systems I've tested and I'll leave this as it is and then write another
> > real fsync tester.
> 
> ext4 as well?
>

Yeah ext4 blows up right after the first test, the md5sums match but fsck
complains loudly.
 
> > > How long does this take to run? It seems like the quick group would
> > > be appropriate if it takes less than a minute. Also, fsync tests
> > > fall under the category of "metadata" and "log", so they probably
> > > should be added, too.
> > > 
> > 
> > It takes 66 seconds to run on btrfs, is that fast enough for quick?  I'll add
> > metadata and log to the list as well.  Thanks for the thorough review,
> 
> Probably a bit too long for my liking - it won't be quick when there
> are several instances of VMs running xfstests on the same set of
> spindles....
> 

Yeah I had quick originally but when I finally got it to run I took it out since
66 seconds seemed too long to me.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
