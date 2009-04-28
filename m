Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3SEYEcx107342 for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 09:34:14 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0A9D304062
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 07:34:11 -0700 (PDT)
Message-Id: <EC361877-B682-438D-B99F-C841AD7A9428@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <1358225924.234061240896782828.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs_file_last_byte() needs to acquire ilock
Date: Tue, 28 Apr 2009 09:34:11 -0500
References: <1358225924.234061240896782828.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


On Apr 28, 2009, at 12:33 AM, Lachlan McIlroy wrote:

> ----- "Felix Blyakher" <felixb@sgi.com> wrote:
>
>> On Apr 27, 2009, at 11:11 PM, Lachlan McIlroy wrote:
>>
>>> ----- "Felix Blyakher" <felixb@sgi.com> wrote:
>>>
>>>> On Apr 23, 2009, at 10:46 PM, Lachlan McIlroy wrote:
>>>>
>>>>>
>>>>> ----- "Eric Sandeen" <sandeen@sandeen.net> wrote:
>>>>>
>>>>>> Lachlan McIlroy wrote:
>>>>>>> We had some systems crash with this stack:
>>>>>>>
>>>>>>> [<a00000010000cb20>] ia64_leave_kernel+0x0/0x280
>>>>>>> [<a00000021291ca00>] xfs_bmbt_get_startoff+0x0/0x20 [xfs]
>>>>>>> [<a0000002129080b0>] xfs_bmap_last_offset+0x210/0x280 [xfs]
>>>>>>> [<a00000021295b010>] xfs_file_last_byte+0x70/0x1a0 [xfs]
>>>>>>> [<a00000021295b200>] xfs_itruncate_start+0xc0/0x1a0 [xfs]
>>>>>>> [<a0000002129935f0>] xfs_inactive_free_eofblocks+0x290/0x460
>>>> [xfs]
>>>>>>> [<a000000212998fb0>] xfs_release+0x1b0/0x240 [xfs]
>>>>>>> [<a0000002129ad930>] xfs_file_release+0x70/0xa0 [xfs]
>>>>>>> [<a000000100162ea0>] __fput+0x1a0/0x420
>>>>>>> [<a000000100163160>] fput+0x40/0x60
>>>>>>>
>>>>>>> The problem here is that xfs_file_last_byte() does not acquire
>>>> the
>>>>>>> inode lock and can therefore race with another thread that is
>>>>>> modifying
>>>>>>> the extext list.  While xfs_bmap_last_offset() is trying to
>>>> lookup
>>>>>>> what was the last extent some extents were merged and the
>> extent
>>>>>> list
>>>>>>> shrunk so the index we lookup is now beyond the end of the
>> extent
>>>>>> list
>>>>>>> and potentially in a freed buffer.
>>>>>>>
>>>>>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>>>>>> index e7ae08d..cf62d9d 100644
>>>>>>> --- a/fs/xfs/xfs_inode.c
>>>>>>> +++ b/fs/xfs/xfs_inode.c
>>>>>>> @@ -1258,8 +1258,10 @@ xfs_file_last_byte(
>>>>>>
>>>>>>      /*
>>>>>>       * Only check for blocks beyond the EOF if the extents
>> have
>>>>>>       * been read in.  This eliminates the need for the inode
>>>>>> lock,
>>>>>>       * and it also saves us from looking when it really isn't
>>>>>>> 	 * necessary.
>>>>>>> 	 */
>>>>>>
>>>>>> I suppose that comment should be modified too, and maybe the
>>>> commit
>>>>>> log
>>>>>> should say why, exactly, it was wrong? :)
>>>>> Ha, I didn't even read the comment!  It's still kind of correct
>> in
>>>>> that we wont have to get the inode lock if the extents have not
>>>> been
>>>>>
>>>>> read in.
>>>>
>>>> I'd still think the comments could be made less confusing
>>>> if we're adding the inode lock here.
>>> The more I read the comment the more it makes sense and it seems to
>>> make more sense now with the change because it is clear how we can
>>> avoid the inode lock if the extents are not read in.
>>
>> OK, now after your explanation and reading the comments the Nth time,
>> I think, I know what you mean.
>>
>> I think, the original comment intention was the following:
>>
>>         if (ip->i_df.if_flags & XFS_IFEXTENTS) {
>> 		// extents have been read in. This (the fact that the extents
>> 		// have been read in) eliminates the need for the inode lock, as
>> 		// we are not going to read them in through xfs_iread_extents().
>>                 error = xfs_bmap_last_offset(NULL, ip, &last_block,
>>                         XFS_DATA_FORK);
>>                 if (error) {
>>                         last_block = 0;
>>                 }
>>         } else {
>>                 last_block = 0;
>>         }
>>
>> while in the patched version it'll become:
>>
>>         if (ip->i_df.if_flags & XFS_IFEXTENTS) {
>> 		// extents have been read in ...
>> 		xfs_ilock(ip, XFS_ILOCK_SHARED);
>>                 error = xfs_bmap_last_offset(NULL, ip, &last_block,
>>                         XFS_DATA_FORK);
>> 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>>                 if (error) {
>>                         last_block = 0;
>>                 }
>>         } else {
>> 		// this (the fact that the extents have _NOT_ been read in)
>> 		// eliminates the need for the inode lock.
>> 		// Doh, obvious.
>>                 last_block = 0;
>>         }
>>
>> Is that how you see the comment now?
> Yes.  And I think that was the intention of the comment all along.
>
>>
>> Was the assumption in the original comment about not needing the
>> ilock
>> simply incorrect?
> I don't think so.  I think the more likely scenario is that someone
> erroneously removed the locking or it was never there to begin with.
> The locking is not there in version 1.1 in git so you'll have to look
> at ptools or the IRIX source to get the full history.

Code archeology showed that the check for the extents read in
and the comment was added in 1995(!), and hadn't been touched
since.

revision 1.140
date: 1995/04/13 03:15:14;  author: ajs;  state: Exp;  lines: +285 -94
First cut at disk error handling

732c782,798
<       last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)ip->i_d.di_size);
---
 >       /*
 >        * Only check for blocks beyond the EOF if the extents have
 >        * been read in.  This eliminates the need for the inode lock,
 >        * and it also saves us from looking when it really isn't
 >        * necessary.
 >        */
 >       if (ip->i_flags & XFS_IEXTENTS) {
 >               error = xfs_bmap_last_offset(NULL, ip, &last_block);
 >               if (error) {
 >                       last_block = 0;
 >               }
 >       } else {
 >               last_block = 0;
 >       }
 >       size_last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)ip- 
 >i_d.di_size);
 >       last_block = XFS_FILEOFF_MAX(last_block, size_last_block);

It was slightly modified later to account to changes in  
xfs_bmap_last_offset
prototype:

revision 1.148
date: 1995/05/09 21:21:41;  author: doucette;  state: Exp;  lines:  
+435 -306
Add support for in-core and on-disk inodes with both data and
attribute forks, or just a data fork.  Change all the data structures
and macros used to manipulate the variable portion of the inode, to
support this feature.

806,807c900,902
<       if (ip->i_flags & XFS_IEXTENTS) {
<               error = xfs_bmap_last_offset(NULL, ip, &last_block);
---
 >       if (ip->i_df.if_flags & XFS_IFEXTENTS) {
 >               error = xfs_bmap_last_offset(NULL, ip, &last_block,
 >                       XFS_DATA_FORK);


So, there is no indication that the lock was accidentally missed.

Anyway, I'm not confused with the comment any more (didn't change my
opinion, though, on how it's perceived for the first time reader), and
if nobody else objects (Eric, you brought it up first), I'll check it
in as is.

Felix

>
>
>>
>>> How would you prefer the comment reads?
>>
>> I'd just leave the first sentence from the original comment.
>>
>>          * Only check for blocks beyond the EOF if the extents have
>>          * been read in.
>>
>> The mentioning about the ilock is too confusing now, imho.
>>
>> Felix
>>
>>>
>>>
>>>>
>>>> Felix
>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> -Eric
>>>>>>
>>>>>>> 	if (ip->i_df.if_flags & XFS_IFEXTENTS) {
>>>>>>> +		xfs_ilock(ip, XFS_ILOCK_SHARED);
>>>>>>> 		error = xfs_bmap_last_offset(NULL, ip, &last_block,
>>>>>>> 			XFS_DATA_FORK);
>>>>>>> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>>>>>>> 		if (error) {
>>>>>>> 			last_block = 0;
>>>>>>> 		}
>>>>>>>
>>>>>>> _______________________________________________
>>>>>>> xfs mailing list
>>>>>>> xfs@oss.sgi.com
>>>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>>>>
>>>>>>
>>>>>> _______________________________________________
>>>>>> xfs mailing list
>>>>>> xfs@oss.sgi.com
>>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>>
>>>>> _______________________________________________
>>>>> xfs mailing list
>>>>> xfs@oss.sgi.com
>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
