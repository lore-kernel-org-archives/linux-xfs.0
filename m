Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B92E7FC7
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 08:33:04 -0500 (CDT)
Message-ID: <520B870F.8040808@sgi.com>
Date: Wed, 14 Aug 2013 08:33:03 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix inode crash in xfs_repair
References: <20130813221739.031858865@sgi.com> <20130814064013.GC12779@dastard>
In-Reply-To: <20130814064013.GC12779@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/14/13 01:40, Dave Chinner wrote:
> On Tue, Aug 13, 2013 at 05:13:31PM -0500, Mark Tinguely wrote:
>> Adding the lost+found in phase 6 could allocate an inode from
>> a new inode chunk. That newly created chunk was not around in
>> the scan phase, and is not in the avl tree which will result
>> in a NULL dereference.
>>
>> This patch adds the newly created inode chunk and inodes as if
>> found in the scan phase.
>>
>> Metadata dump available for future tests.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---
>>   repair/incore_ino.c |    2 +-
>>   repair/phase6.c     |   15 +++++++++++++++
>>   2 files changed, 16 insertions(+), 1 deletion(-)
>>
>> Index: b/repair/incore_ino.c
>> ===================================================================
>> --- a/repair/incore_ino.c
>> +++ b/repair/incore_ino.c
>> @@ -700,7 +700,7 @@ get_inode_parent(ino_tree_node_t *irec,
>>   	return(0LL);
>>   }
>>
>> -static void
>> +void
>>   alloc_ex_data(ino_tree_node_t *irec)
>>   {
>>   	parent_list_t 	*ptbl;
>> Index: b/repair/phase6.c
>> ===================================================================
>> --- a/repair/phase6.c
>> +++ b/repair/phase6.c
>> @@ -930,6 +930,21 @@ mk_orphanage(xfs_mount_t *mp)
>>   	irec = find_inode_rec(mp,
>>   			XFS_INO_TO_AGNO(mp, ino),
>>   			XFS_INO_TO_AGINO(mp, ino));
>> +
>> +	if (irec == NULL&&  XFS_INO_TO_AGNO(mp, ino)<  mp->m_sb.sb_agcount&&
>> +	    ip != NULL&&  ip->i_d.di_magic == XFS_DINODE_MAGIC) {
>
> I don't understand this check.
>
> We've already dereferenced ip several lines above to increment the
> link count and get the inode number stored in ino, so the ip != NULL
> is unnecessary.
>
> We've just allocated the inode, so why would the magic number be
> wrong? And why would the inode number lie in a non-existent
> allocation group?
>

just being being paranoid.

>> +		/*
>> +		 * add the newly allocated inode chunk to the avl tree.
>> +		 */
>
> I can see from the code we are allocating and irec, inserting it
> into the AVL tree and marking all the inodes in the chunk as free.
> The comment should explain *why* we need to do this.
>
> Cheers,
>
> Dave.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
