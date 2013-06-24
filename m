Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 998A27F3F
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 19:33:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 87BFD8F8033
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 17:33:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0Q5nx8we0ysudLCP for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 17:33:20 -0700 (PDT)
Date: Mon, 24 Jun 2013 10:33:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130624003316.GH29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130621111420.5592707e@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On Fri, Jun 21, 2013 at 11:14:20AM -0400, Dwight Engen wrote:
> On Fri, 21 Jun 2013 08:03:11 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Thu, Jun 20, 2013 at 09:54:10AM -0400, Dwight Engen wrote:
> > > On Thu, 20 Jun 2013 10:13:41 +1000
> > > Dave Chinner <david@fromorbit.com> wrote:
> > > 
> > > > On Wed, Jun 19, 2013 at 11:09:48AM -0400, Dwight Engen wrote:
> > > > > Use uint32 from init_user_ns for xfs internal uid/gid
> > > > > representation in acl, xfs_icdinode. Conversion of kuid/gid is
> > > > > done at the vfs boundary, other user visible xfs specific
> > > > > interfaces (bulkstat, eofblocks filter) expect uint32
> > > > > init_user_ns uid/gid values.
> > > > 
> > > > It's minimal, but I'm not sure it's complete. I'll comment on that
> > > > in response to Eric's comments...
> > ...
> > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > index 7f7be5f..8049976 100644
> > > > > --- a/fs/xfs/xfs_inode.c
> > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > @@ -1268,8 +1268,8 @@ xfs_ialloc(
> > > > >  	ip->i_d.di_onlink = 0;
> > > > >  	ip->i_d.di_nlink = nlink;
> > > > >  	ASSERT(ip->i_d.di_nlink == nlink);
> > > > > -	ip->i_d.di_uid = current_fsuid();
> > > > > -	ip->i_d.di_gid = current_fsgid();
> > > > > +	ip->i_d.di_uid = from_kuid(&init_user_ns,
> > > > > current_fsuid());
> > > > > +	ip->i_d.di_gid = from_kgid(&init_user_ns,
> > > > > current_fsgid());
> > > > 
> > > > Why all new inodes be created in the init_user_ns? Shouldn't this
> > > > be current_user_ns()?
> > > 
> > > current_fsuid() is the kuid_t from whatever userns current is in,
> > 
> > Yes.
> > 
> > > which we are converting to a flat uint32 since i_d is the on disk
> > > inode.
> 
> I was incorrect here. current_fsuid() is the kuid_t from the
> perspective of init_user_ns, so the value won't be different, just the
> type.

I guess I'm not the only that is easily confused by this convoluted,
badly documented namespace conversion crap either....

> > So, init_user_ns is actually the target namespace of the conversion,
> > not the namespace we are converting *from*?
> > 
> > <sigh>
> > 
> > I *knew* this was going to happen when I first saw this code:
> > 
> > http://www.spinics.net/lists/netdev/msg209217.html
> > 
> > "For those of us that have to look at it once every few months,
> > following the same conventions as all the other code in the kernel
> > (i.e. kqid_to_id()) tells me everything I need to know without
> > having to go through the process of looking up the unusual
> > from_kqid() function and then from_kuid() to find out what it is
> > actually doing...."
> > 
> > Here I am, several months later and trying to work out what the damn
> > conversion from_kgid() and make_kuid() are supposed to be doing and
> > trying to work out if it is correct or not...
> > 
> > > This field is then used in xfs_setup_inode() to populate
> > > VFS_I(ip)->i_uid.
> > 
> > But that then uses make_kuid(&init_user_ns, ip->i_d.di_uid) which
> > according to the documentation creates a kuid in the init_user_ns,
> > not in the current user namespace.
> 
> Right, inside the kernel uids are all interpreted within
> init_user_ns context and are only converted to a different value if the
> caller is in some other userns at the kernel/user boundary (ie.
> cp_compat_stat()). Maybe it is more clear to say that init_user_ns is
> the "flat 32bit uid space" and thus has a mapping for every uid. So
> the value in init_user_ns will actually be equal to the di_uid value.

If that's the case, then why the hell do filesystems need to know
*anything* about namespaces and conversions? It shoul dbe
*completely* hidden from filesystem code with simple wrappers rather
than open coding init_user_ns conversions everywhere....

Indeed, for updating or getting the uid/gid from the struct inode
there are these helpers:

i_uid_read/i_uid_write
i_gid_read/i_uid_write

but there's nothing generic for the filesystems to use that just
take a kuid_t/kgid_t and return a raw value or vice versa. Nice.

> > So if we then do uid_eq(current_fsuid(), VFS_I(ip)->i_uid) on the
> > newly created and initialised inode they are different, yes? If they
> > are different, then this code is not correct....
> 
> No they should equal because xfs_setup_inode() maps it back, see below.
> 
> > > Most other filesystems would use inode_init_owner(),
> > > but xfs does not (I assume because it wants to handle SGID itself
> > > based on XFS_INHERIT_GID and irix_sgid_inherit).
> > 
> > No, XFS doesn't use inode_init_owner() because we are initialising
> > the on disk XFS inode here, not the VFS struct inode...
> 
> Right, but I was referring to xfs_setup_inode() which is setting up the
> VFS inode. It is called in both the from disk and new inode paths, and
> sets the VFS inode uid based on the value in the disk inode.

So perhaps your comment was in the wrong place? ;)

> I was
> trying to show that in the new inode path the VFS inode uid is being
> initialized the same as on other filesystems (ie from current_fsuid()),
> but with an extra step just because of "conversion" to and back from
> init_user_ns. The call sequence in xfs:
> 
>   xfs_ialloc():
>     current_fsuid() -> from_kuid() -> di_uid

	ip->i_d.di_uid = xfs_kuid_to_disk(current_fsuid());

>   xfs_setup_inode():
>     di_uid -> make_kuid() -> inode.i_uid == current_fsuid()

	inode->i_uid = xfs_kuid_from_disk(ip->i_d.di_uid);


> Sorry, I think my first explanation wasn't clear, hopefully this is.

Well, it's taken me another hour of battling through the
undocumented crap that is this namespace code starting from
setuid(), but I understand the conversions being done now. I dislike
the implementation even more now, and I'm still wondering what the
hell we are supposed to do with bulkstat, filehandles and stuff like
xfs_fsr, backups, etc...

> > So, to prevent me from wondering what it is doing in another 6
> > months time, can you add a set of helper functions that are named:
> > 
> > xfs_kuid_to_disk()
> > xfs_kuid_from_disk()
> > xfs_kgid_to_disk()
> > xfs_kgid_from_disk()
> > 
> > and document why we are using the namespaces that are being used,
> > and then use them where we convert to/from the different inode
> > structures?
> 
> Sure I can take a shot at that, and I'm guessing you would prefer to use
> 
> inode->i_uid = xfs_kuid_from_disk(ip->i_d.di_uid);
> 
> over
> 
> i_uid_write(inode, ip->i_d.di_uid);

Yes, because i_uid_write() is not a generic helper function, and we
convert to/from disk format in many places where we aren't actually
reading/writing the struct inode. i.e. I don't see any reason at all
for having the variable init_user_ns anywhere in the XFS code
except than in those wrapper functions....

> > FWIW, what happens when ip->i_d.di_gid doesn't have a mapping in the
> > current namespace, and make_kuid/make_kgid return
> > INVALID_UID/INVALID_GID? Is this is going to happen, and if it does
> > what do we need to do about it? That will need to be added to the
> > comments, too.
> 
> I don't think it will happen here because init_user_ns has a mapping
> for all values. Where it can happen is when there is a conversion to
> some subset userns, that doesn't have a mapping for the value.

Yup, understood.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
