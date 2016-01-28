Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 94BC97CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 06:35:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8202A304053
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 04:35:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S5HYQGNb2K2bD8eR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 04:35:56 -0800 (PST)
Date: Thu, 28 Jan 2016 13:35:50 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Split default quota limits by quota type
Message-ID: <20160128123550.GA16237@redhat.com>
References: <1453303127-27295-1-git-send-email-cmaiolino@redhat.com>
	<569FC41E.2040300@sandeen.net> <20160127153705.GA17571@redhat.com>
	<56A943D1.4020606@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56A943D1.4020606@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Jan 27, 2016 at 04:25:21PM -0600, Eric Sandeen wrote:
> On 1/27/16 9:37 AM, Carlos Maiolino wrote:
> 
> > Ok, I was just working on implement it, but honestly, I don't see the point now
> > in split time limits by user/group/project.
> > 
> > grace periods are set globally by default. We don't have specific quota grace
> > limits for each user or each group. Just a single value for them.
> >
> > So, if we can not specify an individual grace period per-user or per-group, what
> > is the point in having these time limits split by user/group/project? We could
> > have the values divided by user/group/proj, but what's the sense on it? If we
> > have a default grace limit for users, it will be set to all users, if we have a
> > grace limit for groups, it will be enforced to all users anyway (since we can't
> > specify the group here either).
> > 
> > So, I wonder, does it make sense?
> > 
> > Looks a nice idea for the future, but for the current implementation it doesn't
> > make sense to me. But sure, let me know if I'm wrong :)
> 
> 
> Sorry for all the self-replies.
> 
> I'm thinking that this really should be fixed up along with this work.
> 
> The time limits aren't about per-user or per-group; they are in fact filesystem-wide.
> 
> However, it is possible today to set time limits for user quota, group quota,
> or project quota - i.e. not for each user, but for the user *type*; not for
> each group, but for the group *type*.
> 
> Fixing it should be as "easy" as moving those time limits into your default
> quotas structures.  It'd come almost for free in xfs_qm_init_quotainfo().
> 
Ok, I believe I got your point, but, I keep with my question about: what's the
point of having user *type* limits and group *type* limits if we can't specify
specific times for different users/groups?

I mean, if we have an inode time limit (just as an example)set to user type,
and we se it for users. All users will have the same limit.
But, let's say we have the inode limit set to group type. What is it going to
change if we can't specify a group? All users will always belong to a group. And
if we have the time limit set for the group *type*, consequently, all groups
will have the same limit, which will imply in all users also having the same
time limit, since all users belongs to at least one group.

So, I really don't see a point in splitting time limit default values if we
don't actually implement a per-user/per-group limit.

I have a RFC patch for splitting times (using the same structures I used to
split default b/i limits), but it's useless without a per-group/user specific
time.

It can certainly be implemented as part of another patch implementing
per-user/group limits, but with the current implementation, I really don't see
much sense, just adding a bunch of code that will not change anything or even
setup the code for future implementations.

Please, forgive me if I'm not making myself clear, or if I'm saying something
stupid, but honestly, I still think that splitting default time/warnings belongs
to an implementation of per-user/group timers not for this case itself.


Cheers o>




> xfs_qm_adjust_dqtimers() then needs to use those, and
> xfs_qm_fill_state() should get the proper values for each type, as well.
> 
> But the problem may be in reporting back out to userspace via
> quota_getstate():
> 
>         /*
>          * GETXSTATE quotactl has space for just one set of time limits so
>          * report them for the first enabled quota type
>          */
> 
> o_O doesn't that suck!
> 
> quota_getstatev() has enough padding that we could report it all out, though,
> with some changes.
> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
