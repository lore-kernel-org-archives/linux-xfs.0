Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F1BF7F37
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 02:32:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 020AE304043
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 00:32:51 -0700 (PDT)
Received: from smtp-out6.electric.net ([192.162.217.191]) by cuda.sgi.com with
	ESMTP id WvtLaBsa67QDXKFk (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 00:32:48 -0700 (PDT)
Message-ID: <556C0A9B.6000404@pml.ac.uk>
Date: Mon, 1 Jun 2015 08:32:43 +0100
From: Mike Grant <mggr@pml.ac.uk>
MIME-Version: 1.0
Subject: Re: xfs_repair segfault + debug info
References: <556871CD.6090507@pml.ac.uk> <20150529222717.GB24666@dastard>
In-Reply-To: <20150529222717.GB24666@dastard>
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
Cc: xfs@oss.sgi.com

On 29/05/15 23:27, Dave Chinner wrote:
> Given it is choking on directory corruption repair, I'd strong
> recommend trying the current git version (3.2.3-rc1) here:

Thanks for the reply.  I did actually grab the git version (as of May
28) before bothering you all and got something that looked like the same
crash.  The log is here:

https://rsg.pml.ac.uk/shared_files/mggr/xfs_segfault/xfs_repair_fail-git.log

Since I messed up the backtrace on that log, here it is in full (binary
and core also available from the parent directory of the link above):
#0  libxfs_putbuf (bp=0x100010000) at rdwr.c:656
#1  0x000000000041e7ce in longform_dir2_entry_check (hashtab=<optimized
out>, ino_offset=37, irec=0x7f37ddaafe20, need_dot=0x7fff1955bad0,
num_illegal=0x7fff1955bad8,
    ip=0x11696610, ino=20136101, mp=0x7fff1955c170) at phase6.c:2297
#2  process_dir_inode (mp=0x7fff1955c170, agno=agno@entry=0,
irec=irec@entry=0x7f37ddaafe20, ino_offset=ino_offset@entry=37) at
phase6.c:2801
#3  0x00000000004205f6 in traverse_function (wq=0x7fff1955bdc0, agno=0,
arg=0x0) at phase6.c:3085
#4  0x00000000004255fa in prefetch_ag_range (work=0x7fff1955bdc0,
start_ag=<optimized out>, end_ag=204, dirs_only=true, func=0x420560
<traverse_function>) at prefetch.c:906
#5  0x000000000042575b in do_inode_prefetch (mp=0x7fff1955c170,
stride=0, func=0x420560 <traverse_function>, check_cache=<optimized
out>, dirs_only=true) at prefetch.c:969
#6  0x0000000000421365 in traverse_ags (mp=0x7fff1955c170) at phase6.c:3115
#7  phase6 (mp=mp@entry=0x7fff1955c170) at phase6.c:3203
#8  0x00000000004036c6 in main (argc=<optimized out>, argv=<optimized
out>) at xfs_repair.c:808

> Probably because you turned off prefetch, which makes it *slow*. :P

Ah, fair enough - my colleague was trying to reduce RAM usage before we
dug deeper into it and I just picked up his command line when
replicating his results.  I'll ditch the -P in future.

> Just remember, though, that even once the FS has been repaired,
> you'll still have to search for data corruption manually and deal
> with that...

Yeah, we're conscious that the data are probably damaged :(  My main aim
here is to provide some debug data for a xfs_repair crasher.

Cheers,

Mike.


Please visit our new website at www.pml.ac.uk and follow us on Twitter  @PlymouthMarine

Winner of the Environment & Conservation category, the Charity Awards 2014.

Plymouth Marine Laboratory (PML) is a company limited by guarantee registered in England & Wales, company number 4178503. Registered Charity No. 1091222. Registered Office: Prospect Place, The Hoe, Plymouth  PL1 3DH, UK. 

This message is private and confidential. If you have received this message in error, please notify the sender and remove it from your system. You are reminded that e-mail communications are not secure and may contain viruses; PML accepts no liability for any loss or damage which may be caused by viruses.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
