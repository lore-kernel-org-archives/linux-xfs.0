Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Nov 2006 16:01:38 -0800 (PST)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAF01RaG010387
	for <xfs@oss.sgi.com>; Tue, 14 Nov 2006 16:01:29 -0800
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id kAF00fnx003424
	for <xfs@oss.sgi.com>; Tue, 14 Nov 2006 18:00:41 -0600
Message-ID: <455A589E.4040607@sgi.com>
Date: Wed, 15 Nov 2006 00:00:30 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: xfs_bmap_add_extent_delay_real: Uninited r[3] corrupts startoff
References: <4529F8A8.6080900@agami.com> <452C44A2.7000907@sgi.com>
In-Reply-To: <452C44A2.7000907@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: Shailendra Tripathi <stripathi@agami.com>, xfs mailing list <xfs@oss.sgi.com>, xfs-dev@sgi.com

This should be all that's needed.  This code handles the case where the middle
portion of a delayed allocation is being converted and splits the extent into
three.  The r[1] extent is the rightmost extent that will remain a delayed
allocation.  Both br_startblock and br_state need to be setup and they will be
the same as the original delayed allocation (PREV) so we just inherit those
values.  Comments?

--- fs/xfs/xfs_bmap.c_1.358     2006-11-01 14:44:38.000000000 +0000
+++ fs/xfs/xfs_bmap.c   2006-11-02 13:22:41.000000000 +0000
@@ -1171,6 +1171,7 @@
                 xfs_bmap_trace_pre_update(fname, "0", ip, idx, XFS_DATA_FORK);
                 xfs_bmbt_set_blockcount(ep, temp);
                 r[0] = *new;
+               r[1] = PREV;
                 r[1].br_startoff = new_endoff;
                 temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
                 r[1].br_blockcount = temp2;

Lachlan

Vlad Apostolov wrote:
> Hi Shailendra,
> 
> Shailendra Tripathi wrote:
> 
>> Hi,
>>     It appears that uninitialized r[3] in 
>> xfs_bmap_add_extent_delay_real can potentially corrupt the startoff 
>> for a particular case.
>>
>> This sequence is below:
>>
>>        xfs_bmap_add_extent_delay_real (
>>        ...
>>        xfs_bmbt_irec_t         r[3];   /* neighbor extent entries */
>>
>> case 0:
>>          /*
>>           * Filling in the middle part of a previous delayed allocation.
>>           * Contiguity is impossible here.
>>           * This case is avoided almost all the time.
>>           */
>> temp = new->br_startoff - PREV.br_startoff;
>> xfs_bmbt_set_blockcount(ep, temp);
>> r[0] = *new;
>> r[1].br_startoff = new_endoff;
>> temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
>> r[1].br_blockcount = temp2;
>> xfs_bmap_insert_exlist(ip, idx + 1, 2, &r[0], XFS_DATA_FORK);
>> ip->i_df.if_lastex = idx + 1;
>> ip->i_d.di_nextents++;
>>
>> Look at extent r[1]. It does not set br_startblock. That is, it is any 
>> random value. Now, look at the xfs_bmbt_set_all. Though, it sets the 
>> blockcount later, the startoff does not get changed.
>>
>> #if XFS_BIG_BLKNOS
>>         ASSERT((s->br_startblock & XFS_MASK64HI(12)) == 0);
>>         r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
>>                  ((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
>>                  ((xfs_bmbt_rec_base_t)s->br_startblock >> 43);
>> Top 21 bits are taken as it is. However, only 9 bit should be taken. 
>> So, for random values, it corrupts the startoff which from 9-63 bits.
> 
>  From the code inspection I agree with you that br_startblock doesn't 
> appear
> to be initialized in this scenario. Otherwise I think the code looks good.
> If the br_startblock is initialized  it should be a value that fits
> in 52 bits out of 64 (this is what the ASSERT is for) and the top 12 
> bits will be 0.
> The r->l0 gets the top 21 bits of br_startblock, the most significant 12 
> bits of
> which are 0 and least significant 9 could be non 0. The r->l1 gets the
> rest 43 (= 52-9 = 64-21) bits of br_startblock.
> 
> I will open a bug report for the uninitialized br_startblock.
> 
> Thank you for finding this problem.
> 
> Regards,
> Vlad
> 
>>
>>         r->l1 = ((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
>>                  ((xfs_bmbt_rec_base_t)s->br_blockcount &
>>                  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
>>
>> I have attached a small program which does the same thing as it is 
>> being done here. I would appreciate if someone can verify that 
>> assertion is correct.
>>
>>
>> Regards,
>> Shailendra
>> ------------------------------------------------------------------------
>>
>> #include <stdio.h>
>> typedef unsigned long __uint64_t;
>> typedef struct xfs_bmbt_rec_64
>> {
>>         __uint64_t              l0, l1;
>> } xfs_bmbt_rec_64_t;
>>
>> typedef __uint64_t      xfs_bmbt_rec_base_t;    typedef 
>> xfs_bmbt_rec_64_t xfs_bmbt_rec_t, xfs_bmdr_rec_t;
>>
>> typedef enum {
>>        XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
>>        XFS_EXT_DMAPI_OFFLINE
>> } xfs_exntst_t;
>>
>> typedef struct xfs_bmbt_irec
>> {
>>     __uint64_t   br_startoff;    /* starting file offset */
>>     __uint64_t   br_startblock;  /* starting block number */
>>     __uint64_t   br_blockcount;  /* number of blocks */
>>     xfs_exntst_t    br_state;       /* extent state */
>> } xfs_bmbt_irec_t;
>>
>> #define XFS_MASK64LO(n)         (((__uint64_t)1 << (n)) - 1)
>> #define XFS_MASK64HI(n)         ((__uint64_t)-1 << (64 - (n)))
>>
>> int main(void) {
>>     xfs_bmbt_irec_t s;
>>     xfs_bmbt_rec_t  r;
>>     int extent_flag;
>>
>>     s.br_startoff = 0;
>>     s.br_blockcount = 5;
>>     s.br_startblock = 0xfffffffffffffff0;
>>     extent_flag = (s.br_state == XFS_EXT_NORM) ? 0 : 1;
>>
>>     printf("blockcount = 0x%llx\n", s.br_startblock);
>>     r.l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
>>               ((xfs_bmbt_rec_base_t)s.br_startoff << 9) |
>>               ((xfs_bmbt_rec_base_t)s.br_startblock >> 43);
>>     r.l1 = ((xfs_bmbt_rec_base_t)s.br_startblock << 21) |
>>              ((xfs_bmbt_rec_base_t)s.br_blockcount &
>>              (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
>>
>>     printf("l0 = 0x%llx l1 = 0x%llx\n", r.l0, r.l1);
>>
>>     r.l0 = (r.l0 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(55)) |
>>             (xfs_bmbt_rec_base_t)((__uint64_t)100 >> 43);
>>     r.l1 = (r.l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)) |
>>             (xfs_bmbt_rec_base_t)((__uint64_t)100 << 21);
>>
>>     printf("l0 = 0x%llx l1 = 0x%llx\n", r.l0, r.l1);
>>     return 0;
>> }
>>   
> 
> 
> 
