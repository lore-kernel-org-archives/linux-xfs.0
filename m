Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Oct 2007 08:06:45 -0700 (PDT)
Received: from ppsw-2.csi.cam.ac.uk (ppsw-2.csi.cam.ac.uk [131.111.8.132])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9OF6ZSV024255
	for <xfs@oss.sgi.com>; Wed, 24 Oct 2007 08:06:39 -0700
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <op.t0ox8tfb3jf8g2@pc-bnaujok.melbourne.sgi.com>
Subject: Re: [RFC 0/2] Case-insensitive filename lookup for XFS
References: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com> <30F0B02B-9857-43E8-89C0-E9C85EF081A2@cam.ac.uk> <7858EE76-E860-41C3-8AFC-CE67DF210081@cam.ac.uk> <op.t0ox8tfb3jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-Id: <1CEB9B80-1826-4495-9156-88BD43BC0186@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v912)
Date: Wed, 24 Oct 2007 16:05:54 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>, linux-fsdevel@vger.kernel.org

Hi Barry,

On 24 Oct 2007, at 08:39, Barry Naujok wrote:
> On Tue, 23 Oct 2007 20:07:47 +1000, Anton Altaparmakov <aia21@cam.ac.uk 
> > wrote:
>> I forgot to say:  If you do what I did for NTFS you can also throw
>> away your custom dentry operations that your patch adds as the dcache
>> then only holds correctly cased names so you are fine to do case
>> sensitive dcache lookups at all times.  Access via wrongly cased name
>> will always go to ->lookup inode operation and that is fine because
>> such lookups almost never happen because majority of users will  
>> either
>> use a GUI in which case all names are always correctly cased as the
>> names displayed in the GUI are obtained from a ->readdir and thus  
>> show
>> the correct case or they will use the command line in which case they
>> will be savvy enough to use tab-completion in which case the names  
>> are
>> correct case, too.  Tab-completion does not work on wrongly cased
>> names so you are very unlikely to ever get a wrongly cased name at  
>> all.
>>
>> And yes of course you can on purpose construct a test / benchmark
>> where having to do the ->lookup each time will be really slow because
>> you keep creating files and then accessing them by wrongly cased name
>> on purpose (or whatever) but I would hope that you do not care about
>> such artificial benchmarks that do not reflect any real-world  
>> loads...
>
> I have been looking at ntfs_lookup() and seeing how it does its stuff.
> It seems that is the best way to go.
>
> One thing I have noticed is with two or more attempted case- 
> insensitive
> lookups that don't exist yet case match the same
> (ie. ntfs_lookup_inode_by_name() fails with -ENOENT), d_add(dent,  
> NULL)
> is called, populating the dentry with effective duplicates.
>
> Eg:
>  # cat /mnt/foo/fileNOTexist
>  # cat /mnt/foo/FILEnotEXIST
>
> Will have two negative dentries, am I correct?


Yes, that is correct.  Well spotted!  That means NTFS needs to start  
killing all negative dentries belonging to a directory each time a  
directory entry is created in that directory.  That is what I do for  
NTFS on Mac OS X already but I had forgotten about needing to do it on  
Linux, too.  )-:

In OSX there the VFS provides a function to do this "xnu/bsd/vfs/ 
vfs_cache.c::cache_purge_negatives()", we will need to implement an  
equivalent on Linux:

<quote from xnu/bsd/vfs/vfs_cache.c>
/*
  * Purge all negative cache entries that are children of the
  * given vnode.  A case-insensitive file system (or any file
  * system that has multiple equivalent names for the same
  * directory entry) can use this when creating or renaming
  * to remove negative entries that may no longer apply.
  */
void
cache_purge_negatives(vnode_t vp)
{
         struct namecache *ncp;

         NAME_CACHE_LOCK();

         LIST_FOREACH(ncp, &vp->v_ncchildren, nc_child)
                 if (ncp->nc_vp == NULL)
                         cache_delete(ncp, 1);

         NAME_CACHE_UNLOCK();
}
</quote>

The Linux version should be analogous AFAICS, i.e. take the dentry of  
the directory in which an entry is being created and iterate over its  
d_subdirs list and for each dentry on that list if it is a negative  
dentry, i.e. d_inode is NULL, throw the dentry away.  Basically very  
similar to the OSX function but I can't quite see which dcache  
function we need to call to do the "throw the dentry away" bit.  None  
of the functions in fs/dcache.c look quite right.  I imagine we want  
to take the dcache_lock, traverse d_subdirs list of the directory  
dentry and for each negative dentry on the list, do a __dget_locked(),  
__d_drop(), spin_unlock(&dentry->d_lock), then move it from d_subdirs  
of its parent to a private list and when when we are done, drop the  
dcache_lock and go over the private list and do a dput() for each  
dentry on the private list which will result in them all being  
d_kill()ed.  This can probably be made more efficient by someone who  
understands the dcache better than me but it seems what I suggest  
would at least do the right thing...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
