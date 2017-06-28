Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751900AbdF1Arl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 20:47:41 -0400
Subject: Re: [PATCH] xfs_db: properly set inode type
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
 <20170628004252.GB4492@birch.djwong.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <bb9f2c48-b862-0dab-e198-c6b73aaea5c0@redhat.com>
Date: Tue, 27 Jun 2017 19:47:39 -0500
MIME-Version: 1.0
In-Reply-To: <20170628004252.GB4492@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 6/27/17 7:42 PM, Darrick J. Wong wrote:
> On Tue, Jun 27, 2017 at 07:16:39PM -0500, Eric Sandeen wrote:
>> When we set the type to "inode" the verifier validates multiple
>> inodes in the current fs block, so setting the buffer size to
>> that of just one inode is not sufficient and it'll emit spurious
>> verifier errors for all but the first, as we read off the end:
>>
>> xfs_db> daddr 99
>> xfs_db> type inode
>> Metadata corruption detected at xfs_inode block 0x63/0x200
>> Metadata corruption detected at xfs_inode block 0x63/0x200
>> Metadata corruption detected at xfs_inode block 0x63/0x200
>> Metadata corruption detected at xfs_inode block 0x63/0x200
>> Metadata corruption detected at xfs_inode block 0x63/0x200
>> Metadata corruption detected at xfs_inode block 0x63/0x200
>> Metadata corruption detected at xfs_inode block 0x63/0x200
>>
>> Use the special set_cur_inode() function for this purpose
>> as is done in inode_f().
> 
> Do you need a similar thing for dquots?  I sort of worry that we're
> going down the rabbit hole of special casing all over xfs_db, but...
> I'll defer to you. :)

I thought we did, but a quick test worked...

the dquot verifier only verifies one (indeed printing the dquot
only shows the first one in the block) so for now, I think not.

I did find it interesting/curious that i.e. "agi_f" hard-codes
the size and doesn't use the type's size function, but for
now I'm just ignoring that...

>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/db/io.c b/db/io.c
>> index b97b710..655a978 100644
>> --- a/db/io.c
>> +++ b/db/io.c
>> @@ -618,6 +618,18 @@ set_iocur_type(
>>  	struct xfs_buf	*bp = iocur_top->bp;
>>  	int bb_count;
>>  
>> +	/* Inodes are special; verifier checks all inodes in the buffer */
>> +	if (t->typnm == TYP_INODE) {
>> +		xfs_daddr_t	b = iocur_top->bb;
>> +		xfs_ino_t	ino;
>> +
>> +		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
>> +			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
>> +			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));
> 
> XFS_OFFBNO_TO_AGINO(mp, xfs_daddr_to_agbno(mp, b), 0) instead of that
> long third argument?

Macros, macros everywhere.  Ok, sounds good.

-Eric

> --D
> 
>> +		set_cur_inode(ino);
>> +		return;
>> +	}
>> +
>>  	/* adjust cursor for types that contain fields */
>>  	if (t->fields) {
>>  		bb_count = BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

