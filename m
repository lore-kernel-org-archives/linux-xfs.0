Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5EDD77F56
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 13:50:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3352C8F8035
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 11:50:03 -0700 (PDT)
Received: from smtp-out6.electric.net ([192.162.217.194]) by cuda.sgi.com with
	ESMTP id uNBD9j5R7l9OFMeM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 11:49:59 -0700 (PDT)
Message-ID: <557B29D4.8030805@pml.ac.uk>
Date: Fri, 12 Jun 2015 19:49:56 +0100
From: Mike Grant <mggr@pml.ac.uk>
MIME-Version: 1.0
Subject: [PATCH] Re: xfs_repair segfault + debug info
References: <556871CD.6090507@pml.ac.uk> <20150529222717.GB24666@dastard>
	<556C0A9B.6000404@pml.ac.uk>
In-Reply-To: <556C0A9B.6000404@pml.ac.uk>
Content-Type: multipart/mixed; boundary="------------000809040906030006030304"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--------------000809040906030006030304
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I had a bit of time, so dug into this more and found a possible bug.

longform_dir2_entry_check in phase6.c has a calloc'ed array of xfs_buf
pointers (bplist).  On line 2331, it reallocs this array if there turns
out to be more blocks than expected.  However, realloc doesn't zero the
new memory like calloc.  In unusual circumstances*, things may then blow
up later due to random data populating the new part of the array.

This is easily fixed by zeroing the new part of the array.  A diff
against master is attached, using memset to do this (though you might
have a nicer way to do it).  When patched, the xfs_repair ran through to
completion for my corrupted filesystem.

I also looked through the rest of xfs_repair, looking for similar
pairings of calloc + realloc, but didn't spot any, so I think this is an
isolated case.  I've not checked the rest of xfs_progs.

Cheers,

Mike.

* (bit speculative) as dir_read_buf zeros the element it's looking at, I
think this can only happen if the realloc adds several members and one
of the first is corrupt.  In my case, the realloc went from 35 to 37
members, meaning db must have been 36 without being 35.  A read error
then caused it to goto out_fix. The crash then occurred in the
libxfs_putbuf when looping through the bplist structure, checking it for
NULL pointers (and presumably tripping over the non-zeroed data at
position 35?

I see it loops on freetab->naents rather than num_bps though, so I'm not
certain it's also including the realloced part of the list here, unless
freetab->naents is updated somewhere.. this might be another bug, or
might be I just don't understand it

On 01/06/15 08:32, Mike Grant wrote:
> On 29/05/15 23:27, Dave Chinner wrote:
>> Given it is choking on directory corruption repair, I'd strong
>> recommend trying the current git version (3.2.3-rc1) here:
> 
> Thanks for the reply.  I did actually grab the git version (as of May
> 28) before bothering you all and got something that looked like the same
> crash.  The log is here:
> 
> https://rsg.pml.ac.uk/shared_files/mggr/xfs_segfault/xfs_repair_fail-git.log
> 
> Since I messed up the backtrace on that log, here it is in full (binary
> and core also available from the parent directory of the link above):
> #0  libxfs_putbuf (bp=0x100010000) at rdwr.c:656
> #1  0x000000000041e7ce in longform_dir2_entry_check (hashtab=<optimized
> out>, ino_offset=37, irec=0x7f37ddaafe20, need_dot=0x7fff1955bad0,
> num_illegal=0x7fff1955bad8,
>     ip=0x11696610, ino=20136101, mp=0x7fff1955c170) at phase6.c:2297
> #2  process_dir_inode (mp=0x7fff1955c170, agno=agno@entry=0,
> irec=irec@entry=0x7f37ddaafe20, ino_offset=ino_offset@entry=37) at
> phase6.c:2801
> #3  0x00000000004205f6 in traverse_function (wq=0x7fff1955bdc0, agno=0,
> arg=0x0) at phase6.c:3085
> #4  0x00000000004255fa in prefetch_ag_range (work=0x7fff1955bdc0,
> start_ag=<optimized out>, end_ag=204, dirs_only=true, func=0x420560
> <traverse_function>) at prefetch.c:906
> #5  0x000000000042575b in do_inode_prefetch (mp=0x7fff1955c170,
> stride=0, func=0x420560 <traverse_function>, check_cache=<optimized
> out>, dirs_only=true) at prefetch.c:969
> #6  0x0000000000421365 in traverse_ags (mp=0x7fff1955c170) at phase6.c:3115
> #7  phase6 (mp=mp@entry=0x7fff1955c170) at phase6.c:3203
> #8  0x00000000004036c6 in main (argc=<optimized out>, argv=<optimized
> out>) at xfs_repair.c:808


Please visit our new website at www.pml.ac.uk and follow us on Twitter  @PlymouthMarine

Winner of the Environment & Conservation category, the Charity Awards 2014.

Plymouth Marine Laboratory (PML) is a company limited by guarantee registered in England & Wales, company number 4178503. Registered Charity No. 1091222. Registered Office: Prospect Place, The Hoe, Plymouth  PL1 3DH, UK. 

This message is private and confidential. If you have received this message in error, please notify the sender and remove it from your system. You are reminded that e-mail communications are not secure and may contain viruses; PML accepts no liability for any loss or damage which may be caused by viruses.


--------------000809040906030006030304
Content-Type: text/x-patch; name="realloc.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="realloc.diff"

diff --git a/repair/phase6.c b/repair/phase6.c
index 105bce4..ed44e1b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2326,12 +2326,15 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		db = xfs_dir2_da_to_db(mp, da_bno);
 		if (db >= num_bps) {
 			/* more data blocks than expected */
+			int num_bps_prev = num_bps;
 			num_bps = db + 1;
 			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
 			if (!bplist)
 				do_error(_("realloc failed in %s (%zu bytes)\n"),
 					__func__,
 					num_bps * sizeof(struct xfs_buf*));
+			/* clear new memory as previous bplist was calloc'ed */
+			memset( (void *) bplist + num_bps_prev * sizeof(struct xfs_buf*), 0, (num_bps - num_bps_prev) * sizeof(struct xfs_buf*));
 		}
 
 		if (isblock)

--------------000809040906030006030304
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------000809040906030006030304--
