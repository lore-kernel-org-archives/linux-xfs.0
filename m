Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 00:05:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O75KIq024155
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 00:05:21 -0700
Message-ID: <48609DD0.80604@sgi.com>
Date: Tue, 24 Jun 2008 17:10:08 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] set minleft in xfs_bmbt_split()
References: <48605744.8070400@sgi.com> <20080624045841.GN16257@build-svl-1.agami.com> <4860847B.7070703@sgi.com> <20080624052556.GR16257@build-svl-1.agami.com> <48609152.7050208@sgi.com> <20080624062551.GU16257@build-svl-1.agami.com>
In-Reply-To: <20080624062551.GU16257@build-svl-1.agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Tue, Jun 24, 2008 at 04:16:50PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Tue, Jun 24, 2008 at 03:22:03PM +1000, Lachlan McIlroy wrote:
>>>> Dave Chinner wrote:
>>>>> On Tue, Jun 24, 2008 at 12:09:08PM +1000, Lachlan McIlroy wrote:
>>>>>> The bmap btree split code relies on a previous data extent allocation
>>>>>> (from xfs_bmap_btalloc()) to find an AG that has sufficient space
>>>>>> to perform a full btree split, when inserting the extent.  When
>>>>>> converting unwritten extents we don't allocate a data extent so a
>>>>>> btree split will be the first allocation.  In this case we need to
>>>>>> set minleft so the allocator will pick an AG that has space to
>>>>>> complete the split(s).
>>>>> looks good, execpt...
>>>>>
>>>>>> Lachlan
>>>>>>
>>>>>> --- 2.6.x-agno2.orig/fs/xfs/xfs_bmap_btree.c
>>>>>> +++ 2.6.x-agno2/fs/xfs/xfs_bmap_btree.c
>>>>>> @@ -1493,12 +1493,20 @@ xfs_bmbt_split(
>>>>>> 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
>>>>>> 	args.fsbno = cur->bc_private.b.firstblock;
>>>>>> 	args.firstblock = args.fsbno;
>>>>>> +	args.minleft = 0;
>>>>>> 	if (args.fsbno == NULLFSBLOCK) {
>>>>>> 		args.fsbno = lbno;
>>>>>> 		args.type = XFS_ALLOCTYPE_START_BNO;
>>>>>> +		/*
>>>>>> +		 * Make sure there is sufficient room left in the AG to
>>>>>> +		 * complete a full tree split for an extent insert.  If
>>>>>> +		 * we are converting the middle part of an extent then
>>>>>> +		 * we may need space for two tree splits.
>>>>>> +		 */
>>>>>> +		args.minleft = xfs_trans_get_block_res(args.tp);
>>>>> I'd mention in this comment that transaction reservation needs to
>>>>> take this specifically into account.
>>>> How would transaction reservation take this into account?  Are you
>>>> implying they could do something different if they knew about this
>>>> fix?
>>> No, I'm implying that the transaction reservation better be correct.
>>> i.e. anywhere that unwritten extent conversion can take place needs
>>> to supply a reservation of enough blocks to allow a double split to
>>> occur.  i.e. we are relying on the caller to get this right, so we
>>> need to ensure that a comment explaining the potential landmine is
>>> present....
>> Okay.  With the change above we can still have xfs_bmbt_split() fail
>> to allocate btree blocks if it cannot find a single AG with enough
>> free space.  Although in my testing I haven't seen it fail yet.
> 
> Sure, but at that point you've most likely got a real ENOSPC condition.
> 
>> We really don't want to fail here because we have already partly
>> modified the extent btree (ie for the case where we convert the middle
>> part of an unwritten extent we do an xfs_bmbt_update before the insert)
>> and we dont undo the damage. 
> 
> Yes, but lets deal with one problem at a time ;)
> 
>> Also a failure to allocate in
>> xfs_bmbt_split() will be caught by the XFS_WANT_CORRUPTED_GOTO() in
>> xfs_bmbt_insert() and the error set to EFSCORRUPTED which is only going
>> to create confusion. 
> 
> For whom? Log an error message when allocation fails if you're
> worried that we won't be able to determine what went wrong...
> 
>> I have another patch that allows xfs_bmbt_split()
>> and xfs_bmbt_newroot() to fall back to the lowspace algorithm - I'm
>> just testing it now.
> 
> Cool - that should solve the corner cases you mention above...

This is the fallback code.  Do you think I also need to make the same
minleft change above and this change below to xfs_bmbt_newroot()?

I'm inclined to change both xfs_bmbt_split() and xfs_bmbt_newroot()
and keep them as similar as possible.  For the newroot case we know we
only need one block and we know there will be no more allocations for
this insert so using 'minleft = xfs_trans_get_block_res()' is silly but
on the other hand we don't have any other way to detect the double
insert case.

--- 2.6.x-agno2.orig/fs/xfs/xfs_bmap_btree.c
+++ 2.6.x-agno2/fs/xfs/xfs_bmap_btree.c
@@ -1525,6 +1525,21 @@ xfs_bmbt_split(
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 		return error;
 	}
+	if (args.fsbno == NULLFSBLOCK && args.minleft) {
+		/*
+		 * Could not find an AG will enough free space to satisfy
+		 * a full btree split.  Try again without minleft and if
+		 * successful activate the lowspace algorithm.
+		 */
+		args.fsbno = 0;
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.minleft = 0;
+		if ((error = xfs_alloc_vextent(&args))) {
+			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
+			return error;
+		}
+		cur->bc_private.b.flist->xbf_low = 1;
+	}
 	if (args.fsbno == NULLFSBLOCK) {
 		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 		*stat = 0;
