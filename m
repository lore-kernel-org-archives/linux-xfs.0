Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKE3p7g175674 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 08:03:51 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id oXqayJpcK24Rc7xd for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 06:06:00 -0800 (PST)
References: <4C0EA21B.8020703@sandeen.net> <508ABE75.4030703@sgi.com>
	<50A9A6FE.1080106@jp.fujitsu.com> <50AB01AA.5060706@sandeen.net>
	<50AB077F.5000003@jp.fujitsu.com>
	<50AB1502.2030603@sandeen.net> <50AB8B44.6000500@sgi.com>
In-Reply-To: <50AB8B44.6000500@sgi.com>
Mime-Version: 1.0 (1.0)
Message-Id: <62E25852-4EF1-4E63-B2E1-881938E18F9B@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests: fix to build src/realpath and the correct the
	existence of target devices
Date: Tue, 20 Nov 2012 08:05:56 -0600
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: sat <takeuchi_satoru@jp.fujitsu.com>, xfs mailing list <xfs@oss.sgi.com>

On Nov 20, 2012, at 7:53 AM, Rich Johnston <rjohnston@sgi.com> wrote:

> On 11/19/2012 11:28 PM, Eric Sandeen wrote:
>> On 11/19/12 10:30 PM, sat wrote:
>>> (2012/11/20 13:06), Eric Sandeen wrote:
>>>> On 11/18/12 9:26 PM, sat wrote:
>>>>> Hi Rich, Eric
>>>>> 
>>>>> (2012/10/27 1:46), Rich Johnston wrote:
>>>>>> On 06/08/2010 03:03 PM, Eric Sandeen wrote:
>>>>>>> If you try running xfstests on lvm volumes which are symlinks,
>>>>>>> it'll fail to run several tests because our _require_scratch
>>>>>>> framework ultimately uses lstat not stat, and does not think
>>>>>>> the lvm device (which is usually a symlink to a dm-X device)
>>>>>>> is a block device.  Sigh.
>>>>>>> 
>>>>>>> Last try at this - just resolve any symlinked devicenames
>>>>>>> into their realpath(3) in common.config.
>>>>>>> 
>>>>>>> This actually seems to work.
>>>>>>> 
>>>>>>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>>>>>> 
>>>>>>> ---
>>>>>>> 
>>>>>>> 
>>>>>>> diff --git a/common.config b/common.config
>>>>>>> index 926846b..e5b2483 100644
>>>>>>> --- a/common.config
>>>>>>> +++ b/common.config
>>>>>> 
>>>>>> Looks good
>>>>>> 
>>>>>> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
>>>>>> 
>>>>>> Eric,
>>>>>> 
>>>>>> This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, master branch, commit ID d5ea873f.
>>>>> 
>>>>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>>>> 
>>>>> Commit d5ea873f is not the same as the the following original Eric's patch.
>>>>> 
>>>>> http://oss.sgi.com/archives/xfs/2010-06/msg00080.html
>>>>> 
>>>>> It does not modify src/Makefile and realpath is never compiled.
>>>> 
>>>> Yep, whoops.  Merge error . . .?
> 
> Yes sorry my bad.
> 
>>>> 
>>>>> In addition, `[ -L $TEST_DEV ]' and `[ -L $SCRATCH_DEV ]' always returns 0
>>>>> if $TEST_DEV or $SCRATCH_DEV are not defined.
>>>> 
>>>> Well, I don't think ./check will get very far with an undefined TEST_DEV or
>>>> SCRATCH_DEV, but better this way, thanks.
>>> 
>>> I think so too. But setting $SCRATCH_DEV is optional anyaway (refer to README).
>>> I forgot to specify $SCRATCH_DEV and found this problem.
>> 
>> Ah, right - yes, that's perfectly valid, sorry.  Not thinking straight :)
>> 
>> -Eric
> 
> Eric, do you have time to correct these 2 errors or do want me submit a patch?
> 
Satoru had submitted the patch and it has 2 reviews on list, just look up-thread.  :)

Eric

>> 
>>> Satoru
>>> 
>>> 
>> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
