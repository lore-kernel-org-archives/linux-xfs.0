Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD86F7F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 18:36:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49F1FAC005
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 16:35:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AdjZVGE2ol5jRsMc for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 16:35:55 -0700 (PDT)
Date: Fri, 21 Jun 2013 09:35:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130620233551.GW29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com> <51C31F48.9070503@redhat.com>
	<20130620133903.5193d3ee@oracle.com> <51C35410.2040109@redhat.com>
	<87ip18o0yw.fsf@xmission.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ip18o0yw.fsf@xmission.com>
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
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Brian Foster <bfoster@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Thu, Jun 20, 2013 at 03:45:43PM -0700, Eric W. Biederman wrote:
> I have a question about the project quota.  Is it intended that any
> user can set an project quota on any file?  Unless I am misreading
> xfs_ioctl_setattr that is what it allows.

Only on files they own. There is this check in xfs_ioctl_setattr():

        /*
         * CAP_FOWNER overrides the following restrictions:
         *
         * The user ID of the calling process must be equal
         * to the file owner ID, except in cases where the
         * CAP_FSETID capability is applicable.
         */
        if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
                code = XFS_ERROR(EPERM);
                goto error_return;
        }


> My narrow focus concern on this is that if the user is in a user
> namespace these ids need to be mapped before we look at them or else
> we will do the wrong thing.

The user IDs need to be mapped, yes, but do we want to map project
IDs? Project IDs are the property of the underlying filesystem, not
that of a user namespace. Users can change what project their files
are associated with, but they cannot change their UID or GID....

I can see reasons for wanting the same project quota id to be shared
across multiple namespaces. e.g.  setting up a directory tree quota
for a specific set of namespaces where you don't care about
individual namespace space usage but you want the group as a whole
to be limited.

Indeed, the use of project quotas as an external management tool for
limiting the filesystem space a namespace container can actually
consume makes an interesting argument for preventing access to
project quotas from any namespace other than the init_user_ns.

So, rather than saying "it must be mapped", how about we start by
thinking about how we wnt project quotas to be used in containerised
namespace configurations and work from there....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
