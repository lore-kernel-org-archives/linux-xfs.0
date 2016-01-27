Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 550FF7CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 16:25:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6F2FAC004
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 14:25:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RscshHDzJuDd2Pbf for <xfs@oss.sgi.com>;
	Wed, 27 Jan 2016 14:25:23 -0800 (PST)
Received: from Liberator.local (70-90-76-85-BusName-mn.hfc.comcastbusiness.net
	[70.90.76.85])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 97A406146F33
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 16:25:22 -0600 (CST)
Subject: Re: [PATCH] Split default quota limits by quota type
References: <1453303127-27295-1-git-send-email-cmaiolino@redhat.com>
	<569FC41E.2040300@sandeen.net> <20160127153705.GA17571@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A943D1.4020606@sandeen.net>
Date: Wed, 27 Jan 2016 16:25:21 -0600
MIME-Version: 1.0
In-Reply-To: <20160127153705.GA17571@redhat.com>
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

On 1/27/16 9:37 AM, Carlos Maiolino wrote:

> Ok, I was just working on implement it, but honestly, I don't see the point now
> in split time limits by user/group/project.
> 
> grace periods are set globally by default. We don't have specific quota grace
> limits for each user or each group. Just a single value for them.
>
> So, if we can not specify an individual grace period per-user or per-group, what
> is the point in having these time limits split by user/group/project? We could
> have the values divided by user/group/proj, but what's the sense on it? If we
> have a default grace limit for users, it will be set to all users, if we have a
> grace limit for groups, it will be enforced to all users anyway (since we can't
> specify the group here either).
> 
> So, I wonder, does it make sense?
> 
> Looks a nice idea for the future, but for the current implementation it doesn't
> make sense to me. But sure, let me know if I'm wrong :)


Sorry for all the self-replies.

I'm thinking that this really should be fixed up along with this work.

The time limits aren't about per-user or per-group; they are in fact filesystem-wide.

However, it is possible today to set time limits for user quota, group quota,
or project quota - i.e. not for each user, but for the user *type*; not for
each group, but for the group *type*.

Fixing it should be as "easy" as moving those time limits into your default
quotas structures.  It'd come almost for free in xfs_qm_init_quotainfo().

xfs_qm_adjust_dqtimers() then needs to use those, and
xfs_qm_fill_state() should get the proper values for each type, as well.

But the problem may be in reporting back out to userspace via
quota_getstate():

        /*
         * GETXSTATE quotactl has space for just one set of time limits so
         * report them for the first enabled quota type
         */

o_O doesn't that suck!

quota_getstatev() has enough padding that we could report it all out, though,
with some changes.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
