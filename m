Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D26D229E02
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 20:58:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A452304043
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 18:58:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LbaAURYzyVxGnDSP for <linux-xfs@oss.sgi.com>;
	Thu, 12 Sep 2013 18:58:35 -0700 (PDT)
Message-ID: <52327149.6060507@sandeen.net>
Date: Thu, 12 Sep 2013 20:58:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Time for an xfsprogs "alpha1" release?
References: <52322F7A.8060405@sandeen.net> <5232380E.4040300@sgi.com>
	<52323DB7.8000800@sandeen.net> <523250E5.2050607@sgi.com>
In-Reply-To: <523250E5.2050607@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 9/12/13 6:40 PM, Mark Tinguely wrote:
> On 09/12/13 17:18, Eric Sandeen wrote:
>> On 9/12/13 4:54 PM, Mark Tinguely wrote:
>>> On 09/12/13 16:17, Eric Sandeen wrote:
>>>> With all of the changes for CRC filesystems in xfsprogs git now, I'm wondering if it'd be a good idea to do a "3.2.0-alpha1" sort of release.
>>>>
>>>> I know it's not yet feature complete, but I think there would be value in getting a version-stamped tarball out there for testing - it could filter to rawhide-ish distros, and get a bit more airtime while the remaining bits get worked out.
>>>>
>>>> We'd probably want a nice readme about what's new and what's not yet done, caveats, etc, but I think it'd be worth getting it out there into the hands of willing testers, w/o requiring them to do a build from git.
>>>>
>>>> Thoughts?
>>>>
>>>> Thanks,
>>>> -Eric
>>>>
>>>
>>> Good idea, but xfsprogs is in a state that it can't compile:
>>>
>>>     http://oss.sgi.com/archives/xfs/2013-09/msg00396.html
>>>
>>> Patch 31 v3 / 55 is broken. It is missing xfs_sb.c and has an extra
>>> xfs_mount.c.
>>>
>>> If you want it this week, we could do the corrections or wait for Dave
>>> to repost.
>>
>> hm? The git tree builds fine here, anyway (modulo some warnings).
>>
>> so quick, cut an alpha1 before it breaks.  ;)
>>
>> (but if you mean: we should get the latest stuff on the list in first,
>> and fix it so it builds - ok - but there will probably always be more
>> stuff to pull in, so at some point when we have a reasonable amount of it
>> in place, we could cut a test release?  There's always "alpha2"...)
>>
>> -Eric
> 
> Yep, simple to fix. I manually pulled in xfs_sb.c to make sure 47 v2 / 55 was still okay. I can have a tar tomorrow.

Well, any released tarball needs to come from a tagged git tree, of course.

So if the new series needs to go in first, and needs fixes before that, we can wait.  Or if it's ok as it is now, and just missing some functionality, we could cut it now as alpha1, and cut alpha2 next.... *shrug*.  Not a huge rush, just pick a time when the tree is useful to get some wider testing, and cut a pre-release from that point in git.

-Eric

> --Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
