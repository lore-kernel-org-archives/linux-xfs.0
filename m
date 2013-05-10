Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D7AA929DF8
	for <linux-xfs@oss.sgi.com>; Fri, 10 May 2013 08:33:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72860AC025
	for <linux-xfs@oss.sgi.com>; Fri, 10 May 2013 06:33:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HBqNOQLdfnk7R8QR for <linux-xfs@oss.sgi.com>;
	Fri, 10 May 2013 06:33:20 -0700 (PDT)
Message-ID: <518CF71F.8060800@sandeen.net>
Date: Fri, 10 May 2013 08:33:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 3.9.0: general protection fault
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
	<5188E2F5.1090304@itwm.fraunhofer.de>
	<20130507220742.GC24635@dastard>
	<518A8FD4.40700@itwm.fraunhofer.de>
	<20130509004115.GM24635@dastard>
	<518CC9A9.9060500@itwm.fraunhofer.de>
In-Reply-To: <518CC9A9.9060500@itwm.fraunhofer.de>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-xfs@oss.sgi.com

On 5/10/13 5:19 AM, Bernd Schubert wrote:
> On 05/09/2013 02:41 AM, Dave Chinner wrote:
>> On Wed, May 08, 2013 at 07:48:04PM +0200, Bernd Schubert wrote:
>>> On 05/08/2013 12:07 AM, Dave Chinner wrote:
>>>> On Tue, May 07, 2013 at 01:18:13PM +0200, Bernd Schubert wrote:
>>>>> On 05/07/2013 03:12 AM, Dave Chinner wrote:
>>>>>> On Mon, May 06, 2013 at 02:47:31PM +0200, Bernd Schubert wrote:
>>>>>>> On 05/06/2013 02:28 PM, Dave Chinner wrote:
>>>>>>>> On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
>>>>>>>>> And anpther protection fault, this time with 3.9.0. Always happens
>>>>>>>>> on one of the servers. Its ECC memory, so I don't suspect a faulty
>>>>>>>>> memory bank. Going to fsck now-
>>>>>>>>
>>>>>>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>>>>>>>
>>>>>>> Isn't that a bit overhead? And I can't provide /proc/meminfo and
>>>>>>> others, as this issue causes a kernel panic a few traces later.
>>>>>>
>>>>>> Provide what information you can.  Without knowing a single thing
>>>>>> about your hardware, storage config and workload, I can't help you
>>>>>> at all. You're asking me to find a needle in a haystack blindfolded
>>>>>> and with both hands tied behind my back....
>>>>>
>>>>> I see that xfs_info, meminfo, etc are useful, but /proc/mounts?
>>>>> Maybe you want "cat /proc/mounts | grep xfs"?. Attached is the
>>>>> output of /proc/mounts, please let me know if you were really
>>>>> interested in all of that non-xfs output?
>>>>
>>>> Yes. You never know what is relevant to a problem that is reported,
>>>> especially if there are multiple filesystems sharing the same
>>>> device...
>>>
>>> Hmm, I see. But you need to extend your questions to multipathing
>>> and shared storage.

If you'd like to add that to the wiki it'd be great.

>> why would we? Anyone using such a configuration reporting a bug
>> usually is clueful enough to mention it in their bug report when
>> describing their RAID/LVM setup.  The FAQ entry covers the basic
>> information needed to start meaingful triage, not *all* the
>> infomration we might ask for. It's the baseline we start from.
>>
>> Indeed, the FAQ exists because I got sick of asking people for the
>> same information several times a week, every week in response to
>> poor bug reports like yours. it's far more efficient to paste a link
>> several times a week.  i.e. The FAQ entry is there for my benefit,
>> not yours.
> 
> Poor bug report or not, most information you ask about in the FAQ are entirely irrelevant for this issue.

If I had a dollar for every time a bug reporter left out "irrelevant"
information that turned out to be critical, I might be retired by now.  :)

If a few developers on the list are going to scale to supporting every
user with a problem, we need to share the effort efficiently, and that
means putting just a bit more burden on the reporter, to cut down
on the back and forth cycles of trying to gather more information.

If anyone wants a quick & useful project, perhaps a script which gathers
all requested info in the faq would be a step in the right direction.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
