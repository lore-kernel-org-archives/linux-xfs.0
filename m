Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8482529E12
	for <linux-xfs@oss.sgi.com>; Wed,  8 May 2013 12:48:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E96B30405F
	for <linux-xfs@oss.sgi.com>; Wed,  8 May 2013 10:48:17 -0700 (PDT)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id Fp9B7OAk1eXxLxR7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Wed, 08 May 2013 10:48:14 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	r48Hm5KU010205
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Wed, 8 May 2013 19:48:05 +0200
Message-ID: <518A8FD4.40700@itwm.fraunhofer.de>
Date: Wed, 08 May 2013 19:48:04 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: 3.9.0: general protection fault
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
	<5188E2F5.1090304@itwm.fraunhofer.de>
	<20130507220742.GC24635@dastard>
In-Reply-To: <20130507220742.GC24635@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

On 05/08/2013 12:07 AM, Dave Chinner wrote:
> On Tue, May 07, 2013 at 01:18:13PM +0200, Bernd Schubert wrote:
>> On 05/07/2013 03:12 AM, Dave Chinner wrote:
>>> On Mon, May 06, 2013 at 02:47:31PM +0200, Bernd Schubert wrote:
>>>> On 05/06/2013 02:28 PM, Dave Chinner wrote:
>>>>> On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
>>>>>> And anpther protection fault, this time with 3.9.0. Always happens
>>>>>> on one of the servers. Its ECC memory, so I don't suspect a faulty
>>>>>> memory bank. Going to fsck now-
>>>>>
>>>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>>>>
>>>> Isn't that a bit overhead? And I can't provide /proc/meminfo and
>>>> others, as this issue causes a kernel panic a few traces later.
>>>
>>> Provide what information you can.  Without knowing a single thing
>>> about your hardware, storage config and workload, I can't help you
>>> at all. You're asking me to find a needle in a haystack blindfolded
>>> and with both hands tied behind my back....
>>
>> I see that xfs_info, meminfo, etc are useful, but /proc/mounts?
>> Maybe you want "cat /proc/mounts | grep xfs"?. Attached is the
>> output of /proc/mounts, please let me know if you were really
>> interested in all of that non-xfs output?
>
> Yes. You never know what is relevant to a problem that is reported,
> especially if there are multiple filesystems sharing the same
> device...

Hmm, I see. But you need to extend your questions to multipathing and 
shared storage. Both time you can easily get double mounts... I probably 
should try to find some time to add ext4s MMP to XFS.

>
>> And I just wonder what you are going to do with the information
>> about the hardware. So it is an Areca hw-raid5 device with 9 disks.
>> But does this help? It doesn't tell if one of the disks reads/writes
>> with hickups or provides any performance characteristics at all.
>
> Yes, it does, because Areca cards are by far the most unreliable HW
> RAID you can buy, which is not surprising because they are also the

Ahem. Compared to other hardware raids Areca is very stable.

> cheapest. This is through experience - we see reports of filesystems
> being badly corrupted ever few months because of problems with Areca
> controllers.

The problem is that telling the hardware controller does not tell 
anything about disks. And most raid solutions do not care at all about 
disk corruptions, thats getting better with T10DIF/DX, but unfortunately 
I still don't see that used most installations.
As I'm aware of that problem for several years we started to write 
ql-fstest [1] several years ago, which checks for data corruption. That 
is also part of our stress test suite and so far it didn't report 
anything. So we can exclude disks/controller data corruption with a very 
high probability.

You might want to add to your FAQ something like:

Q: Are you sure there is not disk / controller / memory data corruption? 
If so please state why!



Cheers,
Bernd


[1] https://bitbucket.org/aakef/ql-fstest






_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
