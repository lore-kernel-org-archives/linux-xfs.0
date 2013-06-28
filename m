Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C4A7D7F4E
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 09:23:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 893D4304075
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 07:23:28 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id c3gKqsGbrBXsR5l3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 07:23:27 -0700 (PDT)
Date: Fri, 28 Jun 2013 10:23:22 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130628102322.74eef70f@oracle.com>
In-Reply-To: <20130626020924.GD29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On Wed, 26 Jun 2013 12:09:24 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jun 24, 2013 at 09:10:35AM -0400, Dwight Engen wrote:
> > Hi Dave, all. Here is a v2 patch that I believe addresses the
> > previous comments, but I expect there to be more :) I think there
> > are a few more issues to sort out before this is ready, and I want
> > to add some tests to xfstests also.
> > 
> > I added permission checks for eofblocks in the ioctl code, but
> > I don't think they are enough. Just because an unprivileged
> > caller is in a group doesn't mean he can write to a file of that
> > group, and I don't know how we can check for that till we get the
> > inode in hand. Brian, if you or anyone else could comment on how
> > this should work for the regular user and write() ENOSPC cases
> > that'd be great.
> > 
> > The xfs code now uses inode->i_uid where possible instead of di_uid.
> > The remaining uses of di_uid are where the inode is being setup,
> > conversion to/from disk endianess, in dealing with quotas, and
> > bulkstat.
> 
> Hi Dwight,
> 
> I haven't looked at the code in detail, I'll just mention that I
> agree with Brain that we need to split this up into more patches.
> The conversions are subtle and easy to misunderstand, so small
> patches are good.  I'd say at minimum separate patches are needed
> for:
> 
> 	- permissions check on eof blocks
> 	- splitting eof blocks structure (I made comments on that to
> 	  Brain's posted patch)
> 	- introduce XFS conversion helpers
> 	- implement VFS-XFS boundary conversion using helpers
> 	- XFS ioctl conversions (maybe multiple patches)
> 	- final patch to modify kconfig once everything is done
> 
> > We do need to decide on the di_uid that comes back from bulkstat.
> > Right now it is returning on disk (== init_user_ns) uids. It looks
> > to me like xfsrestore is using the normal vfs routines (chown,
> > fchown, lchown) when restoring so that won't line up if the
> > xfsrestore is run in !init_user_ns.
> 
> Right. This is a major problem because there's no guarantee that you
> are running restore in the same namespace as dump was run in. If you
> take the dump in the init_user_ns, then you can't restore it from
> inside the namespace container, and vice versa.
> 
> > We could possibly convert to userns values
> > before returning them from the kernel, but I doubt that will work
> > well with the xfs quotas.
> 
> Well, quotas are already converted to/from userns specific values
> before they get to XFS. Including project quotas, which I think at
> this point is wrong. We have no test cases for it, though, so I
> can't validate that it actually works as it is supposed to and that
> we don't break it inadvertantly in the future.
> 
> [ I'm still waiting on Eric to provide any information or scripts
> for how he tested this all worked when he did the conversions.... ]
> 
> > Should we just require that callers of bulkstat
> > be in init_user_ns? Thoughts?
> 
> This is one of the reasons why I want Eric to give us some idea of
> how this is supposed to work - exactly how is backup and restore
> supposed to be managed on a shared filesystem that is segmented up
> into multiple namespace containers? We can talk about the
> implementation all we like, but none of us have a clue to the policy
> decisions that users will make that we need to support. Until we
> have a clear idea on what policies we are supposed to be supporting,
> the implementation will be ambiguous and compromised.
> 
> e.g. If users are responsible for it, then bulkstat needs to filter
> based on the current namespace. If management is responsible (i.e.
> init_user_ns does backup/restore of ns-specific subtrees), then
> bulkstat cannot filter and needs to reject calls from outside the
> init_user_ns().

Hi, in thinking about this a bit more, I'm not sure why bulkstat should
be any different than stat(2). If you stat a file not covered by your
current_user_ns(), it doesn't "filter" and return ENOENT, it just
returns it as overflowuid (65534). Filtering bulkstat also has other
(performance) problems as you pointed out, and we cannot easily filter
XFS_IOC_FSINUMBERS anyway.

I don't think the user namespace is intended to subpartition the
set of inodes available from a filesystem, but only to remap the id
values. It then seems like the only policy that can reliably be
supported today is to backup/restore from init_user_ns, or if you want
to backup/restore in a sub user ns, you must know ahead of time that you
will not encounter ids outside your mapping in the fs/backup media.

> But if we have to allow both configurations - which I think we have to
> because both cases are valid choices for a hosting provider to give
> users - then how are we supposed to implement/handle this?
> 
> The same goes for the file handle interfaces - it's perfectly valid
> for a user to run a userspace NFS server (e.g. ganesha) inside a
> namespace container, but that will allow that process to provide
> unchecked remote access to the entire underlying filesystem, not
> just the namespace being exported. i.e. fs/export.c needs to be made
> namespace aware in some way so that there is a kernel wide policy
> for handle to file translations in namespace containers....

So I looked at open_by_handle_at(2) and it looks to me like it is no
different than regular open(2) wrt the user namespace checks. The code
paths become common at path_openat(). Note that there is no check for
kuid_has_mapping(current_user_ns(), inode->i_uid) so an inode doesn't
have to be covered by the current user ns in order to get it opened,
the caller just has to pass the inode_permission() checks. I guess I
don't see the "unchecked" part, could you elaborate on that?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
