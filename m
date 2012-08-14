Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7ELdeL3011581 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 16:39:40 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MJfuCECMyoFIDFB7 for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 14:39:38 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1T1Opl-0006yF-HB
	for xfs@oss.sgi.com; Wed, 15 Aug 2012 07:39:29 +1000
Date: Wed, 15 Aug 2012 07:39:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20120814213929.GN2877@dastard>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Ping?

On Thu, Jul 26, 2012 at 07:27:54PM +1000, Dave Chinner wrote:
> Alt-Subject: Games with Sed, Grep and Awk.
> 
> This series is based on top of the large filesystem test series.
> 
> This moves all the tests into a ./tests subdirectory, and sorts them into
> classes of related tests. Those are:
> 
> 	tests/generic:	valid for all filesystems
> 	tests/shared:	valid for a limited number of filesystems
> 	tests/xfs:	xfs specific tests
> 	tests/btrfs	btrfs specific tests
> 	tests/ext4	ext4 specific tests
> 	tests/udf	udf specific tests
> 
> Each directory has it's own group file to determine what groups the
> tests are associated with. Tests are run in exactly the same was as
> before, but when trying to run individual tests you need to specify
> the class as well. e.g. the old way:
> 
> # ./check 001
> 
> The new way:
> 
> # ./check generic/001
> 
> The output also indicates what class the test came from:
> 
> $ sudo ./check -g auto
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test-1 3.5.0-rc5-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> 
> generic/001      3s
> generic/002      0s
> generic/005      1s
> generic/006      10s
> generic/007      2s
> generic/010      [not run] dbtest was not built for this platform
> generic/011      15s
> generic/013      43s
> generic/014      2s
> generic/015      0s
> generic/020      3s
> generic/053      0s
> ....
> 
> [I'd post more example output, but a lightning strike took out power
> a little while ago and so all the output in my scrollback buffers
> went bye-bye...]
> 
> The test classes that are run are generic, shared and $FSTYP, hence
> avoiding most "notrun, wrong filesystem" cases.
> 
> Further, the test result/status files (e.g. 001.full) are also moved
> out of the top level directory into a new results directory. This
> defaults to ./results ($RESULT_BASE) and duplicates the heirarchy of
> the tests/ directory. It is created on demand. Each test is passed
> $RESULT_DIR which points to the directory it should dump it's output
> files in. i.e. "echo foo > $RESULT_DIR/$seq.full".
> 
> There's a bunch of cleanup at the start of the series, removing
> stuff that I don't think has been used for years. e.g. i didn't even
> know the remake script existed, but it's usefulness is minimal are
> we rarely, if ever, regenerate every single .out file in the test
> suite. Hence stuff is removed to make it easy to convert the
> important stuff to use the new structure....
> 
> Feel free to debate things like the renaming of variables - I just
> used sed scripts to do most of the conversion and most of them are
> in the commit messages so I can easily re-run them to do global
> search/replace if you've got better ideas for naming stuff ($seqres
> is pretty 'orrible)....
> 
> Overall, this series shows the direction I want to take xfstests in.
> The next steps are:
> 
> 	- remove remaining limitations on test naming (i.e.  must be
> 	  numbered) so that we can have descriptive names
> 	- move all of the output into the results directory and
> 	  enable it to be hosted externally so it can be archived
> 	  and data mined easily
> 	- move all the common* files to a subdirectory
> 	- allow running of test classes, not just groups
> 	- re-introduce the expunged file functionailty (which I
> 	  didn't know existed) because I can see how useful that is
> 	  for running regular QA with a current xfstests on an older
> 	  distro (e.g. RHEL5) to avoid running tests that are known
> 	  to fail or test features that aren't in old kernels...
> 
> I sent the patches in git format for all the renames - you don't
> need to see a patchset that is this size:
> 
> 1280 files changed, 102397 insertions(+), 104307 deletions(-)
> 
> When turning on rename detection makes it this size:
> 
> 686 files changed, 1722 insertions(+), 3632 deletions(-)
> 
> Which is much more manageable to review....
> 
> I'm certain there are problems still in there - I haven't done a lot
> of weird command line testing and really only just enough testing to
> make sure a typical auto group test run mostly passes.....
> 
> Comments, additional ideas, new functionality, modifications, etc 
> are all welcome.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
> 
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
