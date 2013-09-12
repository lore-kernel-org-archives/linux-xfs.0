Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E5ACB7F59
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 18:40:26 -0500 (CDT)
Message-ID: <523250E5.2050607@sgi.com>
Date: Thu, 12 Sep 2013 18:40:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Time for an xfsprogs "alpha1" release?
References: <52322F7A.8060405@sandeen.net> <5232380E.4040300@sgi.com>
	<52323DB7.8000800@sandeen.net>
In-Reply-To: <52323DB7.8000800@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 09/12/13 17:18, Eric Sandeen wrote:
> On 9/12/13 4:54 PM, Mark Tinguely wrote:
>> On 09/12/13 16:17, Eric Sandeen wrote:
>>> With all of the changes for CRC filesystems in xfsprogs git now, I'm wondering if it'd be a good idea to do a "3.2.0-alpha1" sort of release.
>>>
>>> I know it's not yet feature complete, but I think there would be value in getting a version-stamped tarball out there for testing - it could filter to rawhide-ish distros, and get a bit more airtime while the remaining bits get worked out.
>>>
>>> We'd probably want a nice readme about what's new and what's not yet done, caveats, etc, but I think it'd be worth getting it out there into the hands of willing testers, w/o requiring them to do a build from git.
>>>
>>> Thoughts?
>>>
>>> Thanks,
>>> -Eric
>>>
>>
>> Good idea, but xfsprogs is in a state that it can't compile:
>>
>>     http://oss.sgi.com/archives/xfs/2013-09/msg00396.html
>>
>> Patch 31 v3 / 55 is broken. It is missing xfs_sb.c and has an extra
>> xfs_mount.c.
>>
>> If you want it this week, we could do the corrections or wait for Dave
>> to repost.
>
> hm? The git tree builds fine here, anyway (modulo some warnings).
>
> so quick, cut an alpha1 before it breaks.  ;)
>
> (but if you mean: we should get the latest stuff on the list in first,
> and fix it so it builds - ok - but there will probably always be more
> stuff to pull in, so at some point when we have a reasonable amount of it
> in place, we could cut a test release?  There's always "alpha2"...)
>
> -Eric

Yep, simple to fix. I manually pulled in xfs_sb.c to make sure 47 v2 / 
55 was still okay. I can have a tar tomorrow.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
