Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51618 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751385AbdAaUhz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jan 2017 15:37:55 -0500
Subject: Re: [PATCH 3/7] xfs: filter out obviously bad btree pointers
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582220244.12293.9617058284483534384.stgit@birch.djwong.org>
 <eabf5bb2-124e-5af9-5dbb-380bc85d8b13@sandeen.net>
 <20170131200918.GH9134@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <07118d8d-9c78-923f-5dcd-eb5a28335b3f@sandeen.net>
Date: Tue, 31 Jan 2017 14:37:48 -0600
MIME-Version: 1.0
In-Reply-To: <20170131200918.GH9134@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/31/17 2:09 PM, Darrick J. Wong wrote:
>>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>>> index 21e6a6a..2849d3f 100644
>>> --- a/fs/xfs/libxfs/xfs_btree.c
>>> +++ b/fs/xfs/libxfs/xfs_btree.c
>>> @@ -810,7 +810,8 @@ xfs_btree_read_bufl(
>>>  	xfs_daddr_t		d;		/* real disk block address */
>>>  	int			error;
>>>  
>>> -	ASSERT(fsbno != NULLFSBLOCK);
>>> +	if (!XFS_FSB_SANITY_CHECK(mp, fsbno))
>>> +		return -EFSCORRUPTED;
>> This does away with the NULLFSBLOCK checks though, right?
>>
>> #define NULLFSBLOCK     ((xfs_fsblock_t)-1)
>>
>> which is also used as an in-memory condition, so I'm not sure
>> it should be added to XFS_FSB_SANITY_CHECK.
> [reiterating our irc conversation]
> 
> It shouldn't, since XFS_FSB_TO_AGNO(mp, NULLFSBLOCK) ought to produce
> NULLAGNUMBER, which will still fail the check.

Oh, sure.  sorry for missing that.

Looks ok after all.  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>> IOWs some asserts about it are really code flow asserts, though
>> it also shouldn't be read from disk.
> xfs_btree_read_bufl is called by xfs_bmap_check_leaf_extents, which is
> the verifier of the on-disk data.
> 
> --D
> 
