Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751340AbcLEUbe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Dec 2016 15:31:34 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B045481F03
        for <linux-xfs@vger.kernel.org>; Mon,  5 Dec 2016 20:31:33 +0000 (UTC)
Subject: Re: [PATCH] xfs: ignore leaf attr ichdr.count in verifier during log
 replay
References: <596737a3-fbf8-8712-422c-4705ce36deae@redhat.com>
 <20161201121538.GA22890@bfoster.bfoster>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <73c72838-1239-3dd5-1ed3-ec63f99625d0@redhat.com>
Date: Mon, 5 Dec 2016 14:31:32 -0600
MIME-Version: 1.0
In-Reply-To: <20161201121538.GA22890@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 12/1/16 6:15 AM, Brian Foster wrote:
> On Wed, Nov 30, 2016 at 04:33:15PM -0600, Eric Sandeen wrote:
>> When we create a new attribute, we first create a shortform
>> attribute, and try to fit the new attribute into it.
>> If that fails, we copy the (empty) attribute into a leaf attribute,
>> and do the copy again.  Thus there can be a transient state where
>> we have an empty leaf attribute.
>>
>> If we encounter this during log replay, the verifier will fail.
>> So add a test to ignore this part of the leaf attr verification
>> during log replay.
>>
>> Thanks as usual to dchinner for spotting the problem.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 8ea91f3..2852521 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -253,6 +253,7 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
>>  {
>>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>>  	struct xfs_attr_leafblock *leaf = bp->b_addr;
>> +	struct xfs_perag *pag = bp->b_pag;
>>  	struct xfs_attr3_icleaf_hdr ichdr;
>>  
>>  	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
>> @@ -273,7 +274,12 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
>>  		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
>>  			return false;
>>  	}
>> -	if (ichdr.count == 0)
>> +	/*
>> +	 * In recovery there is a transient state where count == 0 is valid
>> +	 * because we may have transitioned an empty shortform attr to a leaf
>> +	 * if the attr didn't fit in shortform.
>> +	 */
>> +	if (pag && pag->pagf_init && ichdr.count == 0)
>>  		return false;
> 
> Seems fine, but if the idea is to filter out failures during log
> recovery, can we detect that state explicitly? E.g., check for some
> combination of XLOG_ACTIVE_RECOVERY and/or XLOG_RECOVERY_NEEDED (or just
> define and use a new flag/helper if necessary)?

Yeah, this is done in several other places; see xfs_allocbt_verify, 
xfs_refcountbt_verify, xfs_rmapbt_verify and the comments in those.

Right now, XLOG_ACTIVE_RECOVERY is only used in the actual logging code.

I did consider that a helper w/ an explanation of why "pag && pag->pagf_init"
would be a good idea, though.

-Eric

> Brian
> 
>>  
>>  	/* XXX: need to range check rest of attr header values */
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

