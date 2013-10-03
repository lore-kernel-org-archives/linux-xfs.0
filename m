Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 944D229DFC
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 09:17:27 -0500 (CDT)
Message-ID: <524D7C7C.7060407@sgi.com>
Date: Thu, 3 Oct 2013 09:17:32 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: add locks around the inventory put
References: <524AF8C3.8020904@sgi.com> <524B395C.6030705@sandeen.net>
In-Reply-To: <524B395C.6030705@sandeen.net>
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

On 10/01/2013 04:06 PM, Eric Sandeen wrote:
> hi Rich -
>
> On 10/1/13 11:30 AM, Rich Johnston wrote:
>> From: Phil White <cerise-xfs@l.armory.com>
>>
>> Add locks around the inventory put to prevent inventory
>> corruption.
>>
>> Signed-off-by: Phil White <cerise-xfs@l.armory.com>
>
> Similar questions here; it says it's thread-safe, but apparently
> not.  But why not?  what happens?  Is there a testcase?

This was reported by a customer, no test case, so we used the customers 
data to verify the fix.  Failed every time the customer performed a 20 
stream dump/restore and with single stream. Single stream would fail 
rarley with a different error. Two storage object files were corrupted, 
causing xfsinvutil -C to crash. As it is customer data we could not 
supply it as a test case.

Customer runs fine now with this patch,

Bug info

   BUG Title: xfsinvutil seg faults when trying to use -C

   #0  0x00007fd83a98c9d2 in __strlen_sse2 () from /lib64/libc.so.6
   #1  0x00007fd83a95520d in vfprintf () from /lib64/libc.so.6
   #2  0x00007fd83a9f9a2d in __printf_chk () from /lib64/libc.so.6
   #3  0x0000000000402b54 in printf (__fmt=<optimized out>) at 
/usr/include/bits/stdio2.h:105
   #4  CheckAndPruneStObjFile (checkonly=1, StObjFileName=0x7fd83b2e8a00 
<Address 0x7fd83b2e8a00 out of bounds>,
     sessionp=0x7ffffc02a150, prunetime=0, r_mf_label=0x0) at invutil.c:759
   #5  0x000000000040329b in CheckAndPruneInvIndexFile (checkonly=1,
     idxFileName=0x60f040 
"/var/lib/xfsdump/inventory/aeb05cfe-c923-4972-ad18-2968326aba46.InvIndex", 
sessionp=0x7ffffc02a150,
     prunetime=0, r_mf_label=0x0) at invutil.c:651
   #6  0x00000000004039f6 in CheckAndPruneFstab (inv_path=0x60e6e0 
"/var/lib/xfsdump/inventory", checkonly=1,
     mountPt=0x40a9c4 "test", uuidp=0x7ffffc02a160, 
sessionp=0x7ffffc02a150, prunetime=0, r_mf_label=0x0) at invutil.c:538
   #7  0x00000000004043bf in main (argc=2, argv=0x7ffffc02a288) at 
invutil.c:253

   The corrupted files seem to have struct inv_mediafile or maybe struct
   inv_stream overwriting the header of the file, and both seem to 
include media
   files from multi stream dumps. 
83ab1189-b1a7-4733-bfd6-aa8a4feb188e.StObj has
   a good header that looks like it was written over a struct 
inv_stream...  I
   suspect we're looking at some kind of locking issue with multistream 
xfsdump
   adding stream entries to this file in the inventory.

>
> (you guys probably have longer history in ptools, maybe you
> can see what if anything changed since the original comment
> was added - or maybe when it was added, etc?)

Looks like it was added as the IRIX original commit
dump_content.c.p_cat:

cbullis   |1.1  |                            |			/* already thread-safe, 
don't need to lock
cbullis   |1.1  |                            |			 */


>
> Thanks,
> -Eric
>
>> diff --git a/dump/content.c b/dump/content.c
>> index ac19021..b8977bb 100644
>> --- a/dump/content.c
>> +++ b/dump/content.c
>> @@ -2550,8 +2550,11 @@ decision_more:
>>                          scwhdrp->cih_startpt.sp_offset );
>>               }
>>
>> -            /* already thread-safe, don't need to lock
>> +            /* Supposedly already thread-safe, according to the
>> +             * previous revisions, but corruption of inventory
>> +             * objects can occur.
>>                */
>>                */
>> +            lock();
>>               ok = inv_put_mediafile( inv_stmt,
>>                           &mwhdrp->mh_mediaid,
>>                           mwhdrp->mh_medialabel,
>> @@ -2565,6 +2568,7 @@ decision_more:
>>                           &&
>>                           ! empty_mediafile,
>>                           BOOL_FALSE );
>> +            unlock();
>>               if ( ! ok ) {
>>                   mlog( MLOG_NORMAL, _(
>>                         "inventory media file put failed\n") );
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
