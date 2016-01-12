Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E07C7F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 03:01:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20DDFAC001
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 01:01:28 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IkjjDOXjaQnYUB37 for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 01:01:26 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aIupP-0005Jx-I6
	for xfs@oss.sgi.com; Tue, 12 Jan 2016 20:01:23 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aIupP-0008A6-HT
	for xfs@oss.sgi.com; Tue, 12 Jan 2016 20:01:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/8] xfs: shrink the struct xfs_icdinode
Date: Tue, 12 Jan 2016 20:01:12 +1100
Message-Id: <1452589280-30167-1-git-send-email-david@fromorbit.com>
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

This is a patchset I've written over the past couple of afternoons.
It smokes badly if you try to run it, so I'm posting this for early
feedback, not for testing and bug reports.

Despite it's name, the struct xfs_icdinode is an on-disk structure -
it gets copied directly to the log, and so we are kind of stuck with
keeping it around and all it's duplicate information while we do
this. Hence before we can shrink this structure, wehave ot break
it's link with the logging code.

That's what the first patch does - it introduces a struct
xfs_log_dinode, and the log formatting and reocvery code use that
for the structure that is placed physically in the log. We marshall
the variables from the xfs_icdinode in and out individually so we
break the dependence between the on-disk format and the
xfs_icdinode.

This now enables us to remove all the bits of the xfs_icdinode that
are either unused (e.g. padding), only used to support old formats,
or a duplicates with information stored in the VFS struct inode. As
a result, I've been able to reduce the xfs_icdinode from 176 bytes
down to:

        /* size: 72, cachelines: 2, members: 19 */
        /* sum members: 68, holes: 1, sum holes: 4 */

72 bytes. This means it takes 104 bytes off the size of the struct
xfs_inode, which a 12% reduction in size. This will be a massive win
for systems that cache lots of inodes!

I have not yet addressed the di_uid or the di_gid because I haven't
had time to look into the user namespace conversion issues that I'll
have to handle correctly to use the VFS inode fieldsr. I think
I can also pull up the di_nblocks field to the VFS inode as well. If
I manage this, I will reduce the xfs_icdinode by another 16 bytes.

With this change made, the xfs_icdinode is no long an "in core disk
inode" so I'm wondering whether I should rename it or simply make it
go away altogether and pull the remaining fields straight into the
struct xfs_inode. Any thoughts on new names and/or getting rid of it
woul dbe appreciated.

Some of the code is pretty raw - I haven't cleaned it up at all, so
do be surprised if there's things I've missed or changed in the
wrong patch, etc.

Comments, thoughts, flames, all welcome!

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
