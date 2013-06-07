Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC7F729DF8
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 09:53:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5596EAC00D
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:53:56 -0700 (PDT)
Received: from mo-p05-ob.rzone.de (mo-p05-ob.rzone.de [81.169.146.181]) by
	cuda.sgi.com with ESMTP id wPCAGD9mVs6gQRyU for
	<xfs@oss.sgi.com>; Fri, 07 Jun 2013 07:53:54 -0700 (PDT)
Message-ID: <51B1F400.1040107@jan-o-sch.net>
Date: Fri, 07 Jun 2013 16:53:52 +0200
From: Jan Schmidt <list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests btrfs/314: test send / receive
References: <1370532033-20561-1-git-send-email-list.xfs@jan-o-sch.net>
	<51B0CCC6.2010500@redhat.com> <51B18962.3090504@jan-o-sch.net>
	<20130607102904.GC13113@dastard> <51B1F32A.9080404@redhat.com>
	<51B1F37D.1060005@gmx.net>
In-Reply-To: <51B1F37D.1060005@gmx.net>
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
To: Arne Jansen <sensille@gmx.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de, xfs@oss.sgi.com

On Fri, June 07, 2013 at 16:51 (+0200), Arne Jansen wrote:
> On 07.06.2013 16:50, Eric Sandeen wrote:
>> On 6/7/13 5:29 AM, Dave Chinner wrote:
>>> On Fri, Jun 07, 2013 at 09:18:58AM +0200, Jan Schmidt wrote:
>>>> (cc Arne for far-progs discussion)
>>>>
>>>> On Thu, June 06, 2013 at 19:54 (+0200), Eric Sandeen wrote:
>>>>> On 6/6/13 10:20 AM, Jan Schmidt wrote:
>>>>>> Basic send / receive functionality test for btrfs. Requires current
>>>>>> version of fsstress built (-x support). Relies on fssum tool, which is
>>>>>> not part of the test suite but can skip the test if it is missing.
>>>>>>
>>>>>> Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
>>>>>
>>>>> w/o commenting on the test itself, I'm a little uneasy about requiring
>>>>> some external, not-widely-installed tool for this to run.  The fear is
>>>>> that it won't be run as often as it could/should be.
>>>>
>>>> The main purpose is to have it run by developers changing something around btrfs
>>>> send / receive and probably the backref walker (while there exists a separate
>>>> test not requiring fssum for backrefs). I think we can get them to install fssum.
>>>
>>> There's no point in having tests that require you to go find
>>> something else before the tests can be run. That's been tried
>>> before, and it doesn't work - the test just won't get run by
>>> the majority of people who run xfstests.
>>>
>>>>> Could the same test be done w/o fssum, or should we maybe put a copy
>>>>> of fssum into xfstests/src/fssum.c ?
>>>>
>>>> I don't know any adequate replacement for fssum in this case. The purpose is to
>>>> build a checksum for a whole file system tree, including data and partly metadata.
>>>>
>>>> I don't feel like copying fssum from far-progs into xfstests, though it probably
>>>> won't hurt much. However, I cannot promise we won't make changes to it for
>>>> far-progs, probably creating two incompatible versions of fssum in the wild. Arne?
>>>>
>>>>> Or does fssum exist in any standard distro package?
>>>>
>>>> It doesn't. Perhaps Josef can hurry and make a Fedora package for it, if that
>>>> prevents a separate copy to xfstests :-)
>>>
>>> No, it doesn't. Packages would be needed for debian, suse, SLES,
>>> RHEL, etc for that to be a useful method of distribution. Just dump
>>> a snapshot of the utility in the xfstests src dir so we don't have
>>> to care about distribution issues...
>>
>> Yup I agree with this, if it's not widely available or replaceable by more
>> common tools, let's just put a snapshot in xfstests.
> 
> I'm fine with that, too.

To prevent more agreement mails: I'll send a v2 including fssum.c, but probably
not today.

-Jan

> -Arne
> 
>>
>> -Eric
>>
>>> Cheers,
>>>
>>> Dave.
>>>
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
