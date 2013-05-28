Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 996F87F55
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 12:56:30 -0500 (CDT)
Date: Tue, 28 May 2013 12:56:27 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATH 0/9] xfs: fixes for 3.10-rc4
Message-ID: <20130528175627.GZ20028@sgi.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Mon, May 27, 2013 at 04:38:18PM +1000, Dave Chinner wrote:
> This is an update for all the fixes I have for 3,10-rc4.
> 
> All the comments on the previous patches have been updated in this
> series, and there are two new patches. The first patch adds support
> for indicating that the filesystem has CRC enabled to userspace, and
> the second fixes the missing CRC updates on the unlinked inode list
> manipulations.

This seems to be getting a bit out of hand for a release candidate pull
request:

Fixes for xfs without crcs:
f648167f xfs: avoid nesting transactions in xfs_qm_scall_setqlim()
	 xfs: fix split buffer vector log recovery support
	 xfs: kill suid/sgid through the truncate path.

Fixes for xfs with crcs:
90253cf1 xfs: remote attribute allocation may be contiguous 
913e96bc xfs: remote attribute read too short
4af3644c xfs: remote attribute tail zeroing does too much
6863ef84 xfs: correctly map remote attr buffers during removal
8517de2a xfs: fully initialise temp leaf in xfs_attr3_leaf_unbalance
d4c712bc xfs: fully initialise temp leaf in xfs_attr3_leaf_compact
ad1858d7 xfs: rework remote attr CRCs
9a5b6dee xfs: fix incorrect remote symlink block count
	 xfs: rework dquot CRCs
	 xfs: inode unlinked list needs to recalculate the inode CRC 	* replaced with "2-3 patches"
	 xfs: fix dir3 freespace block corruption			* maybe this effects filesystems w/o crcs?

Dev work for xfs with crcs:
	 xfs: increase number of ACL entries for V5 superblocks
	 xfs: don't emit v5 superblock warnings on write
	 xfs: add fsgeom flag for v5 superblock support.
	 xfs: disable swap extents ioctl on CRC enabled filesystems

We're representing 3 patches which are clearly approprate for a release
candidate, 11 fixes for CRCs + 2 more for the rework of unlinked lists patch,
and 4 patches which are development work.

We pulled in the CRC work with the understanding that it is an experimental
feature that might not be perfect, and with a focus upon preventing regression
for existing users.  This did not imply that we're going after perfection for
CRCs during the 3.10 release candidate series.

I'll be happy to review the 17 CRC related patches for inclusion in the master
branch ASAP, but I'm afraid 17 patches is a bit much to ask for a release
candidate, even if it were -rc2.  Here we are in 3.11/feature-bit territory.
I'm going to focus on the top 3 for -rc4, and it also looks like 'xfs: fix dir3
freespace block corruption' may be a good candidate.  If there are others that
can cause trouble for existing users I'll appreciate it if you'll let me know.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
