Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 560547F80
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 15:28:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39E5130405F
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:28:33 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mw23A7xVszzfd9YB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 13:28:32 -0700 (PDT)
Date: Fri, 28 Jun 2013 16:28:25 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH 6/6] ioctl eofblocks: require non-privileged users to
	specify uid/gid match
Message-ID: <20130628162825.4fb7e4ed@oracle.com>
In-Reply-To: <51CDDAF0.7060501@redhat.com>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130628111138.68d0b486@oracle.com> <51CDDAF0.7060501@redhat.com>
Mime-Version: 1.0
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
To: Brian Foster <bfoster@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com

On Fri, 28 Jun 2013 14:50:24 -0400
Brian Foster <bfoster@redhat.com> wrote:

> On 06/28/2013 11:11 AM, Dwight Engen wrote:
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 487dca5..123314e 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1655,6 +1655,23 @@ xfs_file_ioctl(
> >  		if (error)
> >  			return -XFS_ERROR(error);
> >  
> > +		/* non-privileged users should not be able to trim
> > blocks on
> > +		 * objects they cannot write to, so require them
> > to specify
> > +		 * either their own uid, or a group they are a
> > member of
> > +		 */
> > +		if (!capable(CAP_SYS_ADMIN)) {
> > +			if (!(eofb.eof_flags & (XFS_EOF_FLAGS_UID
> > | XFS_EOF_FLAGS_GID)))
> > +				return -XFS_ERROR(EPERM);
> > +
> > +			if ((eofb.eof_flags & XFS_EOF_FLAGS_UID) &&
> > +			    !uid_eq(current_fsuid(),
> > keofb.eof_uid))
> > +				return -XFS_ERROR(EPERM);
> > +
> > +			if ((eofb.eof_flags & XFS_EOF_FLAGS_GID) &&
> > +			    !in_group_p(keofb.eof_gid))
> > +				return -XFS_ERROR(EPERM);
> > +		}
> > +
> 
> This looks reasonable to me.
> 
> In thinking more about the other aspect of group management (and I
> admit I'm still waffling about this), it seems like we could go in a
> couple directions:
> 
> - Now that we have a separate internal only eofblocks control, be more
> flexible and provide an internal only flag (valid only for UID/GID
> scans) to instruct the scan to do specific file permission checking
> against the inodes. This would be set by xfs_file_ioctl() and do the
> write permission enforcement for userspace originated scans. This
> would also allow the future EDQUOT work to leave out said flag and do
> a group wide scan regardless of the specific permissions of the
> calling context (i.e., when the system decides all inodes under a
> group quota must be trimmed).

I haven't seen your EDQUOT change, but your description made me wonder:
Are you going to kick off a scan for the type of quota exhausted?
Otherwise could a user abuse this by overrunning his user quota in
order to cause group inodes (that he may not have write to) to be
reclaimed?

At any rate, yeah the only way I see to get the permissions checks
right is to set a flag up in ioctl because the checks need to be per
inode. I think you would like to avoid having the checks that low in
xfs_icache, but I don't see a way around that.

> The downsides here are the behavior might be a bit unclear and we'd
> have to fork off the flags bits in a manner that's clear and
> maintainable. I suppose one could also argue this is overkill for
> somewhat of a secondary operation.
>
> - Go the other direction, be less flexible and simply not allow
> !capable(CAP_SYS_ADMIN) group scans just as we started doing for
> project quotas. This is obviously very simple, but then we disallow
> regular users from trimming groups of inodes they should full well
> have permission to trim.

What about uid == self scans? Would we not allow those as well? The
check may be simpler than a group check but still would need to be per
inode, and thus still need the flags of option 1.

> I think I'm leaning towards the former approach if it can be
> implemented cleanly. Thoughts or ideas?

Well the former is certainly more functional and allows the trimming to
be under the users control. How useful is that though once it happens
automatically with your EDQUOT changes? If we only allowed the ioctl to
trigger global scans, we wouldn't need a conversion function nor
separate structure, but I don't know the use cases for uid/gid specific
scans from userspace so its hard for me to judge the tradeoffs.

Maybe this permission stuff should be a separate change since it isn't
really related to user namespace stuff? I just happened to be in the
vicinity and am happy to help :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
