Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5Q0U6SA160550 for <xfs@oss.sgi.com>; Sat, 25 Jun 2011 19:30:06 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69F16DF31A2
	for <xfs@oss.sgi.com>; Sat, 25 Jun 2011 17:30:05 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id IABNTArrIA22QaWF for
	<xfs@oss.sgi.com>; Sat, 25 Jun 2011 17:30:05 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.tlinx.org (8.14.4/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5Q0Tr6s024506 for <xfs@oss.sgi.com>; Sat, 25 Jun 2011 17:29:55 -0700
Message-ID: <4E067D81.4070605@tlinx.org>
Date: Sat, 25 Jun 2011 17:29:53 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: question on new feature complexity/possibility/sensibility? (^
	Alternate)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

I noticed in the 'cp' (coretuils 8.9-4.1) command on suse, there is a 
a "--reflink" that controls "clone/CoW" copies -- which says
it performs a 'lightweight' copy where the data blocks are copied
only when modified.  Now it is vague the 'when modified', (i.e.
does it mean ones that are different between the two copies) (src
and dst), or does it mean only to copy blocks that were modified
since 'some point' -- Doesn't say, but would guess it's src/dst diffs
(I wonder if it is restricted to the same physical filesystem).

Anyway, turns out, it's only for BTRFS (which I haven't yet used, 
and therefore know only that it supports operations like the above).  

Would it be practice to implement, some similar, feature in XFS?

It wouldn't be practice or useful to do it on an 'extent' basis due
to their large size...So to do something similar on XFS, I was
thinking,  with "some amount of effort", some number of 
"updated extents" could be kept, in addition to the original data.

Any future modifications to the file would also have the extents 
modified, but any extents that overlap previous mods will be 
merged, and only the newest data would be kept (meaning that
new sections that are written, that skip over parts of the 
file, wouldn't overwrite a pending change to that section -- only
the bytes (granularity?)  that were changed.

I.e. file is 1Mb.
User1 updates bytes 1k-200k.
User2, later updates bytes 100k-300k, 
New modification 'extent' is created with 1k-300k, with bytes
1k-(100k-1) from user1 be saved, and 100k-300k from user2.

Changes to the 'base' copy would be made upon some ioctl 'sync'
command (file-by-file)...  

It would require up to double the amount of file space.


----
Another possibility would simply be to create a record of byte
ranges that have been updated in the extent and the extent's last
modification time.  Then one could compare the mod times and 
apply the changes.   The problem there would be having to keep a
possibly 'large' log of changes (what if it's not sync/purged...
couldn't be circular as that would allow events to be lost -- though
the file system could be forced 'offline' if the event log became full
...a major pain...)..., but if it was created with a few G of space, 
might take a while...and if synced in time, no prob.



Still, may be no great desire or benefit, but DAMN if I haven't
wanted copy-on-write files for a LONG time.

I.e. being able to hardlink files, but have an option to mark it as
copy on write -- allowing space to be save when copying directory trees,
but then dynamically making new copies when someone updates one of the
linked copies.



Maybe that's a different feature that could be more easily done?

Anyway -- the new copy option just got me thinking....

Any ideas or work in thinking about things in this area for XFS to
keep it updated and 'current as a "Filesystem of Choice"....?


Thanks,
Linda



so if a user wants to modify it -- it 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
