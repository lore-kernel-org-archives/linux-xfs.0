Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B77217F4E
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 16:48:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4280304043
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 14:48:07 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 39MHRs0RFGwBLuWc
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 14:48:06 -0700 (PDT)
Message-ID: <52435A1B.8040207@hardwarefreak.com>
Date: Wed, 25 Sep 2013 16:48:11 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs hardware RAID alignment over linear lvm
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
In-Reply-To: <2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
Reply-To: stan@hardwarefreak.com
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
To: Chris Murphy <lists@colorremedies.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/25/2013 4:34 PM, Chris Murphy wrote:
> 
> On Sep 25, 2013, at 3:18 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> On 9/25/2013 7:56 AM, Stewart Webb wrote:
>>> Hi All,
>>
>> Hi Stewart,
>>
>>> I am trying to do the following:
>>> 3 x Hardware RAID Cards each with a raid 6 volume of 12 disks presented to
>>> the OS
>>> all raid units have a "stripe size" of 512 KB
>>
>> Just for future reference so you're using correct terminology, a value
>> of 512KB is surely your XFS su value, also called a "strip" in LSI
>> terminology, or a "chunk" in Linux software md/RAID terminology.  This
>> is the amount of data written to each data spindle (excluding parity) in
>> the array.
>>
>> "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is the
>> amount of data written across the full RAID stripe (excluding parity).
>>
>>> so given the info on the xfs.org wiki - I sould give each filesystem a
>>> sunit of 512 KB and a swidth of 10 (because RAID 6 has 2 parity disks)
>>
>> Partially correct.  If you format each /dev/[device] presented by the
>> RAID controller with an XFS filesystem, 3 filesystems total, then your
>> values above are correct.  EXCEPT you must use the su/sw parameters in
>> mkfs.xfs if using BYTE values.  See mkfs.xfs(8)

Small correction:  su is a byte value.  sw is an integer representing
the number of data spindles.

>>> all well and good
>>>
>>> But - I would like to use Linear LVM to bring all 3 cards into 1 logical
>>> volume -
>>> here is where my question crops up:
>>> Does this effect how I need to align the filesystem?
>>
>> In the case of a concatenation, which is what LVM linear is, you should
>> use an XFS alignment identical to that for a single array as above.
> 
> So keeping the example, 3 arrays x 10 data disks, would this be su=512k and sw=30?

No.  In this configuration, as far as XFS is concerned LVM doesn't exist
in the stack because it doesn't change the RAID geometry, so you ignore it.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
