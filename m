Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00B3F29DF8
	for <linux-xfs@oss.sgi.com>; Fri, 10 May 2013 05:19:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E096A304077
	for <linux-xfs@oss.sgi.com>; Fri, 10 May 2013 03:19:27 -0700 (PDT)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id OVqHrFcZsNOYlh8m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 10 May 2013 03:19:26 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	r4AAJNSE013681
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Fri, 10 May 2013 12:19:23 +0200
Message-ID: <518CC9A9.9060500@itwm.fraunhofer.de>
Date: Fri, 10 May 2013 12:19:21 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: 3.9.0: general protection fault
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
	<5188E2F5.1090304@itwm.fraunhofer.de>
	<20130507220742.GC24635@dastard>
	<518A8FD4.40700@itwm.fraunhofer.de>
	<20130509004115.GM24635@dastard>
In-Reply-To: <20130509004115.GM24635@dastard>
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

On 05/09/2013 02:41 AM, Dave Chinner wrote:
> On Wed, May 08, 2013 at 07:48:04PM +0200, Bernd Schubert wrote:
>> On 05/08/2013 12:07 AM, Dave Chinner wrote:
>>> On Tue, May 07, 2013 at 01:18:13PM +0200, Bernd Schubert wrote:
>>>> On 05/07/2013 03:12 AM, Dave Chinner wrote:
>>>>> On Mon, May 06, 2013 at 02:47:31PM +0200, Bernd Schubert wrote:
>>>>>> On 05/06/2013 02:28 PM, Dave Chinner wrote:
>>>>>>> On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
>>>>>>>> And anpther protection fault, this time with 3.9.0. Always happens
>>>>>>>> on one of the servers. Its ECC memory, so I don't suspect a faulty
>>>>>>>> memory bank. Going to fsck now-
>>>>>>>
>>>>>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>>>>>>
>>>>>> Isn't that a bit overhead? And I can't provide /proc/meminfo and
>>>>>> others, as this issue causes a kernel panic a few traces later.
>>>>>
>>>>> Provide what information you can.  Without knowing a single thing
>>>>> about your hardware, storage config and workload, I can't help you
>>>>> at all. You're asking me to find a needle in a haystack blindfolded
>>>>> and with both hands tied behind my back....
>>>>
>>>> I see that xfs_info, meminfo, etc are useful, but /proc/mounts?
>>>> Maybe you want "cat /proc/mounts | grep xfs"?. Attached is the
>>>> output of /proc/mounts, please let me know if you were really
>>>> interested in all of that non-xfs output?
>>>
>>> Yes. You never know what is relevant to a problem that is reported,
>>> especially if there are multiple filesystems sharing the same
>>> device...
>>
>> Hmm, I see. But you need to extend your questions to multipathing
>> and shared storage.
>
> why would we? Anyone using such a configuration reporting a bug
> usually is clueful enough to mention it in their bug report when
> describing their RAID/LVM setup.  The FAQ entry covers the basic
> information needed to start meaingful triage, not *all* the
> infomration we might ask for. It's the baseline we start from.
>
> Indeed, the FAQ exists because I got sick of asking people for the
> same information several times a week, every week in response to
> poor bug reports like yours. it's far more efficient to paste a link
> several times a week.  i.e. The FAQ entry is there for my benefit,
> not yours.

Poor bug report or not, most information you ask about in the FAQ are 
entirely irrelevant for this issue.

>
> I don't really care if you don't understand why we are asking for
> that information, I simply expect you to provide it as best you can
> if you want your problem solved.

And here we go, the bug I reported is not my problem. I simply reported 
a bug in XFS. You can use it or not, I do not care at all. This is not a 
production system and if XFS is not running sufficiently stable I'm 
simply going to switch to another file system.
Of course I don't like bugs and I'm going to help to fix it, but I have 
a long daily todo list and I'm not going to spend my time filling in 
irrelevent items.

>
>> Both time you can easily get double mounts... I
>> probably should try to find some time to add ext4s MMP to XFS.
>
> Doesn't solve the problem. It doesn't prevent multiple write access
> to the lun:
>
> 	Ah, a free lun. I'll just put LVM on it and mkfs it and....
> 	Oh, sorry, were you using that lun?

MMP is not about human mistakes. MMP is an *additional* protection for 
software managed shared storage devices. If your HA software runs into a 
bug or gets split brain for some reasons you easily get a double mount. 
The fact the MMP also protects against a few human errors is just a nice 
addon.

>
> So, naive hacks like MMP don't belong in filesystems....#

Maybe there are better solutions, but it works fine as it is.

>
>>>> And I just wonder what you are going to do with the information
>>>> about the hardware. So it is an Areca hw-raid5 device with 9 disks.
>>>> But does this help? It doesn't tell if one of the disks reads/writes
>>>> with hickups or provides any performance characteristics at all.
>>>
>>> Yes, it does, because Areca cards are by far the most unreliable HW
>>> RAID you can buy, which is not surprising because they are also the
>>
>> Ahem. Compared to other hardware raids Areca is very stable.
>
> Maybe in your experience. We get a report every 3-4 months about
> Areca hardware causing catastrophic data loss. It outnumbers every
> other type of hardware RAID by at least 10:1 when it comes to such
> problem reports.

The number of your reports simply correlates to the number of installed 
areca controllers. The vendor I'm talking about only has externally 
connected boxes and isn't that much used as areca. And don't get me 
wrong, I don't want to defend Areca at all. And personally I don't like 
any of these cheap raid solutions at all for several reasons (e.g. no 
disk latency stats, no parity verification, etc).

>
>> You might want to add to your FAQ something like:
>>
>> Q: Are you sure there is not disk / controller / memory data
>> corruption? If so please state why!
>
> No, the FAQ entry is for gathering facts and data, not what
> the bug reporter *thinks* might be the problem. If there's
> corruption we'll see it in the information that is gathered, and
> then we can start to look for the source.

You *might* see it in the information that is gathered. But without 
additional checksums you are writing yourself you never can be sure. 
Meta CRCs as you implemented them will certainly help.


Cheers,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
