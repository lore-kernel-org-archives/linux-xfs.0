Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7AAAE7F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 10:14:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67155304039
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 08:14:00 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id rtOHQCcJysDnRZ10 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Jun 2013 08:13:59 -0700 (PDT)
Date: Fri, 21 Jun 2013 11:14:20 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130621111420.5592707e@oracle.com>
In-Reply-To: <20130620220311.GT29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
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
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On Fri, 21 Jun 2013 08:03:11 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jun 20, 2013 at 09:54:10AM -0400, Dwight Engen wrote:
> > On Thu, 20 Jun 2013 10:13:41 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > On Wed, Jun 19, 2013 at 11:09:48AM -0400, Dwight Engen wrote:
> > > > Use uint32 from init_user_ns for xfs internal uid/gid
> > > > representation in acl, xfs_icdinode. Conversion of kuid/gid is
> > > > done at the vfs boundary, other user visible xfs specific
> > > > interfaces (bulkstat, eofblocks filter) expect uint32
> > > > init_user_ns uid/gid values.
> > > 
> > > It's minimal, but I'm not sure it's complete. I'll comment on that
> > > in response to Eric's comments...
> ...
> > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > index 7f7be5f..8049976 100644
> > > > --- a/fs/xfs/xfs_inode.c
> > > > +++ b/fs/xfs/xfs_inode.c
> > > > @@ -1268,8 +1268,8 @@ xfs_ialloc(
> > > >  	ip->i_d.di_onlink = 0;
> > > >  	ip->i_d.di_nlink = nlink;
> > > >  	ASSERT(ip->i_d.di_nlink == nlink);
> > > > -	ip->i_d.di_uid = current_fsuid();
> > > > -	ip->i_d.di_gid = current_fsgid();
> > > > +	ip->i_d.di_uid = from_kuid(&init_user_ns,
> > > > current_fsuid());
> > > > +	ip->i_d.di_gid = from_kgid(&init_user_ns,
> > > > current_fsgid());
> > > 
> > > Why all new inodes be created in the init_user_ns? Shouldn't this
> > > be current_user_ns()?
> > 
> > current_fsuid() is the kuid_t from whatever userns current is in,
> 
> Yes.
> 
> > which we are converting to a flat uint32 since i_d is the on disk
> > inode.

I was incorrect here. current_fsuid() is the kuid_t from the
perspective of init_user_ns, so the value won't be different, just the
type.

> So, init_user_ns is actually the target namespace of the conversion,
> not the namespace we are converting *from*?
> 
> <sigh>
> 
> I *knew* this was going to happen when I first saw this code:
> 
> http://www.spinics.net/lists/netdev/msg209217.html
> 
> "For those of us that have to look at it once every few months,
> following the same conventions as all the other code in the kernel
> (i.e. kqid_to_id()) tells me everything I need to know without
> having to go through the process of looking up the unusual
> from_kqid() function and then from_kuid() to find out what it is
> actually doing...."
> 
> Here I am, several months later and trying to work out what the damn
> conversion from_kgid() and make_kuid() are supposed to be doing and
> trying to work out if it is correct or not...
> 
> > This field is then used in xfs_setup_inode() to populate
> > VFS_I(ip)->i_uid.
> 
> But that then uses make_kuid(&init_user_ns, ip->i_d.di_uid) which
> according to the documentation creates a kuid in the init_user_ns,
> not in the current user namespace.

Right, inside the kernel uids are all interpreted within
init_user_ns context and are only converted to a different value if the
caller is in some other userns at the kernel/user boundary (ie.
cp_compat_stat()). Maybe it is more clear to say that init_user_ns is
the "flat 32bit uid space" and thus has a mapping for every uid. So
the value in init_user_ns will actually be equal to the di_uid value.

> So if we then do uid_eq(current_fsuid(), VFS_I(ip)->i_uid) on the
> newly created and initialised inode they are different, yes? If they
> are different, then this code is not correct....

No they should equal because xfs_setup_inode() maps it back, see below.

> > Most other filesystems would use inode_init_owner(),
> > but xfs does not (I assume because it wants to handle SGID itself
> > based on XFS_INHERIT_GID and irix_sgid_inherit).
> 
> No, XFS doesn't use inode_init_owner() because we are initialising
> the on disk XFS inode here, not the VFS struct inode...

Right, but I was referring to xfs_setup_inode() which is setting up the
VFS inode. It is called in both the from disk and new inode paths, and
sets the VFS inode uid based on the value in the disk inode. I was
trying to show that in the new inode path the VFS inode uid is being
initialized the same as on other filesystems (ie from current_fsuid()),
but with an extra step just because of "conversion" to and back from
init_user_ns. The call sequence in xfs:

  xfs_ialloc():
    current_fsuid() -> from_kuid() -> di_uid
  xfs_setup_inode():
    di_uid -> make_kuid() -> inode.i_uid == current_fsuid()

Sorry, I think my first explanation wasn't clear, hopefully this is.

> > > > @@ -1172,8 +1174,8 @@ xfs_setup_inode(
> > > >  
> > > >  	inode->i_mode	= ip->i_d.di_mode;
> > > >  	set_nlink(inode, ip->i_d.di_nlink);
> > > > -	inode->i_uid	= ip->i_d.di_uid;
> > > > -	inode->i_gid	= ip->i_d.di_gid;
> > > > +	inode->i_uid	= make_kuid(&init_user_ns,
> > > > ip->i_d.di_uid);
> > > > +	inode->i_gid	= make_kgid(&init_user_ns,
> > > > ip->i_d.di_gid);
> > > 
> > > current name space?
> > 
> > I believe that is what this is doing, but I think it will be more
> > proper to do it the same as other filesystems:
> > 
> > i_uid_write(inode, ip->i_d.di_uid);
> > i_gid_write(inode, ip->i_d.di_gid);
> 
> Sure, but that's still creating the uids/gids in the init_user_ns,
> so it doesn't solve my confusion about *why* this is being done.
> There's no documentation as to how this stuff is supposed to work,
> so I can't find out for myself. I'm not one for cargo-cult
> copy-n-paste development - I like to understand why something is
> done before copying it...
> 
> So, to prevent me from wondering what it is doing in another 6
> months time, can you add a set of helper functions that are named:
> 
> xfs_kuid_to_disk()
> xfs_kuid_from_disk()
> xfs_kgid_to_disk()
> xfs_kgid_from_disk()
> 
> and document why we are using the namespaces that are being used,
> and then use them where we convert to/from the different inode
> structures?

Sure I can take a shot at that, and I'm guessing you would prefer to use

inode->i_uid = xfs_kuid_from_disk(ip->i_d.di_uid);

over

i_uid_write(inode, ip->i_d.di_uid);

> FWIW, what happens when ip->i_d.di_gid doesn't have a mapping in the
> current namespace, and make_kuid/make_kgid return
> INVALID_UID/INVALID_GID? Is this is going to happen, and if it does
> what do we need to do about it? That will need to be added to the
> comments, too.

I don't think it will happen here because init_user_ns has a mapping
for all values. Where it can happen is when there is a conversion to
some subset userns, that doesn't have a mapping for the value.
 
> At least if we get this done, XFS people will be able to tell at a
> glance that the XFs code is doing the right thing w.r.t namespace
> conversion...
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
