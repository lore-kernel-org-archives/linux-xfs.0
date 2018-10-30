Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53532 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbeJaEaT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 00:30:19 -0400
Subject: Re: [PATCH 1/7] Revert "xfs_repair: treat zero da btree pointers as
 corruption"
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-2-david@fromorbit.com> <20181030172039.GG4135@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3781527d-4691-1c74-8e18-43bae49f44ff@sandeen.net>
Date: Tue, 30 Oct 2018 14:35:29 -0500
MIME-Version: 1.0
In-Reply-To: <20181030172039.GG4135@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 10/30/18 12:20 PM, Darrick J. Wong wrote:
> On Tue, Oct 30, 2018 at 10:20:37PM +1100, Dave Chinner wrote:
>> This reverts commit 67a79e2cc9320aaf269cd00e9c8d16892931886d.
>>
>> A root LEAFN block can exist in a directory. When we convert from
>> leaf format (LEAF1 - internal free list) to node format (LEAFN -
>> external free list) the only change to the single root leaf block is
>> that it's magic number is changed from LEAF1 to LEAFN.
>>
>> We don't actually end up with DA nodes in the tree until the LEAFN
>> node is split, and that requires a couple more dirents to be added
>> to the directory to fill the LEAFN block up completely. Then it will
>> split and create a DA node root block pointing to multiple LEAFN
>> leaf blocks.
>>
>> Hence restore the old behaviour where we skip the DA node tree
>> rebuild if there is a LEAFN root block found as there is no tree to
>> rebuild.
> 
> The trouble with reverting the patch is that xfs_repair goes back to
> tripping over an assertion in release_da_cursor_int if the reason why
> we got bno == 0 is that the directory has a da btree block with
> nbtree[0].before pointing to zero.
> 
> Will post a better fix + regression tests for both issues shortly.

Well let's discuss pros/cons & risks/rewards on that, I'm semi-inclined
to just revert it for 4.19 and fix it properly in 4.20, because I don't think
it's ever been seen in the wild...?

-eric

> --D
> 
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>  repair/dir2.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/repair/dir2.c b/repair/dir2.c
>> index 3374ae722bf9..ba5763ed3d26 100644
>> --- a/repair/dir2.c
>> +++ b/repair/dir2.c
>> @@ -1242,11 +1242,11 @@ process_node_dir2(
>>  		return 1;
>>  
>>  	/*
>> -	 * Directories with a root marked XFS_DIR2_LEAFN_MAGIC are corrupt
>> +	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC
>>  	 */
>>  	if (bno == 0) {
>> -		err_release_da_cursor(mp, &da_cursor, 0);
>> -		return 1;
>> +		release_da_cursor(mp, &da_cursor, 0);
>> +		return 0;
>>  	} else {
>>  		/*
>>  		 * Now pass cursor and bno into leaf-block processing routine.
>> -- 
>> 2.19.1
>>
> 
