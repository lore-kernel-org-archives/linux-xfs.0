Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 22:17:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O5HFrv005572
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 22:17:18 -0700
Message-ID: <4860847B.7070703@sgi.com>
Date: Tue, 24 Jun 2008 15:22:03 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] set minleft in xfs_bmbt_split()
References: <48605744.8070400@sgi.com> <20080624045841.GN16257@build-svl-1.agami.com>
In-Reply-To: <20080624045841.GN16257@build-svl-1.agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Jun 24, 2008 at 12:09:08PM +1000, Lachlan McIlroy wrote:
>> The bmap btree split code relies on a previous data extent allocation
>> (from xfs_bmap_btalloc()) to find an AG that has sufficient space
>> to perform a full btree split, when inserting the extent.  When
>> converting unwritten extents we don't allocate a data extent so a
>> btree split will be the first allocation.  In this case we need to
>> set minleft so the allocator will pick an AG that has space to
>> complete the split(s).
> 
> looks good, execpt...
> 
>> Lachlan
>>
>> --- 2.6.x-agno2.orig/fs/xfs/xfs_bmap_btree.c
>> +++ 2.6.x-agno2/fs/xfs/xfs_bmap_btree.c
>> @@ -1493,12 +1493,20 @@ xfs_bmbt_split(
>> 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
>> 	args.fsbno = cur->bc_private.b.firstblock;
>> 	args.firstblock = args.fsbno;
>> +	args.minleft = 0;
>> 	if (args.fsbno == NULLFSBLOCK) {
>> 		args.fsbno = lbno;
>> 		args.type = XFS_ALLOCTYPE_START_BNO;
>> +		/*
>> +		 * Make sure there is sufficient room left in the AG to
>> +		 * complete a full tree split for an extent insert.  If
>> +		 * we are converting the middle part of an extent then
>> +		 * we may need space for two tree splits.
>> +		 */
>> +		args.minleft = xfs_trans_get_block_res(args.tp);
> 
> I'd mention in this comment that transaction reservation needs to
> take this specifically into account.
How would transaction reservation take this into account?  Are you
implying they could do something different if they knew about this
fix?

> It is probably also worth
> adding a matching comment to xfs_iomap_write_unwritten() where
> the double reservation is done (i.e. explain the magic "<< 1").
> 
Will do.
