Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6F717CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 13:06:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 974A68F8040
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 11:06:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KN12quvGpdnBAW5K for <xfs@oss.sgi.com>;
	Wed, 27 Jan 2016 11:06:46 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id DD0D661213D3
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 13:06:45 -0600 (CST)
Subject: Re: [PATCH] Split default quota limits by quota type
References: <1453303127-27295-1-git-send-email-cmaiolino@redhat.com>
	<569FC41E.2040300@sandeen.net> <20160127153705.GA17571@redhat.com>
	<56A8FBA9.3060205@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A91545.3090806@sandeen.net>
Date: Wed, 27 Jan 2016 13:06:45 -0600
MIME-Version: 1.0
In-Reply-To: <56A8FBA9.3060205@sandeen.net>
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

On 1/27/16 11:17 AM, Eric Sandeen wrote:
> On 1/27/16 9:37 AM, Carlos Maiolino wrote:
>>>>
>>>> This patch aims to split the default quota value by quota type. Allowing each
>>>> quota type having different default values.
>>>>
>>>> Default time limits are still set globally, but I don't mind to split them by
>>>> quota type too.
>>>
>>> Hm, I guess it seems like it should be done; otherwise it's a weird
>>> caveat, isn't it?  "Default limits are set by type, but timers are
>>> inherited from whatever first default quota is found across all types"
>>>
>>> So yeah, seems like it should be done for timers as well, IMHO;
>>> grace periods can be set for each default quota type, so they should
>>> be honored.
>>>
>>
>> Ok, I was just working on implement it, but honestly, I don't see the point now
>> in split time limits by user/group/project.
>>
>> grace periods are set globally by default. We don't have specific quota grace
>> limits for each user or each group. Just a single value for them.
> 
> yeah, sorry about that.  I forgot that they were fs-wide, but that makes sense.
> Sorry for leading you astray.

Ugh, this is a mess.  The xfs_quota command says:

       timer [ -gpu ] [ -bir ] value

we can indeed set timers for each type; group, project, and user.
These really are stored on-disk for ID 0 for each type.
We can set different values for user, group, and project.

However, let's set the inode timer for group quota to 30 minutes:

# xfs_quota -x -c "timer -i -g 30m" /dev/sdb1
# xfs_quota -x -c "state" /dev/sdb1 | grep grace
Blocks grace time: [7 days 00:00:30]
Inodes grace time: [0 days 00:30:30]

Uh, ok, it set a global default.  (And where did the 30s come
from?)

Now let's set an inode timer for *user* quota:

# xfs_quota -x -c "timer -i -u 60m" /dev/sdb1
# xfs_quota -x -c "state" /dev/sdb1 | grep grace
Blocks grace time: [7 days 00:00:30]
Inodes grace time: [0 days 01:00:30]

Uh, ok, now that's the grace time...

Go back to group quota, try something smaller?

# xfs_quota -x -c "timer -i -g 10m" /dev/sdb1
# xfs_quota -x -c "state" /dev/sdb1 | grep grace
Blocks grace time: [7 days 00:00:30]
Inodes grace time: [0 days 00:10:30]

Ok, seems that "type" doesn't matter, and whatever was set last wins.  Except:

<remount>

# xfs_quota -x -c "state" /dev/sdb1 | grep grace
Blocks grace time: [7 days 00:00:30]
Inodes grace time: [0 days 01:00:30]

ohai, now we are back to the user quota we set, because that's checked first.  :(

(with your most recent patch, it'll be whatever is checked *last*).

So this is all a big steaming pile, right down to the "timer"
command help giving you options it won't accept (-d), or ignores (id|name).

I guess it seems ok to just break out default limits into per-type limits; that's
a decent step in the right direction.  We probably need to think more about
how the timers should work; do we really want them to be global?  The tool
certainly reports them as such, although it claims to set them per-type.

Anyway, changes you make for per-type limits probably shouldn't change
how time limits are interpreted, but today they do.

...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
