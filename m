Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C51967FA5
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 21:43:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D2AAAC004
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 19:43:50 -0800 (PST)
Received: from mail-pb0-f46.google.com (mail-pb0-f46.google.com
	[209.85.160.46]) by cuda.sgi.com with ESMTP id WEpBSmp9r1AYzho7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jan 2014 19:43:48 -0800 (PST)
Received: by mail-pb0-f46.google.com with SMTP id um1so1215605pbc.19
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 19:43:47 -0800 (PST)
Date: Wed, 29 Jan 2014 11:48:25 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC] A draft for making ext4 support project quota
Message-ID: <20140129034824.GA12757@gmail.com>
References: <20140128064248.GA8653@gmail.com>
	<20140128143514.GB13676@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140128143514.GB13676@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Tue, Jan 28, 2014 at 03:35:14PM +0100, Jan Kara wrote:
> On Tue 28-01-14 14:42:49, Zheng Liu wrote:
> > Hi all,
> > 
> > Here is a draft about ext4 project quota.  After discussed in another
> > thread [1], I believe that we have reached a consensus for supporting
> > project quota in ext4 and keep consistency with xfs.  Thus I write this
> > draft.  As always, comments, suggestions and ideas are welcome.
> > 
> > 1. http://www.spinics.net/lists/linux-ext4/msg41275.html
> > 
> >                    Ext4 Project Quota (ver. 0.10)
> > 
> > Goal
> > ====
> > 
> > The goal is to make ext4 support project quota which keeps the same
> > behaviour with xfs.  After adding this new feature, we can support
> > directory quota based on it.
> > 
> > Background
> > ==========
> > 
> > The project quota is a quota mechanism can be used to implement a form
> > of directory tree quota, where a specified directory and all of the
> > files and subdirectories below it (i.e. a tree) can be restricted to
> > using a subset of the available space in the filesystem [2].
> > 
> > *Note*
> > Project quota is not directory quota.  Project quota is an aggregation
> > of unrelated inodes with the same id (e.g. project id).  That means that
> > some directories without the common parent directory could have the same
> > id and are accounted as the same quota.
> > 
> > Currently xfs has supported project quota several years, and has a mature
> > interface to manage project quota on kernel and userspace side.  After
> > discusstion we believe that we should use the same quota API for project
> > quota on ext4.  Now xfs_quota (userspace tool for managing xfs quota) is
> > used to get/set/check project id, which communicates with kernel via
> > ioctl(2).  For quota management, xfs_quota uses Q_X* via quotactl(2) to
> > manipulate quota.  A XFS_DIFLAG_PROJINHERIT flag is defined in xfs to
> > mark a directory that new file and direcotry created in this directory
> > will get marked with this flag.
> > 
> > For project quota, the key issue is how to handle link(2)/rename(2).  We
> > summarize the behaviour in xfs as following.
> > 
> > *Note*
> > + unaccounted dir
> > x accounted dir
> > 
> > link(2)
> > -------
> > 		+		x
> > +		ok		error (EXDEV)
> > x		ok		error (EXDEV)
> > 
> > rename(2)
> > ---------
> > 		+		x
> > +		ok		ok
> > x		wrong		ok
>   So moving unaccounted file/dir into an accounted dir would be OK? How is
> that?

Actually xfs will return EXDEV error when we try to move unaccounted
file/dir into an accounted dir.  Then userspace tools (e.g. mv(1)) will
use create(2)/read(2)/write(2) syscalls to create these files/dirs from
scratch, and get the same id from their parent.  So from the result we
can see it is ok.  Quote from Dave Chinner's comment: "that quota is
accounted for when moving *into* an accounted directory tree, not when
moving out of a directory tree."

> 
> > Further, project quota *cannot* be used with group quota at the same time.
> > On the other hand user quota and project quota can be used simultaneously.
>   There's no fundamental reason for this and XFS folks actually recently
> worked to remove this limitation. I don't think we should carry it over to
> ext4.

Thanks for pointing it out.

> 
> > 2. http://xfs.org/index.php/XFS_FAQ#Q:_Quota:_What.27s_project_quota.3F
> > 
> > Design
> > ======
> > 
> > Project id
> > ----------
> > We have two options to store project id in inode.  a) define a new member
> > in ext4_inode structure; b) store project id in xattr.
> > 
> > Option a)
> > Pros:
> >   * Only need 4 bytes if we use a '__le32' type to store it
> > 
> > Cons:
> >   * Needs to change disk layout of ext4 inode
> > 
> > Option b)
> > Pros:
> >   * Don't need to change disk layout
> > 
> > Cons:
> >   * Take 24 bytes
>   Cons of the b) is also that it's somewhat messier to get / set project id
> from kernel. So I'm more in favor of a). I even think we could introduce
> the additional id rather seamlessly using i_extra_i_size but I have to have
> a look into details. Anyway I guess we can talk about the options at LSF.

I don't have a bias against both of two options.  It seems that we can
introduce a new id seamlessly using i_extra_isize.

1) old kernel + new disk layout
We can read/write new inode because new id doesn't be changed.

2) new kernel + old disk layout
We can use EXT4_FITS_IN_INODE to check whether new id can fit into an
inode or not.  We will check and report error when we try to enable
project quota on a file system with old disk layout in ext4_fill_super().

> 
> > Here I propose to use option *b)* because it is easy for us to support
> > project id and we don't need to worry about changing disk layout.  But
> > I raise another issue here.  Now inline_data feature has been applied.
> > After waiting inline_data feature stable, we'd better enable inline_data
> > feature by default when we create a new ext4 file system.  Now the inode
> > size is 256 bytes by default, we have 72 bytes extra size to store
> > inline data:
> >   256 (default inode size) -
> > 	156 (ext4_inode) + 4 (ext4_xattr_ibody_header) +
> > 	20 (ext4_xattr_entry) + 4 (value) = 72
> > 
> > If we store project id in xattr, we just leave 48 bytes for inline data.
> > I am not sure whether or not it is too small for some users.
> > 
> > When we store project id in xattr, we will use {get,set}fattr to get/set
> > project id.  Thus we don't need to change userspace tool to manipulate
> > project id.  Meanwhile a _INHERENT flag for inode needs to be defined to
> > indicate that new directory creating in a directory with this flag will
> > get the same project id and get marked with this flag.  
> > 
> > Project quota API
> > -----------------
> > For keeping consistency with xfs, here I propose to use Q_X* flag to
> > communicate with kernel via quotactl(2) as we discussed.  Due to this we
> > need to define some callback functions to support Q_X* flag.  That means
> > that ext4 will support two quota flag sets for being compatible with
> > legacy userspace tools and use the same quotactl API to communicate with
> > kernel for project id like xfs.
>   We can as well extend current VFS API to cover also project quotas. That
> would make things somewhat more logical from userspace POV. 

Your meaning is that we support Q_* flag and Q_X* flag simultaneously?

Thanks,
                                                - Zheng

> 
> > Currently quota subsystem in vfs doesn't handle project quota.  Thus we
> > need to make quota subsystem handle project id properly (e.g.
> > dquot_transfer, dquot_initialize).  We need to define a new callback
> > function in order to get project id.  Now in vfs we can access uid/gid
> > directly from inode, but we have no way to get project id.  A generic
> > callback function is defined to handle uid/gid.  The file system itself
> > can handle project id.  Until now only ext4 needs to implement this
> > callback function by itself because xfs doesn't use vfs quota subsystem.
>   So we need to get ids from external structures only in two places. One is
> dquot_initialize() and the other is dquot_transfer(). Instead of providing
> callback to get project id, we could just create a variant of these functions
> which will get required ids from a passed array instead of directly from
> the inode.
> 
> > For handling link(2)/rename(2) like xfs, we only allow hard link or
> > rename operation when the project ids are the same.  Otherwise we will
> > return EXDEV error to notify the user.
> > 
> > Quota-tools
> > -----------
> > Now quota-tools (e.g. quotaon, edquota, etc...) don't support project
> > quota.  Thus we need to make it support project id.  I believe that Li
> > Xi did some works on quota-tools.
> > 
> > E2fsprogs
> > ---------
> > After supporting project quota, we need to change e2fsck(1) to make sure
> > that all sub-directories with _INHERENT flag have the same project id.
> > Meanwhile we need to make chattr(1) set/clear _INHERENT flag.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
