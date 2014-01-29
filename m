Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B00E07F8A
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 13:20:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A35BAC009
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 11:20:27 -0800 (PST)
Date: Wed, 29 Jan 2014 11:20:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] A draft for making ext4 support project quota
Message-ID: <20140129192012.GB8798@birch.djwong.org>
References: <20140128064248.GA8653@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140128064248.GA8653@gmail.com>
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
To: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <pkuelelixi@gmail.com>, Dave Chinner <david@fromorbit.com>, Ben Myers <bpm@sgi.com>

On Tue, Jan 28, 2014 at 02:42:49PM +0800, Zheng Liu wrote:
> Hi all,
> 
> Here is a draft about ext4 project quota.  After discussed in another
> thread [1], I believe that we have reached a consensus for supporting
> project quota in ext4 and keep consistency with xfs.  Thus I write this
> draft.  As always, comments, suggestions and ideas are welcome.
> 
> 1. http://www.spinics.net/lists/linux-ext4/msg41275.html
> 
>                    Ext4 Project Quota (ver. 0.10)
> 
> Goal
> ====
> 
> The goal is to make ext4 support project quota which keeps the same
> behaviour with xfs.  After adding this new feature, we can support
> directory quota based on it.
> 
> Background
> ==========
> 
> The project quota is a quota mechanism can be used to implement a form
> of directory tree quota, where a specified directory and all of the
> files and subdirectories below it (i.e. a tree) can be restricted to
> using a subset of the available space in the filesystem [2].
> 
> *Note*
> Project quota is not directory quota.  Project quota is an aggregation
> of unrelated inodes with the same id (e.g. project id).  That means that
> some directories without the common parent directory could have the same
> id and are accounted as the same quota.
> 
> Currently xfs has supported project quota several years, and has a mature
> interface to manage project quota on kernel and userspace side.  After
> discusstion we believe that we should use the same quota API for project
> quota on ext4.  Now xfs_quota (userspace tool for managing xfs quota) is
> used to get/set/check project id, which communicates with kernel via
> ioctl(2).  For quota management, xfs_quota uses Q_X* via quotactl(2) to
> manipulate quota.  A XFS_DIFLAG_PROJINHERIT flag is defined in xfs to
> mark a directory that new file and direcotry created in this directory
> will get marked with this flag.
> 
> For project quota, the key issue is how to handle link(2)/rename(2).  We
> summarize the behaviour in xfs as following.
> 
> *Note*
> + unaccounted dir
> x accounted dir
> 
> link(2)
> -------
> 		+		x
> +		ok		error (EXDEV)
> x		ok		error (EXDEV)
> 
> rename(2)
> ---------
> 		+		x
> +		ok		ok
> x		wrong		ok
> 
> Further, project quota *cannot* be used with group quota at the same time.
> On the other hand user quota and project quota can be used simultaneously.
> 
> 2. http://xfs.org/index.php/XFS_FAQ#Q:_Quota:_What.27s_project_quota.3F
> 
> Design
> ======
> 
> Project id
> ----------
> We have two options to store project id in inode.  a) define a new member
> in ext4_inode structure; b) store project id in xattr.
> 
> Option a)
> Pros:
>   * Only need 4 bytes if we use a '__le32' type to store it
> 
> Cons:
>   * Needs to change disk layout of ext4 inode
> 
> Option b)
> Pros:
>   * Don't need to change disk layout
> 
> Cons:
>   * Take 24 bytes
> 
> Here I propose to use option *b)* because it is easy for us to support
> project id and we don't need to worry about changing disk layout.  But
> I raise another issue here.  Now inline_data feature has been applied.
> After waiting inline_data feature stable, we'd better enable inline_data
> feature by default when we create a new ext4 file system.  Now the inode
> size is 256 bytes by default, we have 72 bytes extra size to store
> inline data:
>   256 (default inode size) -
> 	156 (ext4_inode) + 4 (ext4_xattr_ibody_header) +
> 	20 (ext4_xattr_entry) + 4 (value) = 72
> 
> If we store project id in xattr, we just leave 48 bytes for inline data.
> I am not sure whether or not it is too small for some users.

Yeesh, that's not a lot of space. :)  I think I like enlarging the inode
better.  Or, reusing empty fields.  Does anyone actually use i_obso_faddr?
A quick Google search doesn't show any source code using it...

Are you introducing a new feature flag for this?  I suppose an INCOMPAT feature
would suffice to ward off anyone who /does/ use this field.

> When we store project id in xattr, we will use {get,set}fattr to get/set
> project id.  Thus we don't need to change userspace tool to manipulate
> project id.  Meanwhile a _INHERENT flag for inode needs to be defined to
> indicate that new directory creating in a directory with this flag will
> get the same project id and get marked with this flag.  
> 
> Project quota API
> -----------------
> For keeping consistency with xfs, here I propose to use Q_X* flag to
> communicate with kernel via quotactl(2) as we discussed.  Due to this we
> need to define some callback functions to support Q_X* flag.  That means
> that ext4 will support two quota flag sets for being compatible with
> legacy userspace tools and use the same quotactl API to communicate with
> kernel for project id like xfs.
> 
> Currently quota subsystem in vfs doesn't handle project quota.  Thus we
> need to make quota subsystem handle project id properly (e.g.
> dquot_transfer, dquot_initialize).  We need to define a new callback
> function in order to get project id.  Now in vfs we can access uid/gid
> directly from inode, but we have no way to get project id.  A generic
> callback function is defined to handle uid/gid.  The file system itself
> can handle project id.  Until now only ext4 needs to implement this
> callback function by itself because xfs doesn't use vfs quota subsystem.
> 
> For handling link(2)/rename(2) like xfs, we only allow hard link or
> rename operation when the project ids are the same.  Otherwise we will
> return EXDEV error to notify the user.
> 
> Quota-tools
> -----------
> Now quota-tools (e.g. quotaon, edquota, etc...) don't support project
> quota.  Thus we need to make it support project id.  I believe that Li
> Xi did some works on quota-tools.
> 
> E2fsprogs
> ---------
> After supporting project quota, we need to change e2fsck(1) to make sure
> that all sub-directories with _INHERENT flag have the same project id.
> Meanwhile we need to make chattr(1) set/clear _INHERENT flag.

I'm confused about the use of 'inherent' here -- since this flag establishes
that all files underneath it will have the same project ID, perhaps this flag
should be named "inherit" ?

(Also because the XFS flag is 'inherit', not 'inherent'.)

--D

> 
> Regards,
> 						- Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
