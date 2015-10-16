Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B1797F3F
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 20:45:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 997E1AC003
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:45:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	na16nuw0PCBNRm6P for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 18:45:18 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zmu4u-00019p-Qj
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zmu4u-00005n-Pi
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfsdump: Ouchie! My bleeding eyes!
Date: Fri, 16 Oct 2015 12:44:53 +1100
Message-Id: <1444959901-31319-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

Turns out that changes to exported XFS headers in xfsprogs v4.2.0
broke the xfsdump build. the XFS dump build was implicitly including
the platform definitions calculated for the xfsprogs build and so
removing them from the xfsprogs headers made xfsdump very unhappy.

I've spend the last couple of days dripping blood from my eyeballs
all over my keyboard trying to clean up the mess a bit. This patch
set fixes the build issue and tries to minimise the amount of XFS
header inclusion across the xfsdump code base.

To this end:

	1. remove xfsdump's use of ASSERT because the definition in
	the XFs headers overrode everything else. So the first patch
	is a global s/ASSERT/assert/, #include <assert.h> change.

	2. fix the build issues. With the assert conflict out of the
	way, patch 2 includes all the bits xfsdump really needed
	from the xfsprogs platform defs. This is added to the
	include/config.h.in file, and this is then included across
	the code base.

	3. xfs/jdm.h does "typedef int intgen_t;" for it's API.
	xfsdump uses it *everywhere* (~900 instances across the code
	base), yet everywhere it is used an "int" will sufficient
	and there's only a handful of jdm_* API calls anyway.  Patch
	3 is therefore s/intgen_t/int/g

	4. why use uint*_t when you can use a random mix of types?
	Patch 4 is therefore s/u_int/uint/g

	5. xfs_ino_t. Always going to be uint64_t. Use a local
	definition, not pull all of XFS into all of xfsdump just for
	a single typedef (patch 5).

	6. Use <uuid/uuid.h>, not whatever hacked up uuid interface
	that you get from the XFS headers, which is not then used
	correctly because nothing uses the "platform_uuid_*()"
	abstraction the XFS headers provide. Clearly, xfsdump has
	only *ever* been compiled on Linux, as the build will break
	on BSD based platforms like Irix and FreeBSD. xfsdump is a
	Linux only source tree right now....

	7. Yeah, lets put random stuff in a header file that is
	included all over the place that requires the XFS headers to
	be included. Patch 7 pulls out the bits used by
	logging/reporting and puts them in the logging/reporting
	source files.

	8. Kill as many <xfs/xfs.h> and <xfs/jdm.h> includes as
	possible. Most of the files including them are now just
	missing system header includes and no longer need util.h, so
	patch 8 cleans up all that mess. 

So, now the code base is a little bit cleaner, a lot less dependent
on the xfsprogs header files, compiles cleanly on xfsprogs 3.2.x and
4.x releases, can easily have asserts build in or excluded (distro
packages need to use "export DEBUG=-DNDEBUG" to exclude asserts),
passes xfstests with asserts enabled and disabled, and best of all
the source code is a little less eye-bleedy.

I really don't expect anyone to review this closely - it's *huge*
chunk of boring search/replace change:

 94 files changed, 2929 insertions(+), 2652 deletions(-)

but I would like people to comment on/ack the approach I've taken
here. If nobody objects/cares, I'll then do a 3.1.6 release early
next week....

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
