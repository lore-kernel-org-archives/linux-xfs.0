Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E0A37CB3
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 12:01:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5888BAC001
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 10:01:11 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EL9nop1rgBVPN6Dy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 10:01:05 -0800 (PST)
Date: Wed, 2 Mar 2016 10:00:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] [RFC] xfs: allocate log vector buffers outside CIL
	context lock
Message-ID: <20160302180055.GE27973@birch.djwong.org>
References: <1453177919-17849-1-git-send-email-david@fromorbit.com>
	<20160120015853.GU6033@dastard>
	<20160126141733.GA48264@bfoster.bfoster>
	<CADr68Wa9vG=ZOn4gbHezEyOeM+tCo69s3WVqcVXnZrn+=DdoVA@mail.gmail.com>
	<20160214001645.GF14668@dastard>
	<CADr68WZZHSEexV4aBDNhLjE1oNAHftfORCGCA-q7WH2DY8X9xg@mail.gmail.com>
	<20160215132824.GH14668@dastard>
	<CA+eFSM0iQjwJcPwxrfdpLepdDovFtpkTA7u07DBWJg1dqGsHVw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+eFSM0iQjwJcPwxrfdpLepdDovFtpkTA7u07DBWJg1dqGsHVw@mail.gmail.com>
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
To: Gavin Guo <gavin.guo@canonical.com>
Cc: Jens Rosenboom <j.rosenboom@x-ion.de>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Wed, Mar 02, 2016 at 08:45:46PM +0800, Gavin Guo wrote:
> On Mon, Feb 15, 2016 at 9:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Feb 15, 2016 at 12:57:51PM +0100, Jens Rosenboom wrote:
> >> 2016-02-14 1:16 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> >> > On Sat, Feb 13, 2016 at 06:09:17PM +0100, Jens Rosenboom wrote:
> >> >> 2016-01-26 15:17 GMT+01:00 Brian Foster <bfoster@redhat.com>:
> >> >> > On Wed, Jan 20, 2016 at 12:58:53PM +1100, Dave Chinner wrote:
> >> >> We have seen this issue on our production Ceph cluster sporadically
> >> >> and have tried a long time to reproduce it in a lab environment.
> >> > ....
> >> >> kmem_alloc (mode:0x2408240)
> >> >> Feb 13 10:51:57 storage-node35 kernel: [10562.614089] XFS:
> >> >> ceph-osd(10078) possible memory allocation deadlock size 32856 in
> >> >> kmem_alloc (mode:0x2408240)
> >> >
> >> > High order allocation of 32k. That implies a buffer size of at least
> >> > 32k is in use. Can you tell me what the output of xfs_info <mntpt>
> >> > is for one of your filesystems?
> >>
> >> $ xfs_info /tmp/cbt/mnt/osd-device-0-data/
> >> meta-data=/dev/sda2              isize=2048   agcount=4, agsize=97370688 blks
> >>          =                       sectsz=512   attr=2, projid32bit=1
> >>          =                       crc=0        finobt=0
> >> data     =                       bsize=4096   blocks=389482752, imaxpct=5
> >>          =                       sunit=0      swidth=0 blks
> >> naming   =version 2              bsize=65536  ascii-ci=0 ftype=0
> >> log      =internal               bsize=4096   blocks=190177, version=2
> >>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
> > OK, so 64k directory block size.
> >
> >> > I suspect you are using a 64k directory block size, in which case
> >> > I'll ask "are you storing millions of files in a single directory"?
> >> > If your answer is no, then "don't do that" is an appropriate
> >> > solution because large directory block sizes are slower than the
> >> > default (4k) for almost all operations until you get up into the
> >> > millions of files per directory range.
> >>
> >> These options are kind of standard folklore for setting up Ceph
> >> clusters, I must admit that I delayed testing their performance
> >> implications up to now, so many knobs to turn, so little time.
> >>
> >>   mkfs_opts: '-f -i size=2048 -n size=64k'
> >>   mount_opts: '-o inode64,noatime,logbsize=256k'
> >
> > /me shakes his head sadly.
> >
> > Can you please go nuke where ever you read that from orbit?  Please?
> > It's the only way to be sure that the contagious cargo-cult
> > stupidity doesn't spread further.
> >
> >> It turns out that when running with '-n size=4k'
> >
> > i.e. the default.
> >
> >> , indeed I do not get
> >> any warnings during a 10h test run. I'll try to come up with some more
> >> detailed benchmarking of the possible performance impacts, too.
> >
> > No surprise there. :/
> >
> > FWIW, for small file Ceph workloads (e.g swift stores) we've found
> > that 8k directory block sizes give marginal improvements over the
> > default 4k, but it's all down hill from there.
> >
> >> Am I right in assuming that this parameter can not be tuned after the
> >> initial mkfs?
> >
> > That's right.
> >
> >> In that case getting a production-ready version of your
> >> patch would probably still be valuable for cluster admins wanting to
> >> avoid having to move all of their data to new filesystems.
> >
> > Well, yes, that's why I'm working on it. But it's critical core
> > code, it's also damn tricky and complex, and if I get it wrong it
> > will corrupt filesystems. So I'm not going to rush a prototype fix
> > out into production systems no matter how much pressure people put
> > on me to ship a fix.
> >
> >> >> Soon after this, operations get so slow that the OSDs die because of
> >> >> their suicide timeouts.
> >> >>
> >> >> Then I installed onto 3 servers this patch (applied onto kernel
> >> >> v4.4.1). The bad news is that I am still getting the kernel messages
> >> >> on these machines. The good news, though, is that they appear at a
> >> >> much lower frequency and also the impact on performance seems to be
> >> >> lower, so the OSD processes on these three nodes did not get killed.
> >> >
> >> > Right, the patch doesn't fix the underlying issue that memory
> >> > fragmentation can prevent high order allocation from succeeding for
> >> > long periods.  However, it does ensure that the filesystem does not
> >> > immediately deadlock memory reclaim when it happens so the system
> >> > has a chance to recover. It still can deadlock the filesystem,
> >> > because if we can't commit the transaction we can't unlock the
> >> > objects in the transaction and everything can get stuck behind that
> >> > if there's something sufficiently important in the blocked
> >> > transaction.
> >>
> >> So how would your success criteria for getting this patch into
> >> upstream look like?
> >
> > It's already "successful". I've proved locally that it avoids a memory
> > reclaim deadlock that many people have reported over the past year.
> > So there's no question that we need a fix to the problem; it's now
> > just a matter of determining if the issues with this fix (e.g.
> > doubling memory usage of the CIL) are an acceptible tradeoff for
> > production workloads, or whether I've got to go back and prototype a
> > fourth attempt at fixing the problem...
> >
> > And, of course, there's only some many hours int eh day. I'm into my
> > 19th right now, and I havent' got through everything on my list for
> > today yet. Tomorrow's list is even longer, and when I get through
> > that, I hit the big one: "read, understand and review 10000 lines of
> > complex new code"....
> >
> >> Would a benchmark of the 64k directory block size
> >> case on machines all running with patched kernels be interesting? Or
> >> would that scenario disqualify itself as being mistuned in the first
> >> place?
> >
> > Not really - I've confirmed it doesn't cause performance issues on
> > my usual tranche of benhmarks, so I'mnot conerned about that (it;s
> > the same amount of work being done, anyway).  Correctness is much
> > more important right now, and that takes time, effort and focus to
> > verify.
> >
> > And speaking of focus, it's now time for me to sleep.
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> I've recently backported the patch to the v3.13 kernel to see if the bug
> can be fixed by the patch. Currently, since the bug only can be reproduced
> on the production system, I need to ensure the code work correctly before
> deploying the kernel. The following is the v3.13 backported kernel source:
> 
> http://kernel.ubuntu.com/git/gavinguo/ubuntu-trusty-amd64.git/log/?h=hf00084724v20160219b0hc57647a
> 
> I also did the xfstests verification and the log is attached. There are
> failed 7 of 93 tests. Investigation is still ongoing to determine if these
> errors are related to the file system core functionality failure due to the
> backporting incorrection.
> 
> I'll appreciate if you can give any suggestion to do the testing, give a
> glance to the backported patch or the xfstests error log to see if there is
> any thing wrong.

> ubuntu@xfs-test-vm:~/os/xfstests$ uname -a
> Linux xfs-test-vm 3.13.0-77-generic #121hf00084724v20160219b0hc57647a SMP Fri Feb 19 08:49:18 UTC 20 x86_64 x86_64 x86_64 GNU/Linux
> ubuntu@xfs-test-vm:~/os/xfstests$ TEST_DEV="/dev/vdb" TEST_DIR="/mnt/xfs_mnt/" ./check
> check: QA must be run as root
> ubuntu@xfs-test-vm:~/os/xfstests$ sudo !!
> sudo TEST_DEV="/dev/vdb" TEST_DIR="/mnt/xfs_mnt/" ./check
> sudo: unable to resolve host xfs-test-vm
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 xfs-test-vm 3.13.0-77-generic
> 
> generic/001      3s
> generic/002      0s
> generic/003      [not run] this test requires a valid $SCRATCH_DEV

Got a second hard drive?  Point SCRATCH_DEV to it (and SCRATCH_MNT to a
second empty directory) and you'll get way more testing coverage.

> generic/004      [not run] xfs_io flink support is missing

Heh, old xfsprogs/kernel. :)

(Some of those xfs_repair segfaults are probably fixed in newer xfsprogs...)

--D

> generic/005      0s
> generic/006      0s
> generic/007      1s
> generic/008      [not run] xfs_io fzero support is missing
> generic/009      [not run] xfs_io fzero support is missing
> generic/010      0s
> generic/011      1s
> generic/012      [not run] xfs_io fcollapse support is missing
> generic/013      24s
> generic/014      9s
> generic/015      [not run] this test requires a valid $SCRATCH_DEV
> generic/016      [not run] xfs_io fcollapse support is missing
> generic/017      [not run] this test requires a valid $SCRATCH_DEV
> generic/018      [not run] this test requires a valid $SCRATCH_DEV
> generic/019      [not run] this test requires a valid $SCRATCH_DEV
> generic/020      3s
> generic/021      [not run] xfs_io fcollapse support is missing
> generic/022      [not run] xfs_io fcollapse support is missing
> generic/023      [not run] kernel doesn't support renameat2 syscall
> generic/024      [not run] kernel doesn't support renameat2 syscall
> generic/025      [not run] kernel doesn't support renameat2 syscall
> generic/026      [not run] this test requires a valid $SCRATCH_DEV
> generic/027      [not run] this test requires a valid $SCRATCH_DEV
> generic/028      5s
> generic/029      [not run] this test requires a valid $SCRATCH_DEV
> generic/030      [not run] this test requires a valid $SCRATCH_DEV
> generic/031      [not run] this test requires a valid $SCRATCH_DEV
> generic/032      [not run] this test requires a valid $SCRATCH_DEV
> generic/033      [not run] this test requires a valid $SCRATCH_DEV
> generic/034      [not run] this test requires a valid $SCRATCH_DEV
> generic/035      0s
> generic/036      10s
> generic/037      [not run] this test requires a valid $SCRATCH_DEV
> generic/038      [not run] this test requires a valid $SCRATCH_DEV
> generic/039      [not run] this test requires a valid $SCRATCH_DEV
> generic/040      [not run] this test requires a valid $SCRATCH_DEV
> generic/041      [not run] this test requires a valid $SCRATCH_DEV
> generic/042      [not run] this test requires a valid $SCRATCH_DEV
> generic/043      [not run] this test requires a valid $SCRATCH_DEV
> generic/044      [not run] this test requires a valid $SCRATCH_DEV
> generic/045      [not run] this test requires a valid $SCRATCH_DEV
> generic/046      [not run] this test requires a valid $SCRATCH_DEV
> generic/047      [not run] this test requires a valid $SCRATCH_DEV
> generic/048      [not run] this test requires a valid $SCRATCH_DEV
> generic/049      [not run] this test requires a valid $SCRATCH_DEV
> generic/050      [not run] this test requires a valid $SCRATCH_DEV
> generic/051      [not run] this test requires a valid $SCRATCH_DEV
> generic/052      [not run] this test requires a valid $SCRATCH_DEV
> generic/053      [not run] this test requires a valid $SCRATCH_DEV
> generic/054      [not run] this test requires a valid $SCRATCH_DEV
> generic/055      [not run] this test requires a valid $SCRATCH_DEV
> generic/056      [not run] this test requires a valid $SCRATCH_DEV
> generic/057      [not run] this test requires a valid $SCRATCH_DEV
> generic/058      [not run] xfs_io finsert support is missing
> generic/059      [not run] this test requires a valid $SCRATCH_DEV
> generic/060      [not run] xfs_io finsert support is missing
> generic/061      [not run] xfs_io finsert support is missing
> generic/062      [not run] this test requires a valid $SCRATCH_DEV
> generic/063      [not run] xfs_io finsert support is missing
> generic/064      [not run] this test requires a valid $SCRATCH_DEV
> generic/065      [not run] this test requires a valid $SCRATCH_DEV
> generic/066      [not run] this test requires a valid $SCRATCH_DEV
> generic/067      [not run] this test requires a valid $SCRATCH_DEV
> generic/068      [not run] this test requires a valid $SCRATCH_DEV
> generic/069      [not run] this test requires a valid $SCRATCH_DEV
> generic/070      6s
> generic/071      [not run] this test requires a valid $SCRATCH_DEV
> generic/072      [not run] xfs_io fcollapse support is missing
> generic/073      [not run] this test requires a valid $SCRATCH_DEV
> generic/074      104s
> generic/075      29s
> generic/076      [not run] this test requires a valid $SCRATCH_DEV
> generic/077      [not run] this test requires a valid $SCRATCH_DEV
> generic/078      [not run] kernel doesn't support renameat2 syscall
> generic/079      [not run] this test requires a valid $SCRATCH_DEV
> generic/080      3s
> generic/081      [not run] this test requires a valid $SCRATCH_DEV
> generic/082      [not run] this test requires a valid $SCRATCH_DEV
> generic/083      [not run] this test requires a valid $SCRATCH_DEV
> generic/084      [not run] this test requires a valid $SCRATCH_DEV
> generic/085      [not run] this test requires a valid $SCRATCH_DEV
> generic/086      1s
> generic/087      1s
> generic/088      1s
> generic/089      5s
> generic/090      [not run] this test requires a valid $SCRATCH_DEV
> generic/091      70s
> generic/092      0s
> generic/093      [not run] not suitable for this OS: Linux
> generic/094      [not run] this test requires a valid $SCRATCH_DEV
> generic/095      [not run] this test requires a valid $SCRATCH_DEV
> generic/096      [not run] this test requires a valid $SCRATCH_DEV
> generic/097      [not run] not suitable for this OS: Linux
> generic/098      [not run] this test requires a valid $SCRATCH_DEV
> generic/099      [not run] not suitable for this OS: Linux
> generic/100      [not run] this test requires a valid $SCRATCH_DEV
> generic/101      [not run] this test requires a valid $SCRATCH_DEV
> generic/102      [not run] this test requires a valid $SCRATCH_DEV
> generic/103      [not run] this test requires a valid $SCRATCH_DEV
> generic/104      [not run] this test requires a valid $SCRATCH_DEV
> generic/105      [not run] this test requires a valid $SCRATCH_DEV
> generic/106      [not run] this test requires a valid $SCRATCH_DEV
> generic/107      [not run] this test requires a valid $SCRATCH_DEV
> generic/108      [not run] this test requires a valid $SCRATCH_DEV
> generic/109      [not run] this test requires a valid $SCRATCH_DEV
> generic/110      [not run] xfs_io reflink support is missing
> generic/111      [not run] xfs_io reflink support is missing
> generic/112      35s
> generic/113      39s
> generic/114      53s
> generic/115      [not run] xfs_io reflink support is missing
> generic/116      [not run] xfs_io reflink support is missing
> generic/117      [not run] this test requires a valid $SCRATCH_DEV
> generic/118      [not run] xfs_io reflink support is missing
> generic/119      [not run] xfs_io reflink support is missing
> generic/120      [not run] this test requires a valid $SCRATCH_DEV
> generic/121      [not run] xfs_io dedupe support is missing
> generic/122      [not run] xfs_io dedupe support is missing
> generic/123      1s
> generic/124      [not run] this test requires a valid $SCRATCH_DEV
> generic/125      62s
> generic/126      0s
> generic/127      715s
> generic/128      [not run] this test requires a valid $SCRATCH_DEV
> generic/129      [not run] this test requires a valid $SCRATCH_DEV
> generic/130      [not run] this test requires a valid $SCRATCH_DEV
> generic/131      1s
> generic/132      [not run] this test requires a valid $SCRATCH_DEV
> generic/133      268s
> generic/134      [not run] xfs_io reflink support is missing
> generic/135      [not run] this test requires a valid $SCRATCH_DEV
> generic/136      [not run] xfs_io dedupe support is missing
> generic/137      [not run] xfs_io reflink support is missing
> generic/138      [not run] xfs_io reflink support is missing
> generic/139      [not run] xfs_io reflink support is missing
> generic/140      [not run] xfs_io reflink support is missing
> generic/141      [not run] this test requires a valid $SCRATCH_DEV
> generic/142      [not run] xfs_io reflink support is missing
> generic/143      [not run] xfs_io reflink support is missing
> generic/144      [not run] xfs_io reflink support is missing
> generic/145      [not run] xfs_io reflink support is missing
> generic/146      [not run] xfs_io reflink support is missing
> generic/147      [not run] xfs_io reflink support is missing
> generic/148      [not run] xfs_io reflink support is missing
> generic/149      [not run] xfs_io reflink support is missing
> generic/150      [not run] xfs_io reflink support is missing
> generic/151      [not run] xfs_io reflink support is missing
> generic/152      [not run] xfs_io reflink support is missing
> generic/153      [not run] xfs_io reflink support is missing
> generic/154      [not run] xfs_io reflink support is missing
> generic/155      [not run] xfs_io reflink support is missing
> generic/156      [not run] xfs_io reflink support is missing
> generic/157      [not run] xfs_io reflink support is missing
> generic/158      [not run] xfs_io dedupe support is missing
> generic/159      [not run] xfs_io reflink support is missing
> generic/160      [not run] xfs_io dedupe support is missing
> generic/161      [not run] this test requires a valid $SCRATCH_DEV
> generic/162      [not run] this test requires a valid $SCRATCH_DEV
> generic/163      [not run] this test requires a valid $SCRATCH_DEV
> generic/164      [not run] this test requires a valid $SCRATCH_DEV
> generic/165      [not run] this test requires a valid $SCRATCH_DEV
> generic/166      [not run] this test requires a valid $SCRATCH_DEV
> generic/167      [not run] this test requires a valid $SCRATCH_DEV
> generic/168      [not run] this test requires a valid $SCRATCH_DEV
> generic/169      [not run] this test requires a valid $SCRATCH_DEV
> generic/170      [not run] this test requires a valid $SCRATCH_DEV
> generic/171      [not run] this test requires a valid $SCRATCH_DEV
> generic/172      [not run] this test requires a valid $SCRATCH_DEV
> generic/173      [not run] this test requires a valid $SCRATCH_DEV
> generic/174      [not run] this test requires a valid $SCRATCH_DEV
> generic/175      [not run] this test requires a valid $SCRATCH_DEV
> generic/176      [not run] this test requires a valid $SCRATCH_DEV
> generic/177      [not run] this test requires a valid $SCRATCH_DEV
> generic/178      [not run] xfs_io reflink support is missing
> generic/179      [not run] xfs_io reflink support is missing
> generic/180      [not run] xfs_io reflink support is missing
> generic/181      [not run] xfs_io reflink support is missing
> generic/182      [not run] xfs_io dedupe support is missing
> generic/183      [not run] this test requires a valid $SCRATCH_DEV
> generic/184      0s
> generic/185      [not run] this test requires a valid $SCRATCH_DEV
> generic/186      [not run] this test requires a valid $SCRATCH_DEV
> generic/187      [not run] this test requires a valid $SCRATCH_DEV
> generic/188      [not run] this test requires a valid $SCRATCH_DEV
> generic/189      [not run] this test requires a valid $SCRATCH_DEV
> generic/190      [not run] this test requires a valid $SCRATCH_DEV
> generic/191      [not run] this test requires a valid $SCRATCH_DEV
> generic/192      42s
> generic/193      0s
> generic/194      [not run] this test requires a valid $SCRATCH_DEV
> generic/195      [not run] this test requires a valid $SCRATCH_DEV
> generic/196      [not run] this test requires a valid $SCRATCH_DEV
> generic/197      [not run] this test requires a valid $SCRATCH_DEV
> generic/198      1s
> generic/199      [not run] this test requires a valid $SCRATCH_DEV
> generic/200      [not run] this test requires a valid $SCRATCH_DEV
> generic/201      [not run] this test requires a valid $SCRATCH_DEV
> generic/202      [not run] this test requires a valid $SCRATCH_DEV
> generic/203      [not run] this test requires a valid $SCRATCH_DEV
> generic/204      [not run] this test requires a valid $SCRATCH_DEV
> generic/205      [not run] this test requires a valid $SCRATCH_DEV
> generic/206      [not run] this test requires a valid $SCRATCH_DEV
> generic/207      13s
> generic/208      201s
> umount: /mnt/xfs_mnt: device is busy.
>         (In some cases useful info about processes that use
>          the device is found by lsof(8) or fuser(1))
> _check_xfs_filesystem: filesystem on /dev/vdb has dirty log (see /home/ubuntu/os/xfstests/results//generic/208.full)
> _check_xfs_filesystem: filesystem on /dev/vdb is inconsistent (c) (see /home/ubuntu/os/xfstests/results//generic/208.full)
> _check_xfs_filesystem: filesystem on /dev/vdb is inconsistent (r) (see /home/ubuntu/os/xfstests/results//generic/208.full)
> generic/209      37s
> generic/210      0s
> generic/211      0s
> generic/212      0s
> generic/213      1s
> generic/214      0s
> generic/215      2s
> generic/216      [not run] this test requires a valid $SCRATCH_DEV
> generic/217      [not run] this test requires a valid $SCRATCH_DEV
> generic/218      [not run] this test requires a valid $SCRATCH_DEV
> generic/219      [not run] this test requires a valid $SCRATCH_DEV
> generic/220      [not run] this test requires a valid $SCRATCH_DEV
> generic/221      1s
> generic/222      [not run] this test requires a valid $SCRATCH_DEV
> generic/223      [not run] this test requires a valid $SCRATCH_DEV
> generic/224      [not run] this test requires a valid $SCRATCH_DEV
> generic/225      [not run] this test requires a valid $SCRATCH_DEV
> generic/226      [not run] this test requires a valid $SCRATCH_DEV
> generic/227      [not run] this test requires a valid $SCRATCH_DEV
> generic/228      0s
> generic/229      [not run] this test requires a valid $SCRATCH_DEV
> generic/230      [not run] this test requires a valid $SCRATCH_DEV
> generic/231      [not run] this test requires a valid $SCRATCH_DEV
> generic/232      [not run] this test requires a valid $SCRATCH_DEV
> generic/233      [not run] this test requires a valid $SCRATCH_DEV
> generic/234      [not run] this test requires a valid $SCRATCH_DEV
> generic/235      [not run] this test requires a valid $SCRATCH_DEV
> generic/236      2s
> generic/237      [not run] chacl command not found
> generic/238      [not run] this test requires a valid $SCRATCH_DEV
> generic/239      3s
> generic/240      0s
> generic/241      72s
> generic/242      [not run] this test requires a valid $SCRATCH_DEV
> generic/243      [not run] this test requires a valid $SCRATCH_DEV
> generic/244      [not run] this test requires a valid $SCRATCH_DEV
> generic/245      0s
> generic/246      1s
> generic/247      28s
> _check_dmesg: something found in dmesg (see /home/ubuntu/os/xfstests/results//generic/247.dmesg)
> generic/248      0s
> generic/249      1s
> generic/250      [not run] this test requires a valid $SCRATCH_DEV
> generic/251      [not run] this test requires a valid $SCRATCH_DEV
> generic/252      [not run] this test requires a valid $SCRATCH_DEV
> generic/253      [not run] this test requires a valid $SCRATCH_DEV
> generic/254      [not run] this test requires a valid $SCRATCH_DEV
> generic/255      1s
> generic/256      [not run] this test requires a valid $SCRATCH_DEV
> generic/257      0s
> generic/258      0s
> generic/259      [not run] this test requires a valid $SCRATCH_DEV
> generic/260      [not run] this test requires a valid $SCRATCH_DEV
> generic/261      [not run] this test requires a valid $SCRATCH_DEV
> generic/262      [not run] this test requires a valid $SCRATCH_DEV
> generic/263      [failed, exit status 1] - output mismatch (see /home/ubuntu/os/xfstests/results//generic/263.out.bad)
>     --- tests/generic/263.out   2016-03-02 07:03:04.063808319 +0000
>     +++ /home/ubuntu/os/xfstests/results//generic/263.out.bad   2016-03-02 07:53:20.511808319 +0000
>     @@ -1,3 +1,8887 @@
>      QA output created by 263
>      fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
>      fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
>     +main: filesystem does not support fallocate mode FALLOC_FL_ZERO_RANGE, disabling!
>     +main: filesystem does not support fallocate mode FALLOC_FL_COLLAPSE_RANGE, disabling!
>     +main: filesystem does not support fallocate mode FALLOC_FL_INSERT_RANGE, disabling!
>     +truncating to largest ever: 0x11e00
>     ...
>     (Run 'diff -u tests/generic/263.out /home/ubuntu/os/xfstests/results//generic/263.out.bad'  to see the entire diff)
> generic/264      [not run] this test requires a valid $SCRATCH_DEV
> generic/265      [not run] this test requires a valid $SCRATCH_DEV
> generic/266      [not run] this test requires a valid $SCRATCH_DEV
> generic/267      [not run] this test requires a valid $SCRATCH_DEV
> generic/268      [not run] this test requires a valid $SCRATCH_DEV
> generic/269      [not run] this test requires a valid $SCRATCH_DEV
> generic/270      [not run] this test requires a valid $SCRATCH_DEV
> generic/271      [not run] this test requires a valid $SCRATCH_DEV
> generic/272      [not run] this test requires a valid $SCRATCH_DEV
> generic/273      [not run] this test requires a valid $SCRATCH_DEV
> generic/274      [not run] this test requires a valid $SCRATCH_DEV
> generic/275      [not run] this test requires a valid $SCRATCH_DEV
> generic/276      [not run] this test requires a valid $SCRATCH_DEV
> generic/277      [not run] this test requires a valid $SCRATCH_DEV
> generic/278      [not run] this test requires a valid $SCRATCH_DEV
> generic/279      [not run] this test requires a valid $SCRATCH_DEV
> generic/280      [not run] this test requires a valid $SCRATCH_DEV
> generic/281      [not run] this test requires a valid $SCRATCH_DEV
> generic/282      [not run] this test requires a valid $SCRATCH_DEV
> generic/283      [not run] this test requires a valid $SCRATCH_DEV
> generic/284      [not run] this test requires a valid $SCRATCH_DEV
> generic/285      0s
> generic/286      5s
> generic/287      [not run] this test requires a valid $SCRATCH_DEV
> generic/288      [not run] this test requires a valid $SCRATCH_DEV
> generic/289      [not run] this test requires a valid $SCRATCH_DEV
> generic/290      [not run] this test requires a valid $SCRATCH_DEV
> generic/291      [not run] this test requires a valid $SCRATCH_DEV
> generic/292      [not run] this test requires a valid $SCRATCH_DEV
> generic/293      [not run] this test requires a valid $SCRATCH_DEV
> generic/294      [not run] this test requires a valid $SCRATCH_DEV
> generic/295      [not run] this test requires a valid $SCRATCH_DEV
> generic/296      [not run] this test requires a valid $SCRATCH_DEV
> generic/297      [not run] this test requires a valid $SCRATCH_DEV
> generic/298      [not run] this test requires a valid $SCRATCH_DEV
> generic/299      [not run] this test requires a valid $SCRATCH_DEV
> generic/300      [not run] this test requires a valid $SCRATCH_DEV
> generic/301      [not run] this test requires a valid $SCRATCH_DEV
> generic/302      [not run] this test requires a valid $SCRATCH_DEV
> generic/303      [not run] xfs_io reflink support is missing
> generic/304      [not run] xfs_io dedupe support is missing
> generic/305      [not run] this test requires a valid $SCRATCH_DEV
> generic/306      [not run] this test requires a valid $SCRATCH_DEV
> generic/307      [not run] this test requires a valid $SCRATCH_DEV
> generic/308      0s
> generic/309      1s
> generic/310      65s
> generic/311      [not run] this test requires a valid $SCRATCH_DEV
> generic/312      [not run] this test requires a valid $SCRATCH_DEV
> generic/313      4s
> generic/314      [not run] chacl command not found
> generic/315      0s
> generic/316      1s
> generic/317      [not run] this test requires a valid $SCRATCH_DEV
> generic/318      [not run] this test requires a valid $SCRATCH_DEV
> generic/319      [not run] chacl command not found
> generic/320      [not run] this test requires a valid $SCRATCH_DEV
> generic/321      [not run] this test requires a valid $SCRATCH_DEV
> generic/322      [not run] this test requires a valid $SCRATCH_DEV
> generic/323      121s
> generic/324      [not run] this test requires a valid $SCRATCH_DEV
> generic/325      [not run] this test requires a valid $SCRATCH_DEV
> generic/326      [not run] this test requires a valid $SCRATCH_DEV
> generic/327      [not run] this test requires a valid $SCRATCH_DEV
> generic/328      [not run] this test requires a valid $SCRATCH_DEV
> generic/329      [not run] this test requires a valid $SCRATCH_DEV
> generic/330      [not run] this test requires a valid $SCRATCH_DEV
> generic/331      [not run] this test requires a valid $SCRATCH_DEV
> generic/332      [not run] this test requires a valid $SCRATCH_DEV
> generic/333      [not run] this test requires a valid $SCRATCH_DEV
> generic/334      [not run] this test requires a valid $SCRATCH_DEV
> generic/335      [not run] this test requires a valid $SCRATCH_DEV
> generic/336      [not run] this test requires a valid $SCRATCH_DEV
> generic/337      [not run] this test requires a valid $SCRATCH_DEV
> shared/001       [not run] not suitable for this filesystem type: xfs
> shared/002       [not run] this test requires a valid $SCRATCH_DEV
> shared/003       [not run] not suitable for this filesystem type: xfs
> shared/006       [not run] this test requires a valid $SCRATCH_DEV
> shared/032       [not run] this test requires a valid $SCRATCH_DEV
> shared/051       [not run] chacl command not found
> shared/272       [not run] not suitable for this filesystem type: xfs
> shared/289       [not run] not suitable for this filesystem type: xfs
> shared/298       45s
> xfs/001  [not run] this test requires a valid $SCRATCH_DEV
> xfs/002  [not run] this test requires a valid $SCRATCH_DEV
> xfs/003  0s
> xfs/004  [not run] this test requires a valid $SCRATCH_DEV
> xfs/005  [not run] this test requires a valid $SCRATCH_DEV
> xfs/006  [not run] this test requires a valid $SCRATCH_DEV
> xfs/007  [not run] this test requires a valid $SCRATCH_DEV
> xfs/008  2s
> xfs/009  [not run] this test requires a valid $SCRATCH_DEV
> xfs/010  [not run] this test requires a valid $SCRATCH_DEV
> xfs/011  [not run] this test requires a valid $SCRATCH_DEV
> xfs/012  2s
> xfs/013  [not run] this test requires a valid $SCRATCH_DEV
> xfs/014  [not run] this test requires a valid $SCRATCH_DEV
> xfs/015  [not run] this test requires a valid $SCRATCH_DEV
> xfs/016  [not run] this test requires a valid $SCRATCH_DEV
> xfs/017  [not run] this test requires a valid $SCRATCH_DEV
> xfs/018  [not run] this test requires a valid $SCRATCH_DEV
> xfs/019  [not run] this test requires a valid $SCRATCH_DEV
> xfs/020  [failed, exit status 139] - output mismatch (see /home/ubuntu/os/xfstests/results//xfs/020.out.bad)
>     --- tests/xfs/020.out       2016-03-02 07:03:04.083808319 +0000
>     +++ /home/ubuntu/os/xfstests/results//xfs/020.out.bad       2016-03-02 07:58:56.063808319 +0000
>     @@ -1,2 +1,3 @@
>      QA output created by 020
>      Silence is golden
>     +./tests/xfs/020: line 58: 28658 Segmentation fault      $XFS_REPAIR_PROG -f -o ag_stride=32 -t 1 $fsfile > /dev/null 2>&1
>     ...
>     (Run 'diff -u tests/xfs/020.out /home/ubuntu/os/xfstests/results//xfs/020.out.bad'  to see the entire diff)
> xfs/021  [not run] this test requires a valid $SCRATCH_DEV
> xfs/022  [not run] xfsdump not found
> xfs/023  [not run] xfsdump not found
> xfs/024  [not run] xfsdump not found
> xfs/025  [not run] xfsdump not found
> xfs/026  [not run] xfsdump not found
> xfs/027  [not run] xfsdump not found
> xfs/028  [not run] xfsdump not found
> xfs/029  [not run] this test requires a valid $SCRATCH_DEV
> xfs/030  [not run] this test requires a valid $SCRATCH_DEV
> xfs/031  [not run] this test requires a valid $SCRATCH_DEV
> xfs/032  [not run] this test requires a valid $SCRATCH_DEV
> xfs/033  [not run] this test requires a valid $SCRATCH_DEV
> xfs/034  [not run] this test requires a valid $SCRATCH_DEV
> xfs/035  [not run] xfsdump not found
> xfs/036  [not run] xfsdump not found
> xfs/037  [not run] xfsdump not found
> xfs/038  [not run] xfsdump not found
> xfs/039  [not run] xfsdump not found
> xfs/040  [not run] Can't run srcdiff without KWORKAREA set
> xfs/041  [not run] this test requires a valid $SCRATCH_DEV
> xfs/042  [not run] this test requires a valid $SCRATCH_DEV
> xfs/043  [not run] xfsdump not found
> xfs/044  [not run] This test requires a valid $SCRATCH_LOGDEV
> xfs/045  [not run] this test requires a valid $SCRATCH_DEV
> xfs/046  [not run] xfsdump not found
> xfs/047  [not run] xfsdump not found
> xfs/048  0s
> xfs/049  [not run] this test requires a valid $SCRATCH_DEV
> xfs/050  [not run] this test requires a valid $SCRATCH_DEV
> xfs/051  [not run] this test requires a valid $SCRATCH_DEV
> xfs/052  [not run] this test requires a valid $SCRATCH_DEV
> xfs/053  [not run] this test requires a valid $SCRATCH_DEV
> xfs/054  [not run] this test requires a valid $SCRATCH_DEV
> xfs/055  [not run] xfsdump not found
> xfs/056  [not run] xfsdump not found
> xfs/057  [not run] Place holder for IRIX test 057
> xfs/058  [not run] Place holder for IRIX test 058
> xfs/059  [not run] xfsdump not found
> xfs/060  [not run] xfsdump not found
> xfs/061  [not run] xfsdump not found
> xfs/062  [not run] this test requires a valid $SCRATCH_DEV
> xfs/063  [not run] xfsdump not found
> xfs/064  [not run] xfsdump not found
> xfs/065  [not run] xfsdump not found
> xfs/066  [not run] xfsdump not found
> xfs/067  [not run] chacl command not found
> xfs/068  [not run] xfsdump not found
> xfs/069  [not run] this test requires a valid $SCRATCH_DEV
> xfs/070  [not run] this test requires a valid $SCRATCH_DEV
> xfs/071  [not run] this test requires a valid $SCRATCH_DEV
> xfs/072  [not run] this test requires a valid $SCRATCH_DEV
> xfs/073  [not run] this test requires a valid $SCRATCH_DEV
> xfs/074  [failed, exit status 1] - output mismatch (see /home/ubuntu/os/xfstests/results//xfs/074.out.bad)
>     --- tests/xfs/074.out       2016-03-02 07:03:04.095808319 +0000
>     +++ /home/ubuntu/os/xfstests/results//xfs/074.out.bad       2016-03-02 07:59:19.943808319 +0000
>     @@ -1,2 +1,4 @@
>      QA output created by 074
>     -Silence is golden
>     +fallocate: No space left on device
>     +_check_xfs_filesystem: filesystem on /dev/loop0 is inconsistent (c) (see /home/ubuntu/os/xfstests/results//xfs/074.full)
>     +_check_xfs_filesystem: filesystem on /dev/loop0 is inconsistent (r) (see /home/ubuntu/os/xfstests/results//xfs/074.full)
>     ...
>     (Run 'diff -u tests/xfs/074.out /home/ubuntu/os/xfstests/results//xfs/074.out.bad'  to see the entire diff)
> xfs/075  [not run] this test requires a valid $SCRATCH_DEV
> xfs/076  [not run] this test requires a valid $SCRATCH_DEV
> xfs/077  [not run] this test requires a valid $SCRATCH_DEV
> xfs/078  48s
> xfs/079  [not run] this test requires a valid $SCRATCH_DEV
> xfs/080  5s
> xfs/081  [not run] this test requires a valid $SCRATCH_DEV
> xfs/082  [not run] this test requires a valid $SCRATCH_DEV
> xfs/083  [not run] this test requires a valid $SCRATCH_DEV
> xfs/084  60s
> xfs/085  [not run] this test requires a valid $SCRATCH_DEV
> xfs/086  [not run] this test requires a valid $SCRATCH_DEV
> xfs/087  [not run] this test requires a valid $SCRATCH_DEV
> xfs/088  [not run] this test requires a valid $SCRATCH_DEV
> xfs/089  [not run] this test requires a valid $SCRATCH_DEV
> xfs/090  [not run] External volumes not in use, skipped this test
> xfs/091  [not run] this test requires a valid $SCRATCH_DEV
> xfs/092  [not run] this test requires a valid $SCRATCH_DEV
> xfs/093  [not run] this test requires a valid $SCRATCH_DEV
> xfs/094  [not run] External volumes not in use, skipped this test
> xfs/095  [not run] not suitable for this OS: Linux
> xfs/096  [not run] this test requires a valid $SCRATCH_DEV
> xfs/097  [not run] this test requires a valid $SCRATCH_DEV
> xfs/098  [not run] this test requires a valid $SCRATCH_DEV
> xfs/099  [not run] this test requires a valid $SCRATCH_DEV
> xfs/100  [not run] this test requires a valid $SCRATCH_DEV
> xfs/101  [not run] this test requires a valid $SCRATCH_DEV
> xfs/102  [not run] this test requires a valid $SCRATCH_DEV
> xfs/103  [not run] this test requires a valid $SCRATCH_DEV
> xfs/104  [not run] this test requires a valid $SCRATCH_DEV
> xfs/105  [not run] this test requires a valid $SCRATCH_DEV
> xfs/106  [not run] this test requires a valid $SCRATCH_DEV
> xfs/107  [not run] this test requires a valid $SCRATCH_DEV
> xfs/108  [not run] this test requires a valid $SCRATCH_DEV
> xfs/109  [not run] this test requires a valid $SCRATCH_DEV
> xfs/110  [not run] this test requires a valid $SCRATCH_DEV
> xfs/111  [not run] this test requires a valid $SCRATCH_DEV
> xfs/112  [not run] this test requires a valid $SCRATCH_DEV
> xfs/113  [not run] this test requires a valid $SCRATCH_DEV
> xfs/114  [not run] not suitable for this OS: Linux
> xfs/115  [not run] not suitable for this OS: Linux
> xfs/116  [not run] this test requires a valid $SCRATCH_DEV
> xfs/117  [not run] this test requires a valid $SCRATCH_DEV
> xfs/118  [not run] this test requires a valid $SCRATCH_DEV
> xfs/119  [not run] this test requires a valid $SCRATCH_DEV
> xfs/120  [not run] this test requires a valid $SCRATCH_DEV
> xfs/121  [not run] this test requires a valid $SCRATCH_DEV
> xfs/122  [not run] indent utility required, skipped this test
> xfs/123  [not run] this test requires a valid $SCRATCH_DEV
> xfs/124  [not run] this test requires a valid $SCRATCH_DEV
> xfs/125  [not run] this test requires a valid $SCRATCH_DEV
> xfs/126  [not run] this test requires a valid $SCRATCH_DEV
> xfs/127  [not run] this test requires a valid $SCRATCH_DEV
> xfs/128  [not run] this test requires a valid $SCRATCH_DEV
> xfs/129  [not run] this test requires a valid $SCRATCH_DEV
> xfs/130  [not run] this test requires a valid $SCRATCH_DEV
> xfs/131  [not run] External volumes not in use, skipped this test
> xfs/132  [not run] xfs_io reflink support is missing
> xfs/133  [not run] this test requires a valid $SCRATCH_DEV
> xfs/134  [not run] this test requires a valid $SCRATCH_DEV
> xfs/135  [not run] this test requires a valid $SCRATCH_DEV
> xfs/136  [not run] this test requires a valid $SCRATCH_DEV
> xfs/137  [not run] this test requires a valid $SCRATCH_DEV
> xfs/138  [not run] this test requires a valid $SCRATCH_DEV
> xfs/139  [not run] this test requires a valid $SCRATCH_DEV
> xfs/140  [not run] this test requires a valid $SCRATCH_DEV
> xfs/141  [not run] no kernel support for XFS sysfs attributes
> xfs/142  [not run] this test requires a valid $SCRATCH_DEV
> xfs/143  [not run] this test requires a valid $SCRATCH_DEV
> xfs/144  [not run] this test requires a valid $SCRATCH_DEV
> xfs/145  [not run] this test requires a valid $SCRATCH_DEV
> xfs/146  [not run] this test requires a valid $SCRATCH_DEV
> xfs/147  [not run] this test requires a valid $SCRATCH_DEV
> xfs/148  [not run] parallel repair binary xfs_prepair64 is not installed
> xfs/149  [not run] parallel repair binary xfs_prepair is not installed
> xfs/150  [not run] this test requires a valid $SCRATCH_DEV
> xfs/151  [not run] this test requires a valid $SCRATCH_DEV
> xfs/152  [not run] this test requires a valid $SCRATCH_DEV
> xfs/153  [not run] this test requires a valid $SCRATCH_DEV
> xfs/154  [not run] this test requires a valid $SCRATCH_DEV
> xfs/155  [not run] this test requires a valid $SCRATCH_DEV
> xfs/156  [not run] this test requires a valid $SCRATCH_DEV
> xfs/157  [not run] this test requires a valid $SCRATCH_DEV
> xfs/158  [not run] this test requires a valid $SCRATCH_DEV
> xfs/159  [not run] this test requires a valid $SCRATCH_DEV
> xfs/160  [not run] this test requires a valid $SCRATCH_DEV
> xfs/161  [not run] this test requires a valid $SCRATCH_DEV
> xfs/162  [not run] this test requires a valid $SCRATCH_DEV
> xfs/163  [not run] this test requires a valid $SCRATCH_DEV
> xfs/164  0s
> xfs/165  0s
> xfs/166  [not run] this test requires a valid $SCRATCH_DEV
> xfs/167  [not run] this test requires a valid $SCRATCH_DEV
> xfs/168  [not run] this test requires a valid $SCRATCH_DEV
> xfs/169  [not run] this test requires a valid $SCRATCH_DEV
> xfs/170  [not run] this test requires a valid $SCRATCH_DEV
> xfs/171  [not run] this test requires a valid $SCRATCH_DEV
> xfs/172  [not run] this test requires a valid $SCRATCH_DEV
> xfs/173  [not run] this test requires a valid $SCRATCH_DEV
> xfs/174  [not run] this test requires a valid $SCRATCH_DEV
> xfs/175  [not run] this test requires a valid $SCRATCH_DEV
> xfs/176  [not run] this test requires a valid $SCRATCH_DEV
> xfs/177  [not run] this test requires a valid $SCRATCH_DEV
> xfs/178  [not run] this test requires a valid $SCRATCH_DEV
> xfs/179  [not run] this test requires a valid $SCRATCH_DEV
> xfs/180  [not run] this test requires a valid $SCRATCH_DEV
> xfs/181  [not run] this test requires a valid $SCRATCH_DEV
> xfs/182  [not run] this test requires a valid $SCRATCH_DEV
> xfs/183  [not run] this test requires a valid $SCRATCH_DEV
> xfs/184  [not run] this test requires a valid $SCRATCH_DEV
> xfs/185  [not run] this test requires a valid $SCRATCH_DEV
> xfs/186  [not run] this test requires a valid $SCRATCH_DEV
> xfs/187  [not run] this test requires a valid $SCRATCH_DEV
> xfs/188  [not run] this test requires a valid $SCRATCH_DEV
> xfs/189  [not run] this test requires a valid $SCRATCH_DEV
> xfs/190  [not run] this test requires a valid $SCRATCH_DEV
> xfs/191  [not run] this test requires a valid $SCRATCH_DEV
> xfs/192  [not run] this test requires a valid $SCRATCH_DEV
> xfs/193  [not run] this test requires a valid $SCRATCH_DEV
> xfs/194  [not run] sector size(4096) too large for platform page size(4096)
> xfs/195  [not run] xfsdump utility required, skipped this test
> xfs/196  [not run] this test requires a valid $SCRATCH_DEV
> xfs/197  [not run] This test is only valid on 32 bit machines
> xfs/198  [not run] this test requires a valid $SCRATCH_DEV
> xfs/199  [not run] this test requires a valid $SCRATCH_DEV
> xfs/200  [not run] this test requires a valid $SCRATCH_DEV
> xfs/201  [not run] this test requires a valid $SCRATCH_DEV
> xfs/202  [not run] this test requires a valid $SCRATCH_DEV
> xfs/203  [not run] this test requires a valid $SCRATCH_DEV
> xfs/204  [not run] this test requires a valid $SCRATCH_DEV
> xfs/205  [not run] this test requires a valid $SCRATCH_DEV
> xfs/206  4s
> xfs/207  [not run] this test requires a valid $SCRATCH_DEV
> xfs/208  [not run] this test requires a valid $SCRATCH_DEV
> xfs/209  [not run] this test requires a valid $SCRATCH_DEV
> xfs/210  [not run] this test requires a valid $SCRATCH_DEV
> xfs/211  [not run] this test requires a valid $SCRATCH_DEV
> xfs/212  [not run] this test requires a valid $SCRATCH_DEV
> xfs/213  [not run] this test requires a valid $SCRATCH_DEV
> xfs/214  [not run] this test requires a valid $SCRATCH_DEV
> xfs/215  [not run] this test requires a valid $SCRATCH_DEV
> xfs/216  [not run] this test requires a valid $SCRATCH_DEV
> xfs/217  [not run] this test requires a valid $SCRATCH_DEV
> xfs/218  [not run] this test requires a valid $SCRATCH_DEV
> xfs/219  [not run] this test requires a valid $SCRATCH_DEV
> xfs/220  [not run] this test requires a valid $SCRATCH_DEV
> xfs/221  [not run] this test requires a valid $SCRATCH_DEV
> xfs/222  0s
> xfs/223  [not run] this test requires a valid $SCRATCH_DEV
> xfs/224  [not run] this test requires a valid $SCRATCH_DEV
> xfs/225  [not run] this test requires a valid $SCRATCH_DEV
> xfs/226  [not run] this test requires a valid $SCRATCH_DEV
> xfs/227  [not run] this test requires a valid $SCRATCH_DEV
> xfs/228  [not run] this test requires a valid $SCRATCH_DEV
> xfs/229  75s
> xfs/230  [not run] this test requires a valid $SCRATCH_DEV
> xfs/231  [not run] this test requires a valid $SCRATCH_DEV
> xfs/232  [not run] this test requires a valid $SCRATCH_DEV
> xfs/233  [not run] this test requires a valid $SCRATCH_DEV
> xfs/234  [not run] this test requires a valid $SCRATCH_DEV
> xfs/235  [not run] this test requires a valid $SCRATCH_DEV
> xfs/236  [not run] this test requires a valid $SCRATCH_DEV
> xfs/237  [not run] this test requires a valid $SCRATCH_DEV
> xfs/238  [not run] this test requires a valid $SCRATCH_DEV
> xfs/239  [not run] this test requires a valid $SCRATCH_DEV
> xfs/240  [not run] this test requires a valid $SCRATCH_DEV
> xfs/241  [not run] this test requires a valid $SCRATCH_DEV
> xfs/242  1s
> xfs/243  [not run] this test requires a valid $SCRATCH_DEV
> xfs/244  [not run] this test requires a valid $SCRATCH_DEV
> xfs/245  [not run] this test requires a valid $SCRATCH_DEV
> xfs/246  [not run] xfs_io bmap doesn't support -c
> xfs/247  [not run] this test requires a valid $SCRATCH_DEV
> xfs/248  [not run] this test requires a valid $SCRATCH_DEV
> xfs/249  [not run] this test requires a valid $SCRATCH_DEV
> xfs/250  [failed, exit status 1] - output mismatch (see /home/ubuntu/os/xfstests/results//xfs/250.out.bad)
>     --- tests/xfs/250.out       2016-03-02 07:03:04.119808319 +0000
>     +++ /home/ubuntu/os/xfstests/results//xfs/250.out.bad       2016-03-02 08:03:49.847808319 +0000
>     @@ -11,4 +11,4 @@
>      *** preallocate large file
>      *** unmount loop filesystem
>      *** check loop filesystem
>     -*** done
>     +_check_xfs_filesystem: filesystem on /mnt/xfs_mnt/250.fs is inconsistent (r) (see /home/ubuntu/os/xfstests/results//xfs/250.full)
>     ...
>     (Run 'diff -u tests/xfs/250.out /home/ubuntu/os/xfstests/results//xfs/250.out.bad'  to see the entire diff)
> xfs/251  [not run] this test requires a valid $SCRATCH_DEV
> xfs/252  2s
> xfs/253  [not run] this test requires a valid $SCRATCH_DEV
> xfs/254  [not run] this test requires a valid $SCRATCH_DEV
> xfs/255  [not run] this test requires a valid $SCRATCH_DEV
> xfs/256  [not run] this test requires a valid $SCRATCH_DEV
> xfs/257  [not run] this test requires a valid $SCRATCH_DEV
> xfs/258  [not run] this test requires a valid $SCRATCH_DEV
> xfs/259  2s
> xfs/260  [not run] this test requires a valid $SCRATCH_DEV
> xfs/261  [not run] this test requires a valid $SCRATCH_DEV
> xfs/262  [not run] this test requires a valid $SCRATCH_DEV
> xfs/266  [not run] xfsdump not found
> xfs/267  [not run] xfsdump not found
> xfs/268  [not run] xfsdump not found
> xfs/278  [not run] this test requires a valid $SCRATCH_DEV
> xfs/279  7s
> xfs/281  [not run] xfsdump not found
> xfs/282  [not run] xfsdump not found
> xfs/283  [not run] xfsdump not found
> xfs/287  [not run] xfsdump not found
> xfs/290  1s
> xfs/291  [not run] this test requires a valid $SCRATCH_DEV
> xfs/292  - output mismatch (see /home/ubuntu/os/xfstests/results//xfs/292.out.bad)
>     --- tests/xfs/292.out       2016-03-02 07:03:04.123808319 +0000
>     +++ /home/ubuntu/os/xfstests/results//xfs/292.out.bad       2016-03-02 08:04:19.487808319 +0000
>     @@ -5,5 +5,5 @@
>      agsize=16777216
>      mkfs.xfs with cmdline geometry
>      ddev=FILENAME
>     -agcount=16
>     -agsize=4194304
>     +agcount=4
>     +agsize=16777216
>     ...
>     (Run 'diff -u tests/xfs/292.out /home/ubuntu/os/xfstests/results//xfs/292.out.bad'  to see the entire diff)
> xfs/293  - output mismatch (see /home/ubuntu/os/xfstests/results//xfs/293.out.bad)
>     --- tests/xfs/293.out       2016-03-02 07:03:04.123808319 +0000
>     +++ /home/ubuntu/os/xfstests/results//xfs/293.out.bad       2016-03-02 08:04:22.499808319 +0000
>     @@ -1,2 +1,8 @@
>      QA output created by 293
>      Silence is golden
>     +chproj not documented in the xfs_io manpage
>     +fiemap not documented in the xfs_io manpage
>     +fpunch not documented in the xfs_io manpage
>     +lsproj not documented in the xfs_io manpage
>     +setfl not documented in the xfs_io manpage
>     ...
>     (Run 'diff -u tests/xfs/293.out /home/ubuntu/os/xfstests/results//xfs/293.out.bad'  to see the entire diff)
> xfs/295  [not run] this test requires a valid $SCRATCH_DEV
> xfs/296  [not run] xfsdump not found
> xfs/297  [not run] this test requires a valid $SCRATCH_DEV
> xfs/298  [not run] this test requires a valid $SCRATCH_DEV
> xfs/299  [not run] this test requires a valid $SCRATCH_DEV
> xfs/300  [not run] this test requires a valid $SCRATCH_DEV
> xfs/301  [not run] xfsdump not found
> xfs/302  [not run] xfsdump not found
> xfs/303  1s
> xfs/304  [not run] this test requires a valid $SCRATCH_DEV
> xfs/305  [not run] this test requires a valid $SCRATCH_DEV
> Ran: generic/001 generic/002 generic/005 generic/006 generic/007 generic/010 generic/011 generic/013 generic/014 generic/020 generic/028 generic/035 generic/036 generic/070 generic/074 generic/075 generic/080 generic/086 generic/087 generic/088 generic/089 generic/091 generic/092 generic/112 generic/113 generic/114 generic/123 generic/125 generic/126 generic/127 generic/131 generic/133 generic/184 generic/192 generic/193 generic/198 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 generic/221 generic/228 generic/236 generic/239 generic/240 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/255 generic/257 generic/258 generic/263 generic/285 generic/286 generic/308 generic/309 generic/310 generic/313 generic/315 generic/316 generic/323 shared/298 xfs/003 xfs/008 xfs/012 xfs/020 xfs/048 xfs/074 xfs/078 xfs/080 xfs/084 xfs/164 xfs/165 xfs/206 xfs/222 xfs/229 xfs/242 xfs/250 xfs/252 xfs/259 xfs/279 
 xfs/290 xfs/292 xfs/293 xfs/303
> Not run: generic/003 generic/004 generic/008 generic/009 generic/012 generic/015 generic/016 generic/017 generic/018 generic/019 generic/021 generic/022 generic/023 generic/024 generic/025 generic/026 generic/027 generic/029 generic/030 generic/031 generic/032 generic/033 generic/034 generic/037 generic/038 generic/039 generic/040 generic/041 generic/042 generic/043 generic/044 generic/045 generic/046 generic/047 generic/048 generic/049 generic/050 generic/051 generic/052 generic/053 generic/054 generic/055 generic/056 generic/057 generic/058 generic/059 generic/060 generic/061 generic/062 generic/063 generic/064 generic/065 generic/066 generic/067 generic/068 generic/069 generic/071 generic/072 generic/073 generic/076 generic/077 generic/078 generic/079 generic/081 generic/082 generic/083 generic/084 generic/085 generic/090 generic/093 generic/094 generic/095 generic/096 generic/097 generic/098 generic/099 generic/100 generic/101 generic/102 generic/103 generic/104 generic/105 gen
 eric/106 generic/107 generic/108 generic/109 generic/110 generic/111 generic/115 generic/116 generic/117 generic/118 generic/119 generic/120 generic/121 generic/122 generic/124 generic/128 generic/129 generic/130 generic/132 generic/134 generic/135 generic/136 generic/137 generic/138 generic/139 generic/140 generic/141 generic/142 generic/143 generic/144 generic/145 generic/146 generic/147 generic/148 generic/149 generic/150 generic/151 generic/152 generic/153 generic/154 generic/155 generic/156 generic/157 generic/158 generic/159 generic/160 generic/161 generic/162 generic/163 generic/164 generic/165 generic/166 generic/167 generic/168 generic/169 generic/170 generic/171 generic/172 generic/173 generic/174 generic/175 generic/176 generic/177 generic/178 generic/179 generic/180 generic/181 generic/182 generic/183 generic/185 generic/186 generic/187 generic/188 generic/189 generic/190 generic/191 generic/194 generic/195 generic/196 generic/197 generic/199 generic/200 generic/201 gene
 ric/202 generic/203 generic/204 generic/205 generic/206 generic/216 generic/217 generic/218 generic/219 generic/220 generic/222 generic/223 generic/224 generic/225 generic/226 generic/227 generic/229 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/237 generic/238 generic/242 generic/243 generic/244 generic/250 generic/251 generic/252 generic/253 generic/254 generic/256 generic/259 generic/260 generic/261 generic/262 generic/264 generic/265 generic/266 generic/267 generic/268 generic/269 generic/270 generic/271 generic/272 generic/273 generic/274 generic/275 generic/276 generic/277 generic/278 generic/279 generic/280 generic/281 generic/282 generic/283 generic/284 generic/287 generic/288 generic/289 generic/290 generic/291 generic/292 generic/293 generic/294 generic/295 generic/296 generic/297 generic/298 generic/299 generic/300 generic/301 generic/302 generic/303 generic/304 generic/305 generic/306 generic/307 generic/311 generic/312 generic/314 gener
 ic/317 generic/318 generic/319 generic/320 generic/321 generic/322 generic/324 generic/325 generic/326 generic/327 generic/328 generic/329 generic/330 generic/331 generic/332 generic/333 generic/334 generic/335 generic/336 generic/337 shared/001 shared/002 shared/003 shared/006 shared/032 shared/051 shared/272 shared/289 xfs/001 xfs/002 xfs/004 xfs/005 xfs/006 xfs/007 xfs/009 xfs/010 xfs/011 xfs/013 xfs/014 xfs/015 xfs/016 xfs/017 xfs/018 xfs/019 xfs/021 xfs/022 xfs/023 xfs/024 xfs/025 xfs/026 xfs/027 xfs/028 xfs/029 xfs/030 xfs/031 xfs/032 xfs/033 xfs/034 xfs/035 xfs/036 xfs/037 xfs/038 xfs/039 xfs/040 xfs/041 xfs/042 xfs/043 xfs/044 xfs/045 xfs/046 xfs/047 xfs/049 xfs/050 xfs/051 xfs/052 xfs/053 xfs/054 xfs/055 xfs/056 xfs/057 xfs/058 xfs/059 xfs/060 xfs/061 xfs/062 xfs/063 xfs/064 xfs/065 xfs/066 xfs/067 xfs/068 xfs/069 xfs/070 xfs/071 xfs/072 xfs/073 xfs/075 xfs/076 xfs/077 xfs/079 xfs/081 xfs/082 xfs/083 xfs/085 xfs/086 xfs/087 xfs/088 xfs/089 xfs/090 xfs/091 xfs/092 xfs/093 xf
 s/094 xfs/095 xfs/096 xfs/097 xfs/098 xfs/099 xfs/100 xfs/101 xfs/102 xfs/103 xfs/104 xfs/105 xfs/106 xfs/107 xfs/108 xfs/109 xfs/110 xfs/111 xfs/112 xfs/113 xfs/114 xfs/115 xfs/116 xfs/117 xfs/118 xfs/119 xfs/120 xfs/121 xfs/122 xfs/123 xfs/124 xfs/125 xfs/126 xfs/127 xfs/128 xfs/129 xfs/130 xfs/131 xfs/132 xfs/133 xfs/134 xfs/135 xfs/136 xfs/137 xfs/138 xfs/139 xfs/140 xfs/141 xfs/142 xfs/143 xfs/144 xfs/145 xfs/146 xfs/147 xfs/148 xfs/149 xfs/150 xfs/151 xfs/152 xfs/153 xfs/154 xfs/155 xfs/156 xfs/157 xfs/158 xfs/159 xfs/160 xfs/161 xfs/162 xfs/163 xfs/166 xfs/167 xfs/168 xfs/169 xfs/170 xfs/171 xfs/172 xfs/173 xfs/174 xfs/175 xfs/176 xfs/177 xfs/178 xfs/179 xfs/180 xfs/181 xfs/182 xfs/183 xfs/184 xfs/185 xfs/186 xfs/187 xfs/188 xfs/189 xfs/190 xfs/191 xfs/192 xfs/193 xfs/194 xfs/195 xfs/196 xfs/197 xfs/198 xfs/199 xfs/200 xfs/201 xfs/202 xfs/203 xfs/204 xfs/205 xfs/207 xfs/208 xfs/209 xfs/210 xfs/211 xfs/212 xfs/213 xfs/214 xfs/215 xfs/216 xfs/217 xfs/218 xfs/219 xfs/220 xfs/221
  xfs/223 xfs/224 xfs/225 xfs/226 xfs/227 xfs/228 xfs/230 xfs/231 xfs/232 xfs/233 xfs/234 xfs/235 xfs/236 xfs/237 xfs/238 xfs/239 xfs/240 xfs/241 xfs/243 xfs/244 xfs/245 xfs/246 xfs/247 xfs/248 xfs/249 xfs/251 xfs/253 xfs/254 xfs/255 xfs/256 xfs/257 xfs/258 xfs/260 xfs/261 xfs/262 xfs/266 xfs/267 xfs/268 xfs/278 xfs/281 xfs/282 xfs/283 xfs/287 xfs/291 xfs/295 xfs/296 xfs/297 xfs/298 xfs/299 xfs/300 xfs/301 xfs/302 xfs/304 xfs/305
> Failures: generic/247 generic/263 xfs/020 xfs/074 xfs/250 xfs/292 xfs/293
> Failed 7 of 93 tests
> 

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
