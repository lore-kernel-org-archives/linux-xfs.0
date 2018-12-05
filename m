Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40778 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbeLEELw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Dec 2018 23:11:52 -0500
Subject: Re: [PATCH v2 2/6] xfs_repair: don't error out on dirs with a single
 leafn block
From: Eric Sandeen <sandeen@sandeen.net>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181072709.3727.17020900125846885320.stgit@magnolia>
 <20181122181346.GW6792@magnolia>
 <f3770fe4-1f20-42a0-4d13-6c2e19329f54@sandeen.net>
Message-ID: <4580e90a-0040-6eb2-f499-7a45a6fe136c@sandeen.net>
Date: Tue, 4 Dec 2018 22:11:50 -0600
MIME-Version: 1.0
In-Reply-To: <f3770fe4-1f20-42a0-4d13-6c2e19329f54@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 12/4/18 9:48 PM, Eric Sandeen wrote:
> On 11/22/18 12:13 PM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> In process_node_dir2, we need to distinguish between a directory with a
>> single leafn block (yes, they exist) having no interior da nodes, and a
>> directory with a da tree that incorrectly points to dablk 0.  If we
>> happened to fill out any part of the da cursor then we have a da btree
>> with garbage in it; otherwise, we have a single leafn block.
>>
>> This was found by repair repeatedly rebuilding a directory containing a
>> single leafn block (xfs/495).
>>
>> Fixes: 67a79e2cc932 ("xfs_repair: treat zero da btree pointers as corruption")
>> Reported-by: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'm finding the commit log hard to parse/understand.
> 
> Let's reference
> 
> 71a6af8 Revert "xfs_repair: treat zero da btree pointers as corruption"
> 
> for starters, but can we do something like this....?
> 
> ===
> 
> As explained in
> 
> 71a6af8 Revert "xfs_repair: treat zero da btree pointers as corruption"
> 
> a single root LEAFN block can exist in a directory until it grows further.
> 
> This is why, normally, we skip directories with a root marked
> XFS_DIR2_LEAFN_MAGIC, as detected by the left-most leaf block being 
> found at file block 0.
> 
> However, if we traversed any level of a btree to get here (as
> indicated by da_cursor.active > 0), then a leaf block claiming block
> 0 indicates corruption, and we should handle it as such, and rebuild
> the directory.
> 
> This was found by repair repeatedly rebuilding a directory containing a
> single leafn block (xfs/495).
> 
> Fixes: 67a79e2cc932 ("xfs_repair: treat zero da btree pointers as corruption")
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ===
> 
> I'm not hung up on rewriting the commit log, but if you like it give me
> thumbs up.  I needed to think it through that way to grok the change.
> Anyway, for the change now that I do grok it,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Uh, the summary is wrong too,  o?  We /already/ "don't error out"
on dirs with a single leafn block.  Maybe:

xfs_repair: rebuild directory when non-root leafn blocks claim block 0

?
