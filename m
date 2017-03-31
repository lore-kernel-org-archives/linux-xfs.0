Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36434 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750748AbdCaEPY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 00:15:24 -0400
Date: Thu, 30 Mar 2017 21:14:52 -0700
From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH][PROGS] xfs_io: Allow setting multiple mode flags for
 fallocate()
Message-ID: <20170331041452.e7lvxwq3hla3kims@Haydn>
References: <c2fdfcbb1f4ac9a71633dfbe192ed1145b12b8ac.1489799604.git.calvinowens@fb.com>
 <20170318065554.GX17542@dastard>
 <8dc5334b-a7b9-d455-25b5-5d651a3b918d@fb.com>
 <20170321215458.GC17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20170321215458.GC17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Wednesday 03/22 at 08:54 +1100, Dave Chinner wrote:
> On Sun, Mar 19, 2017 at 09:33:50PM -0700, Calvin Owens wrote:
> > On 03/17/2017 11:55 PM, Dave Chinner wrote:
> > >On Fri, Mar 17, 2017 at 06:26:09PM -0700, Calvin Owens wrote:
> > >>This allows testing FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE.
> > >
> > >Which is normally done through the "fpunch" command, which explains
> > >why nobody has noticed this.
> > 
> > Ah okay, I was assuming parity with syscalls in the commands and picked
> > the first one I saw ;)
> > 
> > >>Signed-off-by: Calvin Owens <calvinowens@fb.com>
> > >>---
> > >> io/prealloc.c | 10 +++++-----
> > >> 1 file changed, 5 insertions(+), 5 deletions(-)
> > >>
> > >>diff --git a/io/prealloc.c b/io/prealloc.c
> > >>index a9d66cc..2a4bcdc 100644
> > >>--- a/io/prealloc.c
> > >>+++ b/io/prealloc.c
> > >>@@ -201,19 +201,19 @@ fallocate_f(
> > >> 	while ((c = getopt(argc, argv, "cikpu")) != EOF) {
> > >> 		switch (c) {
> > >> 		case 'c':
> > >>-			mode = FALLOC_FL_COLLAPSE_RANGE;
> > >>+			mode |= FALLOC_FL_COLLAPSE_RANGE;
> > >> 			break;
> > >> 		case 'i':
> > >>-			mode = FALLOC_FL_INSERT_RANGE;
> > >>+			mode |= FALLOC_FL_INSERT_RANGE;
> > >> 			break;
> > >> 		case 'k':
> > >>-			mode = FALLOC_FL_KEEP_SIZE;
> > >>+			mode |= FALLOC_FL_KEEP_SIZE;
> > >> 			break;
> > >> 		case 'p':
> > >>-			mode = FALLOC_FL_PUNCH_HOLE;
> > >>+			mode |= FALLOC_FL_PUNCH_HOLE;
> > >> 			break;
> > >> 		case 'u':
> > >>-			mode = FALLOC_FL_UNSHARE_RANGE;
> > >>+			mode |= FALLOC_FL_UNSHARE_RANGE;
> > >> 			break;
> > >
> > >NACK. We should not allow users to set invalid combinations
> > >of commands such as 'falloc -cipu ...' - this would set the flags
> > >(FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE |
> > >FALLOC_FL_PUNCH_HOLE | FALLOC_FL_UNSHARE_RANGE) and will always
> > >error out.
> > 
> > Isn't it potentially useful to test invalid behavior?
> 
> Yes, but exhaustive testing of syscall option validity is not what
> xfs_io is for - xfs_io is for giving test scripts access to the syscall
> functionality, and so if someone passes an invalid combination of
> options it should fail.
> 
> > >The use of FALLOC_FL_KEEP_SIZE for the FALLOC_FL_PUNCH_HOLE command
> > >is essentially for documentation purposes - it does not do
> > >truncation, hence the FALLOC_FL_KEEP_SIZE flag was added to it to
> > >ensure developers understand that it does not truncate the file and
> > >change EOF.
> > >
> > >IOWs, the fix needed to make the 'falloc -p' command work is really
> > >just this:
> > >
> > >-			mode = FALLOC_FL_PUNCH_HOLE;
> > >+			mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
> > 
> > My thinking was just "allow full exercising of the syscall", fpunch works
> > for my testcase so if you'd prefer not to do that we can just drop this :)
> 
> If you want to go test invalid combinations, write a syscall test
> for ltp.
> 
> > It might be worth cleaning up 'falloc' though: '-k' doesn't really make
> > sense on its own right?
> 
> As I said in my last response: "falloc -k" is a valid usage for
> preallocation because it means "allow preallocation beyond EOF".
> i.e. future writes that extend the file will not need to allocate
> blocks....

The point I'm trying to make is that it's fundamentally confusing to have
switches like "-k" and "-p" for ORable flags in a syscall argument, when
the switches don't themselves support being combined. ZERO_RANGE for
example is ORable with KEEP_SIZE or valid on its own; if "-z" were added
we couldn't blame the user for thinking that "-z -k" is a valid thing to
do, could we?

But this is pedantic and obviously relatively unimportant, patch below.

Thanks,
Calvin

---8<---
From: Calvin Owens <calvinowens@fb.com>
Date: Thu, 30 Mar 2017 20:50:55 -0700
Subject: [PATCH] io/prealloc: Fix "falloc -p" to pass KEEP_SIZE

Otherwise, the syscall just returns -EOPPNOTSUPP.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 io/prealloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index a9d66cc..1a1c9ca 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -210,7 +210,7 @@ fallocate_f(
 			mode = FALLOC_FL_KEEP_SIZE;
 			break;
 		case 'p':
-			mode = FALLOC_FL_PUNCH_HOLE;
+			mode = FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE;
 			break;
 		case 'u':
 			mode = FALLOC_FL_UNSHARE_RANGE;
-- 
2.9.3

