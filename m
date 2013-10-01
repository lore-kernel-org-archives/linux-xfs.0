Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38CC77F7C
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 16:39:45 -0500 (CDT)
Message-ID: <524B4119.8020005@sgi.com>
Date: Tue, 1 Oct 2013 16:39:37 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix multi stream support
References: <524AF8AE.5030300@sgi.com> <524B34D4.10807@sandeen.net>
In-Reply-To: <524B34D4.10807@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>



On 10/01/2013 03:47 PM, Eric Sandeen wrote:
> Hi Rich -
>
> On 10/1/13 11:30 AM, Rich Johnston wrote:
>> If no extents exist, there is no need to call partial_reg() becausee entire file
>> there is no data to split up.
> thought based on the code alone it was self explainitory
> Does that break something, or is this an optimization?

The original code is broken, would not detect if th. If partialmax != 0 
(multi-stream) and no extents exist (entire file is a hole), is there 
anything to restore? Nope so why call parial_reg().  If you do call it 
you will not find anything to restore:


8977         /* If not found, find a free one, fill it in and return */
8978         if ( ! isptr ) {
8979                 mlog(MLOG_NITTY | MLOG_NOLOCK,
8980                         "partial_reg: no entry found for %llu\n", ino);
8981                 /* find a free one */
8982                 for (i=0; i < partialmax; i++ ) {
8983                         if (persp->a.parrest[i].is_ino == 0) {
8984                                 int j;
8985
8986                                 isptr = &persp->a.parrest[i];
8987                                 isptr->is_ino = ino;
8988                                 persp->a.parrestcnt++;
8989
8990                                 /* Clear all endoffsets (this value is
8991                                  * used to decide if an entry is 
used or
8992                                  * not
8993                                  */
8994                                 for (j=0, bsptr=isptr->is_bs;
8995                                      j < drivecnt; j++, bsptr++) {
8996                                      bsptr->endoffset = 0;
8997                                 }
8998
8999                                 goto found;
9000                         }
9001                 }
9002
9003                 /* Should never get here. */

And we reach the dreaded comment above :)

>> Also remove the uneeded check in partial_reg() to detect if this is a multistream restore.
>
> Why is it unneeded?
The check is unneeded because with my fix,  partial_reg will never be 
called if partialmax==0. Do we really need the extra check?

>
>  From a quick read, if partialmax == 0 that measn only 1 drive,
> and no streams - so it does seem like partial_reg() would have
> no work to do, so I'm a  little confused (but I'm also a total
> n00b here).e
>
> This patch says it fixes multi stream support - what was broken?
> Is there a testcase (or should there be) that shows the problem?
>
> I see changes but I don't know enough about xfsdump to know
> what's broken & what's being fixed, can you explain a bit more?

Sorry I thought that it was self explanatory ;)
>
> Thanks,
> -Eric
>
>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>>
>> diff --git a/restore/content.c b/restore/content.c
>> index 54d933c..ecbcf13 100644
>> --- a/restore/content.c
>> +++ b/restore/content.c
>> @@ -7494,6 +7494,7 @@ restore_extent_group( drive_t *drivep,
>>       extenthdr_t ehdr;
>>       off64_t bytesread;
>>       rv_t rv;
>> +    uint num_extents = 0; /* number of extents */
>>
>>       /* copy data extents from media to the file
>>        */
>> @@ -7518,6 +7519,7 @@ restore_extent_group( drive_t *drivep,
>>           if ( ehdr.eh_type == EXTENTHDR_TYPE_LAST ) {
>>               break;
>>           }
>> +        num_extents++;
>>
>>           /* if its an ALIGNment extent, discard the extent.
>>            */
>> @@ -7572,7 +7574,7 @@ restore_extent_group( drive_t *drivep,
>>        * and certain extended inode flags. Register the portion
>>        * of the file completed here in the persistent state.
>>        */
>> -    if (bstatp->bs_size > restoredsz) {
>> +    if (num_extents && (bstatp->bs_size > restoredsz)) {
>>           partial_reg(drivep->d_index,
>>                   bstatp->bs_ino,
>>                   bstatp->bs_size,
>> @@ -8959,9 +8961,6 @@ partial_reg( ix_t d_index,
>>
>>       endoffset = offset + sz;
>>
>> -    if ( partialmax == 0 )
>> -        return;
>> -
>>       pi_lock();
>>
>>       /* Search for a matching inode.  Gaps can exist so we must search
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
