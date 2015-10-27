Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4D697F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 06:31:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 78B578F8033
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 04:31:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RqJfnG2eVBIDZp2A (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Oct 2015 04:31:36 -0700 (PDT)
Date: Tue, 27 Oct 2015 07:31:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
Message-ID: <20151027113133.GA26600@bfoster.bfoster>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
	<20151026213228.GI8773@dastard>
	<CAHc6FU68MYTGWKM5S14_dQBqXeebd2GwQcKj4RztLvPWL2eksA@mail.gmail.com>
	<20151027053045.GL8773@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151027053045.GL8773@dastard>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 27, 2015 at 04:30:45PM +1100, Dave Chinner wrote:
> On Tue, Oct 27, 2015 at 12:52:10AM +0100, Andreas Gruenbacher wrote:
> > On Mon, Oct 26, 2015 at 10:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > Really, I'm struggling to understand what the problem is with XFS
> > > doing translation to it's own special xattr names for ACLs
> > > underneath the posix layer.
> > 
> > Right now, setting one of the SGI_ACL attributes leads to stale i_acl
> > / i_default_acl fields and in the case of SGI_ACL_FILE, possibly to
> > outdated permissions in i_mode. You would get different information
> > from getfacl than what's stored on disk.
> 
> That's because we're not marking the cached acl as stale when
> setting the acl directly...
> 
> > > Yes, there's a caching issue when someone directly manipulates
> > > the underlying xattr,
> > 
> > "Directly manipulating" could be doing a setxattr of an attribute that
> > was previously retrieved by getxattr, like restoring a backup.
> 
> Sure, that's what xfsdump/restore effectively does.
> 
> > > but you need root to shoot yourself in the foot that way, and that is easily
> > > solveable.
> > 
> > What do you mean, it's easily solvable?
> 
> forget_all_cached_acls()
> 

This is essentially what the test patch I posted up thread does. Andreas
points out this is not sufficient because it doesn't update i_mode when
it is necessary based on the ACLs. To demonstrate:

Set an ACL and observe i_mode:

# touch /mnt/file
# ls -ali /mnt/file 
99 -rw-r--r-- 1 root root 0 Oct 27 06:48 /mnt/file
# setfacl -m u:fsgqa:rwx /mnt/file 
# ls -ali /mnt/file 
99 -rw-rwxr--+ 1 root root 0 Oct 27 06:48 /mnt/file

Grab the underlying xattr data:

# getfattr -m - -d /mnt/file 
getfattr: Removing leading '/' from absolute path names
# file: mnt/file
system.posix_acl_access=0sAgAAAAEABgD/////AgAHAOgDAAAEAAQA/////xAABwD/////IAAEAP////8=
trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAcAAAAAAAT/////AAQAAAAAABD/////AAcAAAAAACD/////AAQAAA==

Remove the ACL, observe i_mode reset:

# setfacl -x u:fsgqa /mnt/file 
# ls -ali /mnt/file 
99 -rw-r--r--+ 1 root root 0 Oct 27 06:49 /mnt/file

Set the xattr directly to re-add the ACL (we know the change is not
going to show up here due to the caching problem):

# setfattr -n trusted.SGI_ACL_FILE -v 0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAcAAAAAAAT/////AAQAAAAAABD/////AAcAAAAAACD/////AAQAAA== /mnt/file
# ls -ali /mnt/file 
99 -rw-r--r--+ 1 root root 0 Oct 27 06:49 /mnt/file

Remount, observe the ACL is back yet i_mode is still wrong:

# umount /mnt ; mount /dev/test/scratch /mnt/
# ls -ali /mnt/file 
99 -rw-r--r--+ 1 root root 0 Oct 27 06:49 /mnt/file
# getfacl /mnt/file 
getfacl: Removing leading '/' from absolute path names
# file: mnt/file
# owner: root
# group: root
user::rw-
user:fsgqa:rwx
group::r--
mask::rwx
other::r--

So it's permanently inconsistent afaics, at least until somebody uses
the proper ACL interface on that file. I'm not familiar enough with how
this mechanism works to know what the consequences of the i_mode
inconsistency are (e.g., after a remount)... Andreas?

Andreas,

Dave and I discussed this a bit on IRC yesterday, along with things like
the idea of starting to use the system.posix_acl_* names on disk
directly, just converting the xattr data, and transitioning the
trusted.SGI_ACL_* ACLs to be the virtual ACLs (as posix_acl_* are now).
The challenge with this is that we still need to provide backwards
compatibility for the SGI_ACL_* xattrs on disk for quite some time,
probably need a feature bit for the new xattr name, etc. Dave believes
it's not worth doing that to fix this problem. My preference is to fix
it however appropriate (with a feature bit, etc.) so we can eventually
kill the old mechanism, however long it must stay around.

I think we missed the fact that i_mode is not updated as demonstrated
above. If the consequences of that are explicit breakage (?), that would
make me feel even less bad about just disabling/changing a broken
mechanism, but we probably need more information on that. Regardless, I
think the lowest common denominator here is just to do what we're doing
in this series as is (with suggested code cleanups and whatnot) and fix
the SGI_ACL_* handlers to do the right thing, unless Dave chimes in
otherwise.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
