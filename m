Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727244AbfDONqH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Apr 2019 09:46:07 -0400
Reply-To: sandeen@redhat.com
Subject: Re: [PATCH] nvme/012 & 013: avoid extremely slow xfs IO
References: <20190415012229.20689-1-ming.lei@redhat.com>
 <SN6PR04MB4527DD7C84A15184AE5F7947862B0@SN6PR04MB4527.namprd04.prod.outlook.com>
From: Eric Sandeen <esandeen@redhat.com>
Message-ID: <57a5b163-5d7a-d5a0-fe9a-614b1d638472@redhat.com>
Date: Mon, 15 Apr 2019 09:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB4527DD7C84A15184AE5F7947862B0@SN6PR04MB4527.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On 4/14/19 9:01 PM, Chaitanya Kulkarni wrote:
> Thanks for the patch Ming. Couple of comments below.
> On 4/14/19 6:22 PM, Ming Lei wrote:
>> It is observed that nvme/012 may take ~17 minutes to complete on aarch64,
>> even worse it may trigger IO timeout on nvme-loop.
>>
>> Eric and Dave replied that it is because of too small log size on small
>> disk.
>>
>> So pass '-l size=32m' to avoid the issue.
>>
>> With this patch, nvme/012 can be completed in one minute.
>>
> Then we should set the QUICK=1 if its taking shorter time.
> 
>> Cc: Eric Sandeen <esandeen@redhat.com>
>> Cc: Dave Chinner <dchinner@redhat.com>
>> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
>> Cc: linux-xfs@vger.kernel.org
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>>   tests/nvme/012 | 2 +-
>>   tests/nvme/013 | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tests/nvme/012 b/tests/nvme/012
>> index 9a6801511df7..d7a8751ec752 100755
>> --- a/tests/nvme/012
>> +++ b/tests/nvme/012
>> @@ -46,7 +46,7 @@ test() {
>>   
>>   	umount ${mount_dir} > /dev/null 2>&1
>>   
>> -	mkfs.xfs -f /dev/"${nvmedev}n1" > /dev/null 2>&1
>> +	mkfs.xfs -l size=32m -f /dev/"${nvmedev}n1" > /dev/null 2>&1
>>   
> As a part of this series lets move this to the helper mkfs in the 
> nvme/rc and use that call in all the file-backed ns related testcases.
> Let me know if you want me to do that or you would like to do that as a 
> part of this series. I'm okay with anything.

We also discussed making the log size larger by default, on small fielsystems,
but that won't help you yet.

My only caution is that manually setting the log to 32m may actually create
a smaller than default log if your backing file happens to be very large.
Just something to consider.  If the backing files are typically around the
4G size of this test (?) then 32m seems reasonable, 128m certainly would
not hurt.

-Eric

>>   	mount /dev/"${nvmedev}n1" "${mount_dir}"
>>   
>> diff --git a/tests/nvme/013 b/tests/nvme/013
>> index e346cd4baa35..bc435f752dca 100755
>> --- a/tests/nvme/013
>> +++ b/tests/nvme/013
>> @@ -44,7 +44,7 @@ test() {
>>   
>>   	umount ${mount_dir} > /dev/null 2>&1
>>   
>> -	mkfs.xfs -f /dev/"${nvmedev}n1" > /dev/null 2>&1
>> +	mkfs.xfs -l size=32m  -f /dev/"${nvmedev}n1" > /dev/null 2>&1
>>   
> Extra space here but can be ignored once we move mkfs to the helper call.
>>   	mount /dev/"${nvmedev}n1" "${mount_dir}"
>>   
>>
> 
