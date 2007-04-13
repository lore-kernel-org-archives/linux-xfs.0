Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Apr 2007 12:07:02 -0700 (PDT)
Received: from rwcrmhc15.comcast.net (rwcrmhc15.comcast.net [216.148.227.155])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3DJ6wfB025581
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 12:06:59 -0700
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
From: Nicholas Miell <nmiell@comcast.net>
In-Reply-To: <37B026AB-60FA-4595-B2B1-F57BB023D91C@cam.ac.uk>
References: <20070412110550.GM5967@schatzie.adilger.int>
	 <20070413101507.GA11406@infradead.org>
	 <37B026AB-60FA-4595-B2B1-F57BB023D91C@cam.ac.uk>
Content-Type: text/plain
Date: Fri, 13 Apr 2007 11:55:49 -0700
Message-Id: <1176490549.3122.16.camel@entropy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 2007-04-13 at 12:38 +0100, Anton Altaparmakov wrote:
> > One addition freature from the XFS getbmapx interface we should
> > provide is the ability to query layout of xattrs.  While other
> > filesystems might not have the exact xattr fork XFS has it fits
> > nicely into the interface.  Especially when we have Anton's suggested
> > flag for inline data.
> 
> Would it not be better to allow people to get a file descriptor on  
> the xattr fork and then just run the normal FIEMAP ioctl on that file  
> descriptor?
> 
> I.e. "openat(base file descriptor, O_STREAM, streamname)" or O_XATTR  
> or whatever...  An alternative API would be to provide a "getxattrfd 
> ()/fgetxattrfd()" call or similar that would instead of returning the  
> value of an xattr return an fd to it.  Then you do not need to modify  
> openat() at all...  Interface doesn't bother me, just some ideas...
> 
> And for XFS you would define a magic streamname or xattrname (or  
> whatever you want to call it) of say  
> "com.sgi.filesystem.xfs.xattrstream" (or .xattrfork) or something and  
> then XFS would intercept that and know what to do with it...
> 
> Such an interface could then be used by NTFS named streams and other  
> file systems providing such things...
> 
> (Yes I know I will now totally get flamed about named streams not  
> being wanted in Linux and crap like that but that is exactly what you  
> are asking for except you want to special case a particular stream  
> using a flag instead of calling it for what it really is and once you  
> start doing that you might as well allow full named streams...)
> 
> You can just see named streams as an alternative, non-atomic API to  
> xattrs if you like, i.e. you can either use the atomic xattr API  
> provided in Linux already or you can get a file descriptor to an  
> xattr and then use the normal system calls to access it non- 
> atomically thus you can use the FIEMAP ioctl also.  (-:
> 
> FWIW this two-API approach to xattrs/named streams is the direction  
> OSX is heading towards also so it is not without precedent and  
> Windows has had both APIs for many years.  And Solaris has the "openat 
> (O_XATTR)" interface so that is not without precedent either.

Except that xattrs in Linux aren't streams, and providing a stream-like
interface to them would be a weird abuse of the xattr concept.

In essence, Linux xattrs are named extensions to struct stat, with
getxattr() being in the same category as stat() and setxattr() being in
the same category as chmod()/chown()/utime()/etc.

They system namespace exists to provide a better interface than ioctl()
to weird FS-specific features (DOS attribute bits, HFS+ creator/type,
ext2/3/reiserfs/etc. immutable/append-only/secure-delete/etc. attributes
and so on). The uptake of this feature isn't as high as I'd like, but
that's what it's there for.

They security namespace is there for all the neat LSM modules that need
to attach metadata to files in order to function.

Finally, the user namespace exists to allow users to attach small bits
of information to their own files, since the API was already there and
hey!, metadata is useful.

Now, Solaris came along and totally confused the issue by using the same
name for a completely different feature, but that isn't any real reason
to mess up the existing Linux xattr concept just to graft named streams
support into the kernel.

(Not that I'm opposed to named streams in Linux, you just have to
realize that xattrs aren't name streams, can't live in the same
namespace as named streams, and certainly don't serve the same purpose
as named streams.)

-- 
Nicholas Miell <nmiell@comcast.net>
