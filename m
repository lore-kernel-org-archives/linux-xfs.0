Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FKl9GK129445 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 14:47:19 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EECB1C54707
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 12:47:50 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id j1yACLu0itSUkMjM for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2010 12:47:50 -0800 (PST)
Message-ID: <4B50D476.2040407@sandeen.net>
Date: Fri, 15 Jan 2010 14:47:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs 3.1.0 repair problems?
References: <4B4FDC3E.6030205@sandeen.net>
	<20100115055628.GD28498@discord.disaster>
In-Reply-To: <20100115055628.GD28498@discord.disaster>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Jan 14, 2010 at 09:08:46PM -0600, Eric Sandeen wrote:
>> It looks like maybe the freespace checking isn't quite up to par:
>>
>> test 073 is dying with:
>>
>> _check_xfs_filesystem: filesystem on /mnt/test/14309.image is inconsistent
>> *** xfs_repair -n output ***
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - scan filesystem freespace and inode maps...
>> sb_fdblocks 26156829, counted 26157853
>>         - found root inode chunk
> 
> This is caused by the remount,ro done in the test - the superblock
> is written to disk with the reserved blocks considered used. At
> unmount time those reserve blocks are "freed" before the superblock
> is written and so the total is correct at that time.
> 
> I'm going to go look at the kernel code now...
> 
> Cheers,
> 
> Dave.

Today, I'm intermittently getting xfs_repair segfaults, in btree_get_prev,
but this seems odd:

Program terminated with signal 11, Segmentation fault.
#0  btree_get_prev (key=0x9fc330, root=0x9fc300) at btree.c:190
p190		if (cur->index > 0) {
(gdb) list btree.c:190
185	{
186		struct btree_cursor	*cur = root->cursor;
187		int			level = 0;
188		struct btree_node	*node;
189	
190		if (cur->index > 0) {
191			if (key)
192				*key = cur->node->keys[cur->index - 1];
193			return cur->node->ptrs[cur->index - 1];
194		}
(gdb) p *root
$1 = {root_node = 0x7fca8400fac0, cursor = 0x7fca8400e0e0, height = 1, keys_valid = 1, cur_key = 6792640, next_key = 0, next_value = 0x0, prev_key = 0, prev_value = 0x0}
(gdb) p cur
$2 = (struct btree_cursor *) 0x0
(gdb) quit


root->cursor is valid, but cur is not?

Still looking....

But maybe related to the initial problem... this is cropping up in
the post-test check & repair that xfstests does.

I imaged the filesystem before the checking in hopes of getting a
reproducer.  When the testsuite runs, repair looks clean, but
then it segfaults.

If I then point repair at the filesystem image I created prior
to the segfault, it lights up with tons of errors.  I'm confused
by that; one interesting thing is that repair is testing a mounted,
readonly filesystem when xfstests runs.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
