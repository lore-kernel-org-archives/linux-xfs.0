Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C743C7F50
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 16:52:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F395AC003
	for <xfs@oss.sgi.com>; Tue, 19 May 2015 14:52:40 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Rq3MPuMStIppIhx8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 May 2015 14:52:38 -0700 (PDT)
Message-ID: <555BB09D.4080405@oracle.com>
Date: Tue, 19 May 2015 14:52:29 -0700
From: santosh shilimkar <santosh.shilimkar@oracle.com>
MIME-Version: 1.0
Subject: Re: [Regression] Guest fs corruption with 'block: loop: improve
	performance via blk-mq'
References: <5557A4EC.6000508@oracle.com>	<CACVXFVOd9gOte-9t1fgdHq_GYHUHQ8kkBXz2Dzz-J3a7bv50+A@mail.gmail.com>	<555A2A76.5050701@oracle.com>	<555A7237.1030004@oracle.com>
	<CACVXFVOxzAAdR8PuN8WBm7WYC8egStV7NFP36X4HsdN4C2T_0g@mail.gmail.com>
	<555A780E.7070701@oracle.com> <555B9636.6050402@fb.com>
In-Reply-To: <555B9636.6050402@fb.com>
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
To: Jens Axboe <axboe@fb.com>, Ming Lei <ming.lei@canonical.com>
Cc: xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 5/19/2015 12:59 PM, Jens Axboe wrote:
> On 05/18/2015 05:38 PM, santosh shilimkar wrote:
>> On 5/18/2015 4:25 PM, Ming Lei wrote:
>>> On Tue, May 19, 2015 at 7:13 AM, santosh shilimkar
>>> <santosh.shilimkar@oracle.com> wrote:
>>>> On 5/18/2015 11:07 AM, santosh shilimkar wrote:
>>>>>
>>>>> On 5/17/2015 6:26 PM, Ming Lei wrote:
>>>>>>
>>>>>> Hi Santosh,
>>>>>>
>>>>>> Thanks for your report!
>>>>>>
>>>>>> On Sun, May 17, 2015 at 4:13 AM, santosh shilimkar
>>>>>> <santosh.shilimkar@oracle.com> wrote:
>>>>>>>
>>>>>>> Hi Ming Lei, Jens,
>>>>>>>
>>>>>>> While doing few tests with recent kernels with Xen Server,
>>>>>>> we saw guests(DOMU) disk image getting corrupted while booting it.
>>>>>>> Strangely the issue is seen so far only with disk image over ocfs2
>>>>>>> volume. If the same image kept on the EXT3/4 drive, no corruption
>>>>>>> is observed. The issue is easily reproducible. You see the flurry
>>>>>>> of errors while guest is mounting the file systems.
>>>>>>>
>>>>>>> After doing some debug and bisects, we zeroed down the issue with
>>>>>>> commit "b5dd2f6 block: loop: improve performance via blk-mq". With
>>>>>>> that commit reverted the corruption goes away.
>>>>>>>
>>>>>>> Some more details on the test setup:
>>>>>>> 1. OVM(XEN) Server kernel(DOM0) upgraded to more recent kernel
>>>>>>> which includes commit b5dd2f6. Boot the Server.
>>>>>>> 2. On DOM0 file system create a ocfs2 volume
>>>>>>> 3. Keep the Guest(VM) disk image on ocfs2 volume.
>>>>>>> 4. Boot guest image. (xm create vm.cfg)
>>>>>>
>>>>>>
>>>>>> I am not familiar with xen, so is the image accessed via
>>>>>> loop block inside of guest VM? Is he loop block created
>>>>>> in DOM0 or guest VM?
>>>>>>
>>>>> Guest. The Guest disk image is represented as a file by loop
>>>>> device.
>>>>>
>>>>>>> 5. Observe the VM boot console log. VM itself use the EXT3 fs.
>>>>>>> You will see errors like below and after this boot, that file
>>>>>>> system/disk-image gets corrupted and mostly won't boot next time.
>>>>>>
>>>>>>
>>>>>> OK, that means the image is corrupted by VM booting.
>>>>>>
>>>>> Right
>>>>>
>>>>> [...]
>>>>>
>>>>>>>
>>>>>>>   From the debug of the actual data on the disk vs what is read by
>>>>>>> the guest VM, we suspect the *reads* are actually not going all
>>>>>>> the way to disk and possibly returning the wrong data. Because
>>>>>>> the actual data on ocfs2 volume at those locations seems
>>>>>>> to be non-zero where as the guest seems to be read it as zero.
>>>>>>
>>>>>>
>>>>>> Two big changes in the patchset are: 1) use blk-mq request based IO;
>>>>>> 2) submit I/O concurrently(write vs. write is still serialized)
>>>>>>
>>>>>> Could you apply the patch in below link to see if it can fix the
>>>>>> issue?
>>>>>> BTW, this patch only removes concurrent submission.
>>>>>>
>>>>>> http://marc.info/?t=143093223200004&r=1&w=2
>>>>>>
>>>>> What kernel is this patch generated against ? It doesn't apply against
>>>>> v4.0. Does this need the AIO/DIO conversion patches as well. Do you
>>>>> have the dependent patch-set I can't apply it against v4.0.
>>>>>
>>>> Anyways, I created patch(end of the email) against v4.0, based on
>>>> your patch
>>>> and tested it. The corruption is no more seen so it does fix
>>>> the issue after backing out concurrent submission changes from
>>>> commit b5dd2f6. Let me know whats you plan with it since linus
>>>> tip as well as v4.0 needs this fix.
>>>
>>> If your issue is caused by concurrent IO submittion, it might be one
>>> issue of ocfs2. As you see, there isn't such problem for ext3/ext4.
>>>
>> As we speak, I got to know about another regression with XFS as well
>> and am quite confident based on symptom that its similar issue.
>> I will get a confirmation on the same by tomorrow whether the patch
>> fixes it or not.
>>
>>> And the single thread patch is introduced for aio/dio support, which
>>> shouldn't have been a fix patch.
>>>
>>
>> Well before the loop blk-mq conversion commit b5dd2f6, the loop driver
>> was single threaded and as you see that issue seen with that
>> commit. Now with this experiment, it also proves that those work-queue
>> split changes are problematic. So am not sure why do you say that it
>> shouldn't be a fix patch.
>
> There should be no issue with having concurrent submissions. If
> something relies on serialization of some sort, then that is broken and
> should be fixed up. That's not a problem with the loop driver. That's
> why it's not a fix.
>
Fair enough and I agree with you both in principal.

Bottom line is, we have at least two file systems(ocfs2, xfs) showing
corruption as of now when used over loop device from commit b5dd2f6
onwards. As you can see from the thread, Ming Lei suggested me to try
out the patch[1] which he has cooked up as part of the dio/aio loop 
conversion. And that did help in both ocfs2 as well as xfs case.

I will keep looking further into it but just in case some else
stumbles on it, atleast they know now about the problem.

Regards,
Santosh
[1] http://marc.info/?t=143093223200004&r=1&w=2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
