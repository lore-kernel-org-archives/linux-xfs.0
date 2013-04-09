Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4B7E7F6C
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 01:17:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1F90304039
	for <xfs@oss.sgi.com>; Mon,  8 Apr 2013 23:17:14 -0700 (PDT)
Received: from mail-pd0-f169.google.com (mail-pd0-f169.google.com
	[209.85.192.169]) by cuda.sgi.com with ESMTP id
	bBtwk0AHHswJCEXQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Apr 2013 23:17:10 -0700 (PDT)
Received: by mail-pd0-f169.google.com with SMTP id 10so3679170pdc.28
	for <xfs@oss.sgi.com>; Mon, 08 Apr 2013 23:17:10 -0700 (PDT)
Message-ID: <5163B257.4080809@gmail.com>
Date: Tue, 09 Apr 2013 14:16:55 +0800
From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests generic 310: fix common file path and other
	cleanups
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
To: rjohnston@sgi.com
Cc: eguan@redhat.com, xfs@oss.sgi.com

On 2013/4/8 22:05, Rich Johnston wrote:
> Hi Eryu,
>
> Thanks for this cleanup patch. I was going to revert patch "bbaf78c0" which introduced test generic/310 but will wait and see if Zhao will provide more information which could be added to this patch.
>
>
> On 04/07/2013 05:39 AM, Eryu Guan wrote:
>> 1. add one space between # and test description
>
> The rest of the changes look good, sorry I missed them when I reviewed .
>
>> 2. remove creator/owner info
>> 3. fix common/rc and common/filter path so they can be sourced correctly
>> 4. no need to remove $seq.full cause it's not used(or if verbose output
>>     is needed, $seqres.full should be used)
>>
>> Signed-off-by: Eryu Guan <eguan@redhat.com>
>> ---
>>   tests/generic/310 | 12 +++++-------
>>   1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/tests/generic/310 b/tests/generic/310
>> index ef51422..35baa23 100644
>> --- a/tests/generic/310
>> +++ b/tests/generic/310
>> @@ -1,8 +1,8 @@
>>   #! /bin/bash
>>   # FS QA Test No. 310
>>   #
>> -#Check if there are two threads,one keeps calling read() or lseek(), and
>> -#the other calling readdir(), both on the same directory fd.
>> +# Check if there are two threads,one keeps calling read() or lseek(), and
>> +# the other calling readdir(), both on the same directory fd.
>>   #
>
> Hi Zhao,
>
> I did see both threads running at the same time, but the more I look at this, the more I am a loss as to what this test is doing.
>
> Will you expand this a little please.  I should have asked for more justification the first time I reviewed this. Please provide what bug
> this is testing or what failure/weakness this test exposes.  If there is a commit this is related to, please reference it.
>
When I ran it on ext2, ext3 and ext4 which has dir_index feature disabled, I got something like this:

EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is \
smaller than minimal - offset=993, inode=0, rec_len=0, name_len=0 EXT3-fs error \
(device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than \
minimal - offset=1009, inode=0, rec_len=0, name_len=0 EXT3-fs error (device loop1): \
ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - \
offset=993, inode=0, rec_len=0, name_len=0 EXT3-fs error (device loop1): \
ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - \
                offset=1009, inode=0, rec_len=0, name_len=0
...

If we configured errors=remount-ro, the filesystem will become read-only.

And you can find more infomation in http://marc.info/?t=136123715300001&r=1&w=2 as i mentioned.
If this message is needed i'll add it in the patch v2.

Thanks
--Zhao Hongjiang

> Thanks
> --Rich
>
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
