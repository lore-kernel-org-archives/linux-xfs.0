Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52328 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbeLRTmv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 14:42:51 -0500
Subject: Re: [PATCH 2/2] xfs: clear XFS_ILOG_[AD]OWNER for non-btree formats
References: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
 <31aaeb46-8fb5-79f5-66bd-d594b9a6cc89@redhat.com>
 <20181218192804.GG27208@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6fc87cd3-7cef-89b4-42c0-43aa0f131ba5@sandeen.net>
Date: Tue, 18 Dec 2018 13:42:48 -0600
MIME-Version: 1.0
In-Reply-To: <20181218192804.GG27208@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 12/18/18 1:28 PM, Darrick J. Wong wrote:
> On Tue, Dec 18, 2018 at 01:09:40PM -0600, Eric Sandeen wrote:
>> If an inode had been in btree format and had a data fork owner change
>> logged, that flag must be cleared if the inode changes format to
>> non-btree.  Otherwise we hit the old ASSERT (now changed to
>> corruption detection) in xfs_recover_inode_owner_change() which
>> enforces that if XFS_ILOG_[AD]OWNER is set, XFS_ILOG_[AD]BROOT
>> must be as well.
>>
>> (Or, put more plainly, changing the fork owner is nonsensical
>> for inodes which have no such fork.)
> 
> ...and now I learn why not to review a series until all the patches show
> up. :(
> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
>> index fa1c4fe2ffbf..82a13b7ad321 100644
>> --- a/fs/xfs/xfs_inode_item.c
>> +++ b/fs/xfs/xfs_inode_item.c
>> @@ -144,7 +144,8 @@ xfs_inode_item_format_data_fork(
>>  	switch (ip->i_d.di_format) {
>>  	case XFS_DINODE_FMT_EXTENTS:
>>  		iip->ili_fields &=
>> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
>> +			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
>> +			  XFS_ILOG_DEV | XFS_ILOG_DOWNER);
> 
> So ... existing kernels could accidentally log an inode with an extents
> format data fork and (DOWNER | DBROOT).  If a kernel encounters such a
> log item, it would assert and kaboom, and now it'll fail the rest of log
> recovery, which forces the admin to zap the log.
> 
> However, if the data fork is in extents format there isn't any work
> required to change the owner anyway, so why do we have to abort the log
> recovery in that case?

Because I didn't think we were in the business of guessing which bits of
inconsistency indicate corruption and which bits are "probably ok"
during log recovery...

We have a mismatch between the logged fields and the format.  Your
suggestion seems to put a lot of faith in the format being correct,
and therefore deciding to ignore the inconsistency in the fields, no?

i.e. if we don't see FMT_BTREE, what justification do we have for
completely ignoring the flag inconsistency?  What if the format was
wrong? 

I don't really see how we can make that prioritization.  Maybe I'm
not thinking creatively enough and you can convince me.  :)

(Granted, the admin recovery path of "throw it all away" does suck,
but such is life.)

-Eric

> IOWs, why doesn't the previous patch do:
> 
> /*
>  * Some old kernels mistakenly log inode items with DOWNER set on a
>  * inode with a non-btree format data fork.  DBROOT won't be set in this
>  * non-btree case, but since the work that DOWNER does is only required
>  * for the btree case we can safely ignore this one weird combination.
>  */
> if ((ili_fields & DOWNER) && di_format == FMT_BTREE) {
> 	if (!(ili_fields & DBROOT))
> 		return -EFSCORRUPTED;
> 	error = xfs_bmbt_change_owner(...);
> }
> 
> --D
