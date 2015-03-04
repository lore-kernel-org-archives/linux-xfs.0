Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E88907F4E
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 07:01:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B950D8F806F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 05:01:03 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eBtw1WDBVmv4JApg for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 05:01:01 -0800 (PST)
Date: Thu, 5 Mar 2015 00:01:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: add DAX file operations support
Message-ID: <20150304130100.GU18360@dastard>
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
	<1425425427-16283-4-git-send-email-david@fromorbit.com>
	<54F6D9E4.9050803@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F6D9E4.9050803@gmail.com>
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
To: Boaz Harrosh <openosd@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Wed, Mar 04, 2015 at 12:09:40PM +0200, Boaz Harrosh wrote:
> On 03/04/2015 01:30 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add the initial support for DAX file operations to XFS. This
> > includes the necessary block allocation and mmap page fault hooks
> > for DAX to function.
> > 
> > Note that the current block allocation code abuses the mapping
> > buffer head to provide a completion callback for unwritten extent
> > allocation when DAX is clearing blocks. The DAX interface needs to
> > be changed to provide a callback similar to get_blocks for this
> > callback.
> 
> It looks like this comment is stale for this set
> 
> A question below
.....

> >  	.fsync		= xfs_dir_fsync,
> >  };
> >  
> > -static const struct vm_operations_struct xfs_file_vm_ops = {
> > -	.fault		= xfs_filemap_fault,
> > -	.map_pages	= filemap_map_pages,
> > -	.page_mkwrite	= xfs_filemap_page_mkwrite,
> > +#ifdef CONFIG_FS_DAX
> > +const struct file_operations xfs_file_dax_operations = {
> > +	.llseek		= xfs_file_llseek,
> > +	.read		= new_sync_read,
> > +	.write		= new_sync_write,
> > +	.read_iter	= xfs_file_read_iter,
> > +	.write_iter	= xfs_file_write_iter,
> > +	.unlocked_ioctl	= xfs_file_ioctl,
> > +#ifdef CONFIG_COMPAT
> > +	.compat_ioctl	= xfs_file_compat_ioctl,
> > +#endif
> > +	.mmap		= xfs_file_mmap,
> > +	.open		= xfs_file_open,
> > +	.release	= xfs_file_release,
> > +	.fsync		= xfs_file_fsync,
> > +	.fallocate	= xfs_file_fallocate,
> >  };
> 
> sigh, The same problem was in ext4, the reason you need
> a second xfs_file_operations vector is because of the minus
> 	.splice_read	= xfs_file_splice_read,
> 	.splice_write	= iter_file_splice_write,
> Which do not exist for DAX

Right, because they use buffered IO, and DAX doesn't do buffered
IO.

> Would it be cleaner to call default_file_splice_write/read
> directly from xfs_file_splice_read/write in the DAX case
> and only keep one vector?

Umm, looking at the code, that is different ot what I remember. it
used to be if the filesystem did not support splice, then it did not
set a vector. That has changed - it now calls a generic splice path
instead.

So, we definitely need splice to/from DAX enabled inodes to be
rejected. I'll have a look at that...

> I have looked through the code, nothing stands out that I
> can see. Do you have a public tree I can pull for easy
> testing?

No, not for a small RFC patchset. git am is your friend ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
