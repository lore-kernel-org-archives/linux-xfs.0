Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 876477CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 19:40:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F184AAC003
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 17:40:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3twX0upTLhqplJdl for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 17:40:55 -0700 (PDT)
Date: Fri, 14 Jun 2013 10:40:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/27] xfs: update mount options documentation
Message-ID: <20130614004052.GO29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-2-git-send-email-david@fromorbit.com>
	<51B9CA59.6010706@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51B9CA59.6010706@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Jun 13, 2013 at 08:34:17AM -0500, Eric Sandeen wrote:
> On 6/12/13 5:22 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because it's horribly out of date.
> > 
> > And mark various deprecated options as deprecated and give them a
> > removal date.
> 
> thanks for doing this.  some nitpicks below.
....
> > +  discard/nodiscard
> >  
> > +	Enable/disable the issuing of commands to let the block
> > +	device reclaim space freed by the filesystem.  This is
> > +	useful for SSD devices, thinly provisioned LUNs and virtual
> > +	machine images, but may have a performance impact.
> 
> should we talk about fstrim as an alternative here?
> 
> > -  ihashsize=value
> > -	In memory inode hashes have been removed, so this option has
> > -	no function as of August 2007. Option is deprecated.
> > +	The default behaviour is disable discard commands.
> > +
> > +	Note: It is currently recommended that you use the fstrim
> > +	application to discard unused blocks rather than the discard
> > +	mount option because the performance impact of this option
> > +	is quite severe.
> 
> oh right!

patch obfuscation for the win!

> 
> > +  grpid/bsdgroups and nogrpid/sysvgroups
> > +	These options define what group ID a newly created file
> > +	gets.  When grpid is set, it takes the group ID of the
> > +	directory in which it is created; otherwise (the default) it
> > +	takes the fsgid of the current process, unless the directory
> > +	has the setgid bit set, in which case it takes the gid from
> > +	the parent directory, and also gets the setgid bit set if it
> > +	is a directory itself.
> > +
> > +  filestreams
> > +	Make the data allocator use the filestreams allocation mode
> > +	across the entire filesystem rather than just on directories
> > +	configured to use it.
> >  
> >    ikeep/noikeep
> > -	When ikeep is specified, XFS does not delete empty inode clusters
> > -	and keeps them around on disk. ikeep is the traditional XFS
> > -	behaviour. When noikeep is specified, empty inode clusters
> > -	are returned to the free space pool. The default is noikeep for
> > -	non-DMAPI mounts, while ikeep is the default when DMAPI is in use.
> > +	When ikeep is specified, XFS does not delete empty inode
> > +	clusters and keeps them around on disk.  When noikeep is
> > +	specified, empty inode clusters are returned to the free
> > +	space pool.
> > +
> > +	The default behaviour is delete inode clusters (noikeep).
> 
> is to delete inode clusters

*nod*

> 
> >  
> >    inode64
> > -	Indicates that XFS is allowed to create inodes at any location
> > -	in the filesystem, including those which will result in inode
> > -	numbers occupying more than 32 bits of significance.  This is
> > -	the default allocation option. Applications which do not handle
> > -	inode numbers bigger than 32 bits, should use inode32 option.
> > +	When inode64 is specified, it indicates that XFS is allowed
> > +	to create inodes at any location in the filesystem,
> > +	including those which will result in inode numbers occupying
> > +	more than 32 bits of significance.  Applications which do
> > +	not handle inode numbers bigger than 32 bits should use
> > +	inode32 option.
> 
> While we're rewriting . . . applications don't use mount options,
> not really.  So maybe:
> 
> If applications are in use which do not handle inode numbers bigger
> than 32 bits, the inode32 option should be specified.

Fair enough.

> 
> > +	This is the default allocation behaviour, even on 32 bit
> > +	machines when neither inode64 or inode32 is specified.
> >  
> >    inode32
> > -	Indicates that XFS is limited to create inodes at locations which
> > -	will not result in inode numbers with more than 32 bits of
> > -	significance. This is provided for backwards compatibility, since
> > -	64 bits inode numbers might cause problems for some applications
> > -	that cannot handle large inode numbers.
> > +	When inode32 is specified, it indicates that XFS limits
> > +	inode creation to locations which will not result in inode
> > +	numbers with more than 32 bits of significance. This is
> > +	provided for backwards compatibility with older systems and
> > +	applications, since 64 bits inode numbers might cause
> > +	problems for some applications that cannot handle large
> > +	inode numbers.
> 
> Any point to talking about what this does to locality etc?

No, not here. If we start talking about detailed impacts, then every
second mount option needs huge amount more text. Detailed
descriptions of impact on allocation strategies belongs in advanced
user guides, not mount option documentation....

> 
> >    largeio/nolargeio
> >  	If "nolargeio" is specified, the optimal I/O reported in
> > -	st_blksize by stat(2) will be as small as possible to allow user
> > -	applications to avoid inefficient read/modify/write I/O.
> > -	If "largeio" specified, a filesystem that has a "swidth" specified
> > -	will return the "swidth" value (in bytes) in st_blksize. If the
> > -	filesystem does not have a "swidth" specified but does specify
> > -	an "allocsize" then "allocsize" (in bytes) will be returned
> > -	instead.
> > +	st_blksize by stat(2) will be as small as possible to allow
> > +	user applications to avoid inefficient read/modify/write
> > +	I/O.  This is typically the page size of the machine, as
> > +	this is the granularity of the page cache.
> > +
> > +	If "largeio" specified, a filesystem that was created with a
> > +	"swidth" specified will return the "swidth" value (in bytes)
> > +	in st_blksize. If the filesystem does not have a "swidth"
> > +	specified but does specify an "allocsize" then "allocsize"
> > +	(in bytes) will be returned instead. Otherwise the behaviour
> > +	is the same as if "nolargeio" was specified.
> > +
> >  	If neither of these two options are specified, then filesystem
> >  	will behave as if "nolargeio" was specified.
> 
> I have to wonder when anyone would want to use largeio.  This doesn't
> tell me, either.  ;)

When you want stat to return a stripe width as the optimal IO size
so applications like cp can do large, aligned IOs....

> I wonder if there's any clearer way to show defaults.  Maybe:
> 
>      largeio
>      nolargeio (*)
>    	If "nolargeio" is specified, the optimal I/O reported in
> 	...

Yeah, that makes sense.

> >    logbsize=value
> > -	Set the size of each in-memory log buffer.
> > -	Size may be specified in bytes, or in kilobytes with a "k" suffix.
> > -	Valid sizes for version 1 and version 2 logs are 16384 (16k) and
> > -	32768 (32k).  Valid sizes for version 2 logs also include
> > -	65536 (64k), 131072 (128k) and 262144 (256k).
> > -	The default value for machines with more than 32MiB of memory
> > -	is 32768, machines with less memory use 16384 by default.
> > +	Set the size of each in-memory log buffer.  The size may be
> > +	specified in bytes, or in kilobytes with a "k" suffix.
> > +	Valid sizes for version 1 and version 2 logs are 16384 (16k)
> > +	and 32768 (32k).  Valid sizes for version 2 logs also
> > +	include 65536 (64k), 131072 (128k) and 262144 (256k). The
> > +	version 2 log size must be an integer multiple of the log
> > +	stripe unit configured at mkfs time.
> 
> the version 2 log size, or logbsize?

logbsize.

> 
> > +	The default value for for version 1 logs is 32768, while the
> > +	default value for version 2 logs is MAX(32768, log_sunit).
> >  
> >    logdev=device and rtdev=device
> >  	Use an external log (metadata journal) and/or real-time device.
> > @@ -124,16 +153,12 @@ When mounting an XFS filesystem, the following options are accepted.
> >  	optional, and the log section can be separate from the data
> >  	section or contained within it.
> >  
> > -  mtpt=mountpoint
> > -	Use with the "dmapi" option.  The value specified here will be
> > -	included in the DMAPI mount event, and should be the path of
> > -	the actual mountpoint that is used.
> > -
> >    noalign
> > -	Data allocations will not be aligned at stripe unit boundaries.
> >  
> > -  noatime
> > -	Access timestamps are not updated when a file is read.
> > +	Data allocations will not be aligned at stripe unit
> > +	boundaries. This is only relevant to filesystems created
> > +	with non-zero data alignment parameters (sunit, swidth) by
> > +	mkfs.
> 
> why would I use this?

Explanation of "why" is not in the scope of this document. This is
a "what" document.

> >    sunit=value and swidth=value
> > -	Used to specify the stripe unit and width for a RAID device or
> > -	a stripe volume.  "value" must be specified in 512-byte block
> > -	units.
> > -	If this option is not specified and the filesystem was made on
> > -	a stripe volume or the stripe width or unit were specified for
> > -	the RAID device at mkfs time, then the mount system call will
> > -	restore the value from the superblock.  For filesystems that
> > -	are made directly on RAID devices, these options can be used
> > -	to override the information in the superblock if the underlying
> > -	disk layout changes after the filesystem has been created.
> > -	The "swidth" option is required if the "sunit" option has been
> > -	specified, and must be a multiple of the "sunit" value.
> > +	Used to specify the stripe unit and width for a RAID device
> > +	or a stripe volume.  "value" must be specified in 512-byte
> > +	block units. These options are only relevant to filesystems
> > +	that were created with non-zero data alignment parameters.
> 
> (i.e. su/sw or sunit/swidth was specified at mkfs time).
> 
> > +
> > +	The sunit and swidth parameters specified must be compatible
> > +	with the existing filesystem alignment characteristics. If
> > +	the filesystem was not created with data alignment
> > +	constraints, then it may be impossible to set a valid sunit
> > +	(and hence swidth) value.  In general, that means the only
> > +	valid changes to sunit are increasing it by a power-of-2
> > +	multiple. Valid swidth values are any integer multiple of a
> > +	valid sunit value.
> 
> now I'm confused.  It's only relevant to a filesystem w/ geometry
> specified, but if it wasn't specified, it may be possible . . . ?

> And if nothing was specified (i.e. 0 su/sw) then we can only increase
> that 0 by a power of 2?
> 
> 
> > +	For filesystems that have existing data alignment values on
> > +	disk (i.e. specified by mkfs), any new valid values passed
> > +	in as mount options will overwrite the values stored on
> > +	disk. Hence this mount option does not need to be specified
> > +	for every mount operation in this case.
> 
> so I think this all needs to clarify whether it works on filesystems
> w/o existing geometry, or not.  And "why you might want this" would
> be helpful too.

It's obviously too complex to explain everything in a short "what"
description. I suspect that the best thing to do here is simply
document it as a method of changing alignment for a device that has
changed geometry such as a adding a disk to a MD RAID5 device. I'm
going to drop any reference to sunit/swidth being zero because that
case was a hack for fixing a CXFS client bug.

> >  sysctls
> >  =======
> > @@ -189,15 +264,20 @@ The following sysctls are available for the XFS filesystem:
> >  	in /proc/fs/xfs/stat.  It then immediately resets to "0".
> >  
> >    fs.xfs.xfssyncd_centisecs	(Min: 100  Default: 3000  Max: 720000)
> > -  	The interval at which the xfssyncd thread flushes metadata
> > -  	out to disk.  This thread will flush log activity out, and
> > -  	do some processing on unlinked inodes.
> > +	The interval at which the filesystem flushes metadata
> > +	out to disk and runs internal cache cleanup routines.
> >  
> > -  fs.xfs.xfsbufd_centisecs	(Min: 50  Default: 100	Max: 3000)
> > -	The interval at which xfsbufd scans the dirty metadata buffers list.
> > +  fs.xfs.filestream_centisecs	(Min: 1  Default: 3000  Max: 360000)
> > +	The interval at which the filesystem ages filestreams cache
> > +	references and returns timed-out AGs back to the free stream
> > +	pool.
> 
> I bet Documentation/filesystem/xfs-filestreams.txt would be handy, but *shrug*

You're welcome to write it and then make the filestreams code behave
reliably as per the documentation for the 2 people that use it....
;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
