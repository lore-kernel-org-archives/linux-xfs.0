Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 091C47F90
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 04:54:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68184AC004
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 02:53:57 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id wMHYYcG5ZqC0bcWj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 02:53:54 -0800 (PST)
Date: Wed, 29 Jan 2014 11:53:51 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] A draft for making ext4 support project quota
Message-ID: <20140129105351.GA8749@quack.suse.cz>
References: <20140128064248.GA8653@gmail.com>
	<20140128143514.GB13676@quack.suse.cz>
	<20140129034824.GA12757@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140129034824.GA12757@gmail.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>

On Wed 29-01-14 11:48:25, Zheng Liu wrote:
> On Tue, Jan 28, 2014 at 03:35:14PM +0100, Jan Kara wrote:
> > On Tue 28-01-14 14:42:49, Zheng Liu wrote:
> > > Hi all,
> > > 
> > > Here is a draft about ext4 project quota.  After discussed in another
> > > thread [1], I believe that we have reached a consensus for supporting
> > > project quota in ext4 and keep consistency with xfs.  Thus I write this
> > > draft.  As always, comments, suggestions and ideas are welcome.
> > > 
> > > 1. http://www.spinics.net/lists/linux-ext4/msg41275.html
> > > 
> > >                    Ext4 Project Quota (ver. 0.10)
> > > 
> > > Goal
> > > ====
> > > 
> > > The goal is to make ext4 support project quota which keeps the same
> > > behaviour with xfs.  After adding this new feature, we can support
> > > directory quota based on it.
> > > 
> > > Background
> > > ==========
> > > 
> > > The project quota is a quota mechanism can be used to implement a form
> > > of directory tree quota, where a specified directory and all of the
> > > files and subdirectories below it (i.e. a tree) can be restricted to
> > > using a subset of the available space in the filesystem [2].
> > > 
> > > *Note*
> > > Project quota is not directory quota.  Project quota is an aggregation
> > > of unrelated inodes with the same id (e.g. project id).  That means that
> > > some directories without the common parent directory could have the same
> > > id and are accounted as the same quota.
> > > 
> > > Currently xfs has supported project quota several years, and has a mature
> > > interface to manage project quota on kernel and userspace side.  After
> > > discusstion we believe that we should use the same quota API for project
> > > quota on ext4.  Now xfs_quota (userspace tool for managing xfs quota) is
> > > used to get/set/check project id, which communicates with kernel via
> > > ioctl(2).  For quota management, xfs_quota uses Q_X* via quotactl(2) to
> > > manipulate quota.  A XFS_DIFLAG_PROJINHERIT flag is defined in xfs to
> > > mark a directory that new file and direcotry created in this directory
> > > will get marked with this flag.
> > > 
> > > For project quota, the key issue is how to handle link(2)/rename(2).  We
> > > summarize the behaviour in xfs as following.
> > > 
> > > *Note*
> > > + unaccounted dir
> > > x accounted dir
> > > 
> > > link(2)
> > > -------
> > > 		+		x
> > > +		ok		error (EXDEV)
> > > x		ok		error (EXDEV)
> > > 
> > > rename(2)
> > > ---------
> > > 		+		x
> > > +		ok		ok
> > > x		wrong		ok
> >   So moving unaccounted file/dir into an accounted dir would be OK? How is
> > that?
> 
> Actually xfs will return EXDEV error when we try to move unaccounted
> file/dir into an accounted dir.  Then userspace tools (e.g. mv(1)) will
> use create(2)/read(2)/write(2) syscalls to create these files/dirs from
> scratch, and get the same id from their parent.  So from the result we
> can see it is ok.  Quote from Dave Chinner's comment: "that quota is
> accounted for when moving *into* an accounted directory tree, not when
> moving out of a directory tree."
  OK, so if we return EXDEV then I'm fine with it. Letting rename succeed
would be messy (as it would break the tree inheritance of project id).

> > > 2. http://xfs.org/index.php/XFS_FAQ#Q:_Quota:_What.27s_project_quota.3F
> > > 
> > > Design
> > > ======
> > > 
> > > Project id
> > > ----------
> > > We have two options to store project id in inode.  a) define a new member
> > > in ext4_inode structure; b) store project id in xattr.
> > > 
> > > Option a)
> > > Pros:
> > >   * Only need 4 bytes if we use a '__le32' type to store it
> > > 
> > > Cons:
> > >   * Needs to change disk layout of ext4 inode
> > > 
> > > Option b)
> > > Pros:
> > >   * Don't need to change disk layout
> > > 
> > > Cons:
> > >   * Take 24 bytes
> >   Cons of the b) is also that it's somewhat messier to get / set project id
> > from kernel. So I'm more in favor of a). I even think we could introduce
> > the additional id rather seamlessly using i_extra_i_size but I have to have
> > a look into details. Anyway I guess we can talk about the options at LSF.
> 
> I don't have a bias against both of two options.  It seems that we can
> introduce a new id seamlessly using i_extra_isize.
> 
> 1) old kernel + new disk layout
> We can read/write new inode because new id doesn't be changed.
  old kernel + new disk layout will have to be read-only mount. Similarly
to other quota features.

> 2) new kernel + old disk layout
> We can use EXT4_FITS_IN_INODE to check whether new id can fit into an
> inode or not.  We will check and report error when we try to enable
> project quota on a file system with old disk layout in ext4_fill_super().
  I expect tune2fs will be used to enable project quota feature. So it can
refuse to enable the feature when inode isn't large enough to allow it.

> > > Here I propose to use option *b)* because it is easy for us to support
> > > project id and we don't need to worry about changing disk layout.  But
> > > I raise another issue here.  Now inline_data feature has been applied.
> > > After waiting inline_data feature stable, we'd better enable inline_data
> > > feature by default when we create a new ext4 file system.  Now the inode
> > > size is 256 bytes by default, we have 72 bytes extra size to store
> > > inline data:
> > >   256 (default inode size) -
> > > 	156 (ext4_inode) + 4 (ext4_xattr_ibody_header) +
> > > 	20 (ext4_xattr_entry) + 4 (value) = 72
> > > 
> > > If we store project id in xattr, we just leave 48 bytes for inline data.
> > > I am not sure whether or not it is too small for some users.
> > > 
> > > When we store project id in xattr, we will use {get,set}fattr to get/set
> > > project id.  Thus we don't need to change userspace tool to manipulate
> > > project id.  Meanwhile a _INHERENT flag for inode needs to be defined to
> > > indicate that new directory creating in a directory with this flag will
> > > get the same project id and get marked with this flag.  
> > > 
> > > Project quota API
> > > -----------------
> > > For keeping consistency with xfs, here I propose to use Q_X* flag to
> > > communicate with kernel via quotactl(2) as we discussed.  Due to this we
> > > need to define some callback functions to support Q_X* flag.  That means
> > > that ext4 will support two quota flag sets for being compatible with
> > > legacy userspace tools and use the same quotactl API to communicate with
> > > kernel for project id like xfs.
> >   We can as well extend current VFS API to cover also project quotas. That
> > would make things somewhat more logical from userspace POV. 
> 
> Your meaning is that we support Q_* flag and Q_X* flag simultaneously?
  Well, kernel quota interface does support both sets of flags. It calls
different callbacks for e.g. Q_GETQUOTA and Q_XGETQUOTA though. And for
ext4 it is more natural to have the callback for Q_GETQUOTA called since
that's what it uses for user and group quotas. So I meant we can extend
e.g. Q_GETQUOTA to also handle project quotas, not only user and group
quotas.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
