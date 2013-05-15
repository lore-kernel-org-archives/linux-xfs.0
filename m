Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 453D77F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 17:19:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FFFC8F8059
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 15:19:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id J1uX7sl5eGGdJEc3 for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 15:19:53 -0700 (PDT)
Message-ID: <51940A08.2040306@sandeen.net>
Date: Wed, 15 May 2013 17:19:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: any way to work backwards from xfs_inode_t to a filename?
References: <5194050B.7010401@genband.com> <20130515221000.GX812@sgi.com>
In-Reply-To: <20130515221000.GX812@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Chris Friesen <chris.friesen@genband.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

On 5/15/13 5:10 PM, Ben Myers wrote:
> Hey Chris,
> 
> On Wed, May 15, 2013 at 03:58:35PM -0600, Chris Friesen wrote:
>> As I mentioned before I'm digging into some intermittent xfs
>> corruption issues on an embedded system running a 2.6.27-based
>> kernel.
>>
>> In one case I've hit XFS_WANT_CORRUPTED_GOTO in
>> xfs_free_ag_extent(). In this particular case the call chain was
>>
>> xfs_free_ag_extent+0x55d/0x6e0
>> xfs_free_extent+0xac/0xd0
>> xfs_bmap_finish+0x156/0x1a0
>> xfs_itruncate_finish+0x137/0x340
>> xfs_inactive+0x386/0x4b0
>> xfs_fs_clear_inode+0xc6/0x120
>> clear_inode+0x58/0x110
>> generic_delete_inode+0xff/0x110
>> generic_drop_inode+0x16d/0x190
>> iput+0x5d/0x70
>> do_unlinkat+0x147/0x280
>> sys_unlinkat+0x1d/0x40
>>
>> I have two questions:
>>
>> 1) do_unlinkat() has the filesystem path, but iput() returns void.
>> Is there any way for me to add instrumentation to xfs_inactive() to
>> work backwards from the xfs_inode_t pointer to print out a path to
>> the file being deleted?
> 
> Use VFS_I to get to a 'struct inode' and from there you can look at the
> dentries on i_dentry list and traverse back through the path by looking at
> d_parent.  Might be easier to just print the path in do_unlinkat?

or just print out the inode nr (i_ino) and do a find -inum after the fact.  :)

-Eric </lazy>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
