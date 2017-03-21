Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49865 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756389AbdCUVzl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2017 17:55:41 -0400
Date: Wed, 22 Mar 2017 08:54:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH][PROGS] xfs_io: Allow setting multiple mode flags for
 fallocate()
Message-ID: <20170321215458.GC17542@dastard>
References: <c2fdfcbb1f4ac9a71633dfbe192ed1145b12b8ac.1489799604.git.calvinowens@fb.com>
 <20170318065554.GX17542@dastard>
 <8dc5334b-a7b9-d455-25b5-5d651a3b918d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dc5334b-a7b9-d455-25b5-5d651a3b918d@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Calvin Owens <calvinowens@fb.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Sun, Mar 19, 2017 at 09:33:50PM -0700, Calvin Owens wrote:
> On 03/17/2017 11:55 PM, Dave Chinner wrote:
> >On Fri, Mar 17, 2017 at 06:26:09PM -0700, Calvin Owens wrote:
> >>This allows testing FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE.
> >
> >Which is normally done through the "fpunch" command, which explains
> >why nobody has noticed this.
> 
> Ah okay, I was assuming parity with syscalls in the commands and picked
> the first one I saw ;)
> 
> >>Signed-off-by: Calvin Owens <calvinowens@fb.com>
> >>---
> >> io/prealloc.c | 10 +++++-----
> >> 1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >>diff --git a/io/prealloc.c b/io/prealloc.c
> >>index a9d66cc..2a4bcdc 100644
> >>--- a/io/prealloc.c
> >>+++ b/io/prealloc.c
> >>@@ -201,19 +201,19 @@ fallocate_f(
> >> 	while ((c = getopt(argc, argv, "cikpu")) != EOF) {
> >> 		switch (c) {
> >> 		case 'c':
> >>-			mode = FALLOC_FL_COLLAPSE_RANGE;
> >>+			mode |= FALLOC_FL_COLLAPSE_RANGE;
> >> 			break;
> >> 		case 'i':
> >>-			mode = FALLOC_FL_INSERT_RANGE;
> >>+			mode |= FALLOC_FL_INSERT_RANGE;
> >> 			break;
> >> 		case 'k':
> >>-			mode = FALLOC_FL_KEEP_SIZE;
> >>+			mode |= FALLOC_FL_KEEP_SIZE;
> >> 			break;
> >> 		case 'p':
> >>-			mode = FALLOC_FL_PUNCH_HOLE;
> >>+			mode |= FALLOC_FL_PUNCH_HOLE;
> >> 			break;
> >> 		case 'u':
> >>-			mode = FALLOC_FL_UNSHARE_RANGE;
> >>+			mode |= FALLOC_FL_UNSHARE_RANGE;
> >> 			break;
> >
> >NACK. We should not allow users to set invalid combinations
> >of commands such as 'falloc -cipu ...' - this would set the flags
> >(FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE |
> >FALLOC_FL_PUNCH_HOLE | FALLOC_FL_UNSHARE_RANGE) and will always
> >error out.
> 
> Isn't it potentially useful to test invalid behavior?

Yes, but exhaustive testing of syscall option validity is not what
xfs_io is for - xfs_io is for giving test scripts access to the syscall
functionality, and so if someone passes an invalid combination of
options it should fail.

> >The use of FALLOC_FL_KEEP_SIZE for the FALLOC_FL_PUNCH_HOLE command
> >is essentially for documentation purposes - it does not do
> >truncation, hence the FALLOC_FL_KEEP_SIZE flag was added to it to
> >ensure developers understand that it does not truncate the file and
> >change EOF.
> >
> >IOWs, the fix needed to make the 'falloc -p' command work is really
> >just this:
> >
> >-			mode = FALLOC_FL_PUNCH_HOLE;
> >+			mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
> 
> My thinking was just "allow full exercising of the syscall", fpunch works
> for my testcase so if you'd prefer not to do that we can just drop this :)

If you want to go test invalid combinations, write a syscall test
for ltp.

> It might be worth cleaning up 'falloc' though: '-k' doesn't really make
> sense on its own right?

As I said in my last response: "falloc -k" is a valid usage for
preallocation because it means "allow preallocation beyond EOF".
i.e. future writes that extend the file will not need to allocate
blocks....

> Maybe remove "-k" and make "-p" OR in KEEP_SIZE
> like you suggest?

See above, and the answer is obvious.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
