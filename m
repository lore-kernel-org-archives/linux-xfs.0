Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E45FA7CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 08:10:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1269304059
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 06:10:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id B0ZNTF7ujOYDAQaJ for <xfs@oss.sgi.com>;
	Thu, 28 Jan 2016 06:10:43 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 135B263C6064
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 08:10:43 -0600 (CST)
Subject: Re: [PATCH] Split default quota limits by quota type
References: <1453303127-27295-1-git-send-email-cmaiolino@redhat.com>
	<569FC41E.2040300@sandeen.net> <20160127153705.GA17571@redhat.com>
	<56A943D1.4020606@sandeen.net> <20160128123550.GA16237@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56AA2162.1070705@sandeen.net>
Date: Thu, 28 Jan 2016 08:10:42 -0600
MIME-Version: 1.0
In-Reply-To: <20160128123550.GA16237@redhat.com>
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
To: xfs@oss.sgi.com

On 1/28/16 6:35 AM, Carlos Maiolino wrote:
> On Wed, Jan 27, 2016 at 04:25:21PM -0600, Eric Sandeen wrote:
>> On 1/27/16 9:37 AM, Carlos Maiolino wrote:
>>
>>> Ok, I was just working on implement it, but honestly, I don't see the point now
>>> in split time limits by user/group/project.
>>>
>>> grace periods are set globally by default. We don't have specific quota grace
>>> limits for each user or each group. Just a single value for them.
>>>
>>> So, if we can not specify an individual grace period per-user or per-group, what
>>> is the point in having these time limits split by user/group/project? We could
>>> have the values divided by user/group/proj, but what's the sense on it? If we
>>> have a default grace limit for users, it will be set to all users, if we have a
>>> grace limit for groups, it will be enforced to all users anyway (since we can't
>>> specify the group here either).
>>>
>>> So, I wonder, does it make sense?
>>>
>>> Looks a nice idea for the future, but for the current implementation it doesn't
>>> make sense to me. But sure, let me know if I'm wrong :)
>>
>>
>> Sorry for all the self-replies.
>>
>> I'm thinking that this really should be fixed up along with this work.
>>
>> The time limits aren't about per-user or per-group; they are in fact filesystem-wide.
>>
>> However, it is possible today to set time limits for user quota, group quota,
>> or project quota - i.e. not for each user, but for the user *type*; not for
>> each group, but for the group *type*.
>>
>> Fixing it should be as "easy" as moving those time limits into your default
>> quotas structures.  It'd come almost for free in xfs_qm_init_quotainfo().
>>
> Ok, I believe I got your point, but, I keep with my question about: what's the
> point of having user *type* limits and group *type* limits if we can't specify
> specific times for different users/groups?

Well, because the man page says you can, and the vfs quota tools allow doing
so, and report it as such, and the userspace tools actually do write the
time limit to each individual quota inode - so almost all the parts, except
the actual enforcement are all there.

> I mean, if we have an inode time limit (just as an example)set to user type,
> and we se it for users. All users will have the same limit.
> But, let's say we have the inode limit set to group type. What is it going to
> change if we can't specify a group?

and what about project? :)

But anyway, the difference is that you could be over user quota but not
group quota, or vice versa, right?

Say user cem has a block quota of 1GB, and belongs to a group,
xfs-developers, with a block quota of 10GB.

If the cem user goes over his 1GB block quota, we might want to give them
30m to fix it.  But if the xfs-developers group goes over their 10GB block
quota, we might want to give them a day, because it might require group
coordination, or something.

That would require, and utilize, separate grace-periods for user vs.
group quotas.

> All users will always belong to a group. And
> if we have the time limit set for the group *type*, consequently, all groups
> will have the same limit, which will imply in all users also having the same
> time limit, since all users belongs to at least one group.

The group timer is not for "anyone in a group who has exceeded any quota" -
it is for group quotas which have been exceeded.  i.e. the timer is on the
group quota, not on "people in any group."

-Eric

> So, I really don't see a point in splitting time limit default values if we
> don't actually implement a per-user/per-group limit.
> 
> I have a RFC patch for splitting times (using the same structures I used to
> split default b/i limits), but it's useless without a per-group/user specific
> time.
> 
> It can certainly be implemented as part of another patch implementing
> per-user/group limits, but with the current implementation, I really don't see
> much sense, just adding a bunch of code that will not change anything or even
> setup the code for future implementations.
> 
> Please, forgive me if I'm not making myself clear, or if I'm saying something
> stupid, but honestly, I still think that splitting default time/warnings belongs
> to an implementation of per-user/group timers not for this case itself.
> 
> 
> Cheers o>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
