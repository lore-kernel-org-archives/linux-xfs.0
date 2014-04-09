Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 66B7F8001
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 16:35:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 309EA304062
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 14:35:36 -0700 (PDT)
Message-ID: <5345BD25.4060203@redhat.com>
Date: Wed, 09 Apr 2014 16:35:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remove pointless pointer increment in
	xfs_dir2_block_compact()
References: <5345ADF9.2030402@redhat.com> <5345BCE1.7070900@sgi.com>
In-Reply-To: <5345BCE1.7070900@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/9/14, 4:34 PM, Mark Tinguely wrote:
> On 04/09/14 15:30, Eric Sandeen wrote:
>> xfs_dir2_block_compact() is passed a pointer to *blp, and
>> advances it locally - but nobody uses the pointer (locally)
>> after that.
>>
>> This behavior came about as part of prior refactoring,
>>
>> 20f7e9f xfs: factor dir2 block read operations
>>
>> and looking at the code as it was before, it seems quite clear
>> that this change introduced a bug; the pre-refactoring code
>> expects blp to be modified after compaction.
>> And indeed it did; see this commit which fixed it:
>>
>> 37f1356 xfs: recalculate leaf entry pointer after compacting a dir2 block
>>
>> So the bug was introduced & resolved in the 3.8 cycle.
>>
>> Whoops.  Well, it's fixed now, and mystery solved; just remove
>> the now-pointless local increment of the blp pointer.
>>
>> (I guess we should have run clang earlier!)
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
> 
> Harmless, but yes it should be removed.

Harmless now that we fixed it the hard way back in January...  ;)

thanks for the reviews,
-Eric

> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
