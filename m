Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o44KgWpX253509 for <xfs@oss.sgi.com>; Tue, 4 May 2010 15:42:33 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EAB11B4FFB9
	for <xfs@oss.sgi.com>; Tue,  4 May 2010 13:44:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eiwwuV6P12gHtAuj for
	<xfs@oss.sgi.com>; Tue, 04 May 2010 13:44:40 -0700 (PDT)
Message-ID: <4BE08718.5040608@redhat.com>
Date: Tue, 04 May 2010 15:44:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] New testcase to check if fallocate respects RLIMIT_FSIZE
	or not
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de>
	<201004291014.07194.knikanth@suse.de>
	<20100430143319.d51d6d77.akpm@linux-foundation.org>
	<20100501070426.GA9562@amitarora.in.ibm.com>
	<20100501101846.GA3769@infradead.org>
	<20100503083135.GC13756@amitarora.in.ibm.com>
In-Reply-To: <20100503083135.GC13756@amitarora.in.ibm.com>
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
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, Andreas Dilger <adilger@sun.com>, Eelis <opensuse.org@contacts.eelis.net>, Theodore Ts'o <tytso@mit.edu>, Nikanth Karthikesan <knikanth@suse.de>, coly.li@suse.de, Amit Arora <aarora@in.ibm.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org

Amit K. Arora wrote:
> On Sat, May 01, 2010 at 06:18:46AM -0400, Christoph Hellwig wrote:
>> On Sat, May 01, 2010 at 12:34:26PM +0530, Amit K. Arora wrote:
>>> Agreed. How about doing this check in the filesystem specific fallocate
>>> inode routines instead ? For example, in ext4 we could do :
>> That looks okay - in fact XFS should already have this check because
>> it re-uses the setattr implementation to set the size.
>>
>> Can you submit an xfstests testcase to verify this behaviour on all
>> filesystems?
> 
> Here is the new testcase.

Thanks!  A few comments...

> I have run this test on a x86_64 box on XFS and ext4 on 2.6.34-rc6. It
> passes on XFS, but fails on ext4. Below is the snapshot of results
> followed by the testcase itself.
> 
> --
> Regards,
> Amit Arora
> 
> Test results:
> ------------
> # ./check 228
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 elm9m93 2.6.34-rc6
> 
> 228 0s ...
> Ran: 228
> Passed all 1 tests
> #
> # umount /mnt
> # mkfs.ext4 /dev/sda4 >/dev/null
> mke2fs 1.41.10 (10-Feb-2009)
> # ./check 228
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 elm9m93 2.6.34-rc6
> 
> 228 0s ... - output mismatch (see 228.out.bad)
> --- 228.out	2010-05-03 02:51:24.000000000 -0400
> +++ 228.out.bad	2010-05-03 04:27:33.000000000 -0400
> @@ -1,2 +1 @@
>  QA output created by 228
> -File size limit exceeded (core dumped)
> Ran: 228
> Failures: 228
> Failed 1 of 1 tests
> #

228.out is missing from the patch

Also on my fedora box I don't get a coredump by default; can
you either make that explicit, or filter out the core message?

> 
> Here is the test:
> ----------------
> Add a new testcase to the xfstests suite to check if fallocate respects
> the limit imposed by RLIMIT_FSIZE (can be set by "ulimit -f XXX") or
> not, on a particular filesystem.

...

> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter

Nitpick, I don't think you need common.filter, doesn't look like you are 
using it.

> +# FSIZE limit is now set to 100 MB.
> +# Lets try to preallocate 101 MB. This should fail.
> +$XFS_IO_PROG -F -f -c 'falloc 0 101m' $TEST_DIR/ouch
> +rm -f $TEST_DIR/ouch
> +
> +# Lets now try to preallocate 50 MB. This should succeed.
> +$XFS_IO_PROG -F -f -c 'falloc 0 50m' $TEST_DIR/ouch
> +rm -f $TEST_DIR/ouch

Even more nitpicky, but sometimes I think it's nice to have the .out 
file be a bit more descriptive in and of itself so when you see a 
failing diff you have a better idea what's gone wrong.

Changing the comments to echos, like:

+# FSIZE limit is now set to 100 MB.
+# echo "Lets try to preallocate 101 MB. This should fail."
+$XFS_IO_PROG -F -f -c 'falloc 0 101m' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch

etc ... would make a failure look like:

--- 228.out	2010-05-04 15:42:31.924278768 -0500
+++ 228.out.bad	2010-05-04 15:42:36.961278392 -0500
@@ -1,3 +1,2 @@
 QA output created by 228
 Lets try to preallocate 101 MB. This should fail.
-File size limit exceeded
 Lets now try to preallocate 50 MB. This should succeed.

... just a thought.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
