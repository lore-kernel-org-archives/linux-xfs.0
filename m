Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9B1Gqe237089 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 05:01:16 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 669961C9A025
	for <xfs@oss.sgi.com>; Thu,  9 Dec 2010 03:03:04 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ED3pvaWjGVHV2tXQ for
	<xfs@oss.sgi.com>; Thu, 09 Dec 2010 03:03:04 -0800 (PST)
Date: Thu, 9 Dec 2010 12:02:52 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Add test 248: Check filesystem FITRIM implementation
In-Reply-To: <4D0065E6.6010009@sandeen.net>
Message-ID: <alpine.LFD.2.00.1012091148140.2731@dhcp-lab-213.englab.brq.redhat.com>
References: <1290780743-12112-1-git-send-email-lczerner@redhat.com>
	<4D0065E6.6010009@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: hch@infradead.org, Lukas Czerner <lczerner@redhat.com>, esandeen@redhat.com, xfs@oss.sgi.com

On Wed, 8 Dec 2010, Eric Sandeen wrote:

> On 11/26/10 8:12 AM, Lukas Czerner wrote:
> > FITRIM ioctl  is used on a mounted filesystem to discard (or "trim")
> > blocks which are not in use by the filesystem.  This is useful for
> > solid-state drives (SSDs) and thinly-provi-sioned storage. This test
> > helps to verify filesystem FITRIM implementation to assure that it
> > does not corrupts data.
> > 
> > This test creates checksums of all files in /usr/share/doc directory and
> > run several processes which clear its working directory on SCRATCH_MNT,
> > then copy everything from /usr/share/doc into its working directory, create
> > list of files in working directory and its checksums and compare it with the
> > original list of checksums. Every process works in the loop so it repeat
> > remove->copy->check, while fstrim tool is running simultaneously.
> > 
> > Fstrim is just a helper tool which uses FITRIM ioctl to actually do the
> > filesystem discard.
> > 
> > I found this very useful because when the FITRIM is really buggy (thus
> > data-destroying) the 248 test will notice, because checksums will most
> > likely change.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>

-snip-

> > +
> > +fstrim_loop()
> > +{
> > +	trap "_destroy_fstrim; exit \$status" 2 15
> > +	fsize=$(df | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')
> > +
> > +	while true ; do
> > +		step=1048576
> > +		start=0
> > +		$here/src/fstrim $SCRATCH_MNT &
> > +		fpid=$!
> > +		wait $fpid
> > +		while [ $start -lt $fsize ] ; do
> > +			$here/src/fstrim -s ${start}k -l ${step}k $SCRATCH_MNT &
> > +			fpid=$!
> > +			wait $fpid
> > +			start=$(( $start + $step ))
> > +		done
> 
> I may be dense here but 
> 
> a) why do you background and then immediately wait?
> b) does this start a whole-device trim followed by several
> smaller range-trims?
> 
> I could do with some comments, I suppose.

Hi Eric,

all the waiting is done because Bash is incredibly stupid. As you know,
fstrim_loop is run at background and when the test is over, or when it
is killed (with ^C), because of trap, it tries to kill fstrim_loop.
However, it does not kill currently running commands, so fstrim might be
still running making it impossible to umount the SCRATCH_MNT.

So this way, I can kill the running process directly. I believe I am not
the first one running into this troubles, so maybe there is a better way
?

> 
> > +	done
> > +}
> > +
> > +function check_sums() {
> > +	dir=$1
> > +
> > +	(
> > +	cd $SCRATCH_MNT/$p
> > +	find -P . -xdev -type f -print0 | xargs -0 md5sum | sort -o $tmp/stress.$$.$p
> > +	)
> > +
> > +	diff $tmp/content.sums $tmp/stress.$$.$p
> > +	if [ $? -ne 0 ]; then
> > +		echo "!!!Checksums has changed - Filesystem possibly corrupted!!!\n"
> > +		kill $mypid
> 
> what is $mypid?  Oh right $$ ...  why not:
> 
> _fail "!!!Checksums has changed - Filesystem possibly corrupted!!!"

oh, that's better, thanks.

> 
> > +	fi
> > +	rm -f $tmp/stress.$$.$p
> > +}
> > +
> > +function run_process() {
> > +	local p=$1
> > +	repeat=10
> > +
> > +	sleep $((5*$p))s &
> > +	export chpid=$! && wait $chpid &> /dev/null
> 
> I guess I don't sight-read bash very well.  What's going
> on with all the backgrounding/waiting here?
> 
> > +	chpid=0
> > +
> > +	while [ $repeat -gt 0 ]; do
> > +
> > +		# Remove old directories.
> > +		rm -rf $SCRATCH_MNT/$p
> > +		export chpid=$! && wait $chpid &> /dev/null
> 
> and here?

The same thing here, the process will still be running when xfstests
will attempt to umount SCRATCH_MNT, resulting in error. This way I can
kill it directly.

> 
> > +		# Copy content -> partition.
> > +		mkdir $SCRATCH_MNT/$p
> > +		cp -ax $content/* $SCRATCH_MNT/$p
> > +		export chpid=$! && wait $chpid &> /dev/null
> > +
> > +		check_sums
> > +		repeat=$(( $repeat - 1 ))
> > +	done
> > +}
> > +
> > +nproc=20
> > +content=/usr/share/doc
> > +
> > +# Check for FITRIM support
> > +echo -n "Checking FITRIM support: "
> > +$here/src/fstrim -l 10M $SCRATCH_MNT
> > +[ $? -ne 0 ] && exit
> > +echo "done."
> > +
> > +mkdir -p $tmp
> > +
> > +(
> > +cd $content
> > +find -P . -xdev -type f -print0 | xargs -0 md5sum | sort -o $tmp/content.sums
> > +)
> > +
> > +echo -n "Running the test: "
> > +pids=""
> > +fstrim_loop &
> > +fstrim_pid=$!
> > +p=1
> > +while [ $p -le $nproc ]; do
> > +	run_process $p &
> > +	pids="$pids $!"
> > +	p=$(($p+1))
> > +done
> > +echo "done."
> > +
> > +wait $pids
> > +kill $fstrim_pid
> > +wait $fstrim_pid
> > +
> > +status=0
> > +_check_scratch_fs
> 
> Scratch fs should get checked automatically after the test I think?
> I guess other tests do this, but I'm not sure it's necessary
> unless filesystems are made, remounted, etc in a loop during
> the test

Ok, I'll get rid of it.

> 
> > +exit
> > diff --git a/248.out b/248.out
> > new file mode 100644
> > index 0000000..880d9c7
> > --- /dev/null
> > +++ b/248.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 248
> > +Checking FITRIM support: done.
> > +Running the test: done.
> > diff --git a/group b/group
> > index 0f94dd9..fea84ed 100644
> > --- a/group
> > +++ b/group
> > @@ -361,3 +361,4 @@ deprecated
> >  245 auto quick dir
> >  246 auto quick rw
> >  247 auto quick rw
> > +248 ioctl
> 
> I suppose maybe a trim group would be worthwhile at some point ...

Added.

> 
> > diff --git a/src/Makefile b/src/Makefile
> > index b827bd0..885fd65 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -17,7 +17,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> >  	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
> >  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
> > -	stale_handle
> > +	stale_handle fstrim
> >  
> >  SUBDIRS =
> >  
> > diff --git a/src/fstrim.c b/src/fstrim.c
> > new file mode 100644
> > index 0000000..6686c99
> > --- /dev/null
> > +++ b/src/fstrim.c
> > @@ -0,0 +1,257 @@
> > +/*
> > + * fstrim.c -- discard the part (or whole) of mounted filesystem.
> > + *
> > + * Copyright (C) 2009 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
> 
> 2010 I think :)

Hmm, still living in the past :).

Thanks for review Eric!

-Lukas

-snip-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
