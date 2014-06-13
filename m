Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6521E7F4E
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 19:02:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4AEA68F8035
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 17:01:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sCNEt8NVa3LFhuPj for <xfs@oss.sgi.com>;
	Thu, 12 Jun 2014 17:01:56 -0700 (PDT)
Date: Fri, 13 Jun 2014 10:01:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: (Un)known issue with XFS group quotas on LVM?
Message-ID: <20140613000137.GV9508@dastard>
References: <CA+Bg6wd9CFKdHaAM-XyJx3royVb2-QdKqhmaamA-KMQk1TdieQ@mail.gmail.com>
	<20140611230706.GL9508@dastard>
	<CA+Bg6wdvZTYufmfK-U_6zwjKVDPVuQP_-Jwsqnh=1ayyB_EmEA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+Bg6wdvZTYufmfK-U_6zwjKVDPVuQP_-Jwsqnh=1ayyB_EmEA@mail.gmail.com>
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
To: John Desantis <desantis@mail.usf.edu>
Cc: xfs@oss.sgi.com

On Thu, Jun 12, 2014 at 10:04:29AM -0400, John Desantis wrote:
> Dave,
> 
> Thanks for your reply.  Let me address your questions and replies.
> 
> > That doesn't sound like a filesystem problem. Sounds more like the
> > remote user/group configuration is getting squashed. Do the systems
> > have the same user/group configurations, or are the clients sending
> > group IDs the server doesn't recognise?
> 
> Stracing shows that the group and user ID's are not being squashed and
> they are resolving each time to their respective UID/GID's.
> 
> > As it is, describing the problem in text doesn't tell me anything
> > about the problem. You need to cut-n-paste the CLI and the output
> > showing the incorrect behaviour so we can attempt to reproduce the
> > same behaviour you are seeing.
> 
> Busted.  I figured before sending the usual gamut of console "action",
> I'd "save" time by simply presenting the symptoms.
> 
> > I can't see how that is related to the filesystem - the filesystem
> > will either account for group quota usage or it won't. It doesn't
> > care what primary gid the process uses, it will simply account usage
> > to that...
> 
> You're correct (but you already knew this!).  I can tell you that
> running the quota report does show the group block count changing.
> 
> It looks like this "issue" is  my misunderstanding of how XFS is
> checking the quota.  Perhaps you could shed some light?
> 
> When you're using active user and group quotas on the same file system
> and the user quota is lower than the group quota, does XFS first check
> against the user quota and then the group quota?  Is the order of
> operations user, group, and then project or does it depend on the
> mounting order of quotas?

Order doesn't matter because the filesystem is supposed to check
against all enforced quotas, not just the first one.

> In the case I presented yesterday, the user in question had a quota of
> 25 GB, but the group had an unlimited quota.  Each time that I used
> sudo -u user -g group or logged into the user's account, the quota was
> always exceeded.  Now that I have removed the user's quota, the group
> quota is now being respected properly.

Again, you need to post the commands and output that demonstrate the
problem you are describing. I'm having trouble understanding what
your problem is because I can't see the raw output that you are
seeing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
