Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14C087F4E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 17:10:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6EC9AC003
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 15:10:48 -0800 (PST)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id GHDAOWY3ktaeEQOC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Nov 2014 15:10:47 -0800 (PST)
Received: by mail-pa0-f44.google.com with SMTP id et14so3795357pad.3
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 15:10:47 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH-v4 6/7] ext4: add support for a lazytime mount option
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20141126224843.GG9561@dastard>
Date: Wed, 26 Nov 2014 16:10:44 -0700
Message-Id: <1A106262-D64C-4493-856F-AAAFC3BE2647@dilger.ca>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-7-git-send-email-tytso@mit.edu>
	<20141126224843.GG9561@dastard>
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
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Nov 26, 2014, at 3:48 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Wed, Nov 26, 2014 at 05:23:56AM -0500, Theodore Ts'o wrote:
>> Add an optimization for the MS_LAZYTIME mount option so that we will
>> opportunistically write out any inodes with the I_DIRTY_TIME flag set
>> in a particular inode table block when we need to update some inode
>> in that inode table block anyway.
>> 
>> Also add some temporary code so that we can set the lazytime mount
>> option without needing a modified /sbin/mount program which can set
>> MS_LAZYTIME.  We can eventually make this go away once util-linux has
>> added support.
>> 
>> Google-Bug-Id: 18297052
>> 
>> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>> ---
>> fs/ext4/inode.c             | 49 ++++++++++++++++++++++++++++++++++++++++++---
>> fs/ext4/super.c             |  9 +++++++++
>> include/trace/events/ext4.h | 30 +++++++++++++++++++++++++++
>> 3 files changed, 85 insertions(+), 3 deletions(-)
>> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 5653fa4..8308c82 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4140,6 +4140,51 @@ static int ext4_inode_blocks_set(handle_t *handle,
>> }
>> 
>> /*
>> + * Opportunistically update the other time fields for other inodes in
>> + * the same inode table block.
>> + */
>> +static void ext4_update_other_inodes_time(struct super_block *sb,
>> +					  unsigned long orig_ino, char *buf)
>> +{
>> +	struct ext4_inode_info	*ei;
>> +	struct ext4_inode	*raw_inode;
>> +	unsigned long		ino;
>> +	struct inode		*inode;
>> +	int		i, inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
>> +	int		inode_size = EXT4_INODE_SIZE(sb);
>> +
>> +	ino = orig_ino & ~(inodes_per_block - 1);
>> +	for (i = 0; i < inodes_per_block; i++, ino++, buf += inode_size) {
>> +		if (ino == orig_ino)
>> +			continue;
>> +		inode = find_active_inode_nowait(sb, ino);
>> +		if (!inode ||
>> +		    (inode->i_state & I_DIRTY_TIME) == 0 ||
>> +		    !spin_trylock(&inode->i_lock)) {
>> +			iput(inode);
>> +			continue;
>> +		}
>> +		inode->i_state &= ~I_DIRTY_TIME;
>> +		inode->i_ts_dirty_day = 0;
>> +		spin_unlock(&inode->i_lock);
>> +		inode_requeue_dirtytime(inode);
>> +
>> +		ei = EXT4_I(inode);
>> +		raw_inode = (struct ext4_inode *) buf;
>> +
>> +		spin_lock(&ei->i_raw_lock);
>> +		EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
>> +		EXT4_INODE_SET_XTIME(i_mtime, inode, raw_inode);
>> +		EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
>> +		ext4_inode_csum_set(inode, raw_inode, ei);
>> +		spin_unlock(&ei->i_raw_lock);
>> +		trace_ext4_other_inode_update_time(inode, orig_ino);
>> +		iput(inode);
>> +	}
>> +}
> 
> Am I right in that this now does unlogged timestamp updates of
> inodes? What happens when that buffer gets overwritten by log
> recover after a crash? The timestamp updates get lost?
> 
> FYI, XFS has had all sorts of nasty log recovery corner cases
> caused by log recovery overwriting non-logged inode updates like
> this. In the past few years we've removed every single non-logged
> inode update "optimisation" so that all changes (including timestamps)
> are transactional so inode state on disk not matching what log
> recovery wrote to disk for all the other inode metadata...
> 
> Optimistic unlogged inode updates are a slippery slope, and history
> tells me that it doesn't lead to a nice place....

Since ext4/jbd2 is logging the whole block, unlike XFS which is doing
logical journaling, this isn't an unlogged update.  It is just taking
advantage of the fact that the whole block is going to be logged and
written to the disk anyway.  If the only update needed for other inodes
in the block is the timestamp then they may as well be flushed to disk
at the same time and avoid the need for another update later on.

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
