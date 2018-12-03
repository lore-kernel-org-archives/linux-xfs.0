Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:60959
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbeLCIe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:34:26 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/11] fs: fixes for major copy_file_range() issues
Date: Mon,  3 Dec 2018 19:34:05 +1100
Message-Id: <20181203083416.28978-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

Hi folks,

As most of you already know, we really suck at introducing new
functionality. The recent problems we found with clone/dedupe file
range interfaces also plague the copy_file_range() API and
implementation. Not only doesn't it do exactly what the man page
says, the man page doesn't document everything the syscal does
either.

There's a few problems:
	- can overwrite setuid files
	- can read from and overwrite active swap files
	- can overwrite immutable files
	- doesn't update timestamps
	- doesn't obey resource limits
	- doesn't catch overlapping copy ranges to the same file
	- doesn't consistently implement fallback strategies
	- does error out when the source range extends past EOF like
	  the man page says it should
	- isn't consistent with clone file range behaviour
	- inconsistent behaviour between filesystems
	- inconsistent fallback implementations

And so on. There's so much wrong, and I haven't even got to the
problems that the generic fallback code (i.e. do_splice_direct()
has). That's for another day.

So, what this series attempts to do is clean up the code, implement
all the missing checks, provide an infrastructure layout that allows
for consistent behaviour across filesystems and allows filesysetms
to control fallback mechanisms and cross-device copies.

I'll repeat that so it's clear: the series also enabled cross-device
copies once all the problems are sorted out.

To that end, the current fallback code is moved to
generic_copy_file_range(), and that is called only if the filesystem
does not provide a ->copy_file_range implementation. If the
filesystem provides such a method, itmust implement the page cache
copy fallback itself by calling generic_copy_file_range() when
appropriate. I did this because different filesystems have different
copy-offload capabilities and so need to fall back in different
situations. It's easier to have them call generic_copy_file_range()
to do that copy when necessary than it is to have them try to
communicate back up to vfs_copy_file_range() that it should run a
fallback copy.

To make all the implementations perform the same validity checks, 
I've created a generic_copy_file_checks() which is similar to the
checks we do for clone/dedupe. It's not quite the same, but the core
is very similar. This strips setuid, updates timestamps, checks and
enforces filesystem and resource limits, bounds checks the copy
ranges, etc.

This needs to be run before we call ->remap_file_range() so that we
end up with consistent behaviour across copy_file_range() calls.
e.g. we want an XFS filesystem with reflink=1 (i.e. supports
->remap_file_range()) to behave the same as an XFS filesystem with
reflink=0. Hence we need to check all the parameters up front so we
don't end up with calls to ->remap_file_range() resulting in
different behaviour.

It also means that ->copy_file_range implementations only need to
bounds checking the input against fileystem internal constraints,
not everything. This makes the filesystem implementations simpler,
and means they can call the falloback generic_copy_file_range()
implementation without having to care about further bounds checking.

I have not changed the fallback behaviour of the CIFS, Ceph or NFS
client implementations. The still reject copy_file_range() to the
same file with EINVAL, even though it is supported by the fallback
and filesystems that implement ->remap_file_range(). I'll leave it
for the maintainers to decide if they want to implement the manual
data copy fallback or not. My personal opinion is that they should
implement the fallback where-ever they can, but userspace has to be
prepared for copy_file_range() to fail and so implementing the
fallback is an optional feature.

In terms of testing, Darrick and I have been beating the hell out of
copy_file_range with fsx on XFS to sort out all the data corruption
problems it has exposed (we're still working on that). Patches have
been posted to enhance fsx and fsstress in fstests to exercise
clone/dedupe/copy_file_range. Thread here:

https://www.spinics.net/lists/fstests/msg10920.html

I've also written a bounds/behaviour exercising test:

https://marc.info/?l=fstests&m=154381938829897&w=2
https://marc.info/?l=fstests&m=154381939029898&w=2
https://marc.info/?l=fstests&m=154381939229899&w=2
https://marc.info/?l=fstests&m=154381939329900&w=2

I don't know whether I've got all the permission tests right in this
patchset. There's absolutely no documentation telling us when we
should use file_permission, inode_permission, etc in the
documentation or the code, so I just added the things that made the
tests do the things i think are the right things to be doing.

To run the tests, you'll also need modifications to xfs_io to allow
it to modify state appropriately. This is something we have
overlooked in the past, and so a lots of xfs_io based behaviour
checking is not actually testing the syscall we thought it was
testing but is instead testing the permission checking of the open()
syscall. Those patches are here:

https://marc.info/?l=linux-xfs&m=154378403323889&w=2
https://marc.info/?l=linux-xfs&m=154378403523890&w=2
https://marc.info/?l=linux-xfs&m=154378403323888&w=2
https://marc.info/?l=linux-xfs&m=154379644526132&w=2

These changes really need to go in before we merge any more
copy_file_range() features - we need to get the basics right and get
test coverage over it before we unleash things like NFS server-side
copies on unsuspecting users with filesystems that have busted
copy_file_range() implementations.

I'll be appending a man page patch to this series that documents all
the errors this syscall can throw, the expected behaviours, etc. The
test and the man page were written together first, and the
implementation changes were done second. So if you don't agree with
the behaviour, discuss what the man page patch should say and define,
then I'll change the test to reflect that and I'll go from there.

-Dave.
