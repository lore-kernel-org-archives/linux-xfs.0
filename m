Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NFgREP101833 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 10:42:32 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79DEB1400831
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 08:45:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qj79vZR8R9GXFV0o for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 08:45:27 -0700 (PDT)
Message-ID: <4D8A1594.5060505@redhat.com>
Date: Wed, 23 Mar 2011 10:45:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: xfstests: failure to umount ext4
References: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>	<4D8A0A70.9030201@redhat.com>
	<AANLkTi=JvL6LoL=VOrHoiQKheqzDrVwOQtWAkumzaBk5@mail.gmail.com>
In-Reply-To: <AANLkTi=JvL6LoL=VOrHoiQKheqzDrVwOQtWAkumzaBk5@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amir Goldstein <amir73il@gmail.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, XFS <xfs@oss.sgi.com>

On 3/23/11 10:33 AM, Amir Goldstein wrote:
> On Wed, Mar 23, 2011 at 4:57 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 3/23/11 9:36 AM, Amir Goldstein wrote:
>>> On Wed, Mar 23, 2011 at 4:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>
>>>> I've been running xfstests on ext4 and I always get annoying failures to umount:
>>>>
>>>> 213 8s ... 31s
>>>> umount: /mnt/test/ext4: device is busy.
>>>>        (In some cases useful info about processes that use
>>>>         the device is found by lsof(8) or fuser(1))
>>>>
>>>> post 198 mostly fails to umount as well.
>>>> and post 124 always fails to umount.
>>>>
>>>> My server is Ubuntu 10.10, running kernel 2.6.38.
>>>>
>>>> Is there any known issue about this? because I could find it on google
>>>> or on the XFS list.
>>>>
>>>
>>> Hi All,
>>>
>>> Has anyone seen these failures when running xfstests on ext4?
>>> My test and scratch partitions are dedicated for xfstests.
>>
>> I've not seen it, can you investigate with lsof etc?
> 
> OK. I have not given complete information.
> It does not fail indefinably. I can umount the fs immediately after the failure.
> Only the test fails because fsck sees a mounted fs.
> There must be a bit of a delay in the umount that causes the problem.
> 
>>
>> They both work for me on a quick test, anyway, on a .38
>> kernel.
> 
> Problem existed for me in .37 as well. I don't think it is kernel (or
> fs) related.
> I think it is a system problem, but I fall short of ideas how to fix it.
> 
>>
>> What are you using for your partitions under test?
>>
> 
> Currently, I have /dev/sda5,6,7,8.
> I used to work with LVM, but lstat64 didn't like the /dev/mapper links,
> so I switched to raw partitions.
> Although I was puzzled that xfstests could not work over LVM partitions
> It could when I changed lstat64 to stat64, but then I changed it back
> thinking it was causing my problems.

I tried to fix lvm, once, but all the dev symlinks vs. mtab vs.
/proc/mounts was a rat's nest, and I gave up... :)

-Eric
 
>> -Eric
>>
>>> Thanks,
>>> Amir.
>>
>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
