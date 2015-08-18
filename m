Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5B46F7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 19:41:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E368304067
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 17:41:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dojMuH9otg3ynxTV for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 17:40:58 -0700 (PDT)
Date: Tue, 18 Aug 2015 10:17:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
Message-ID: <20150818001717.GF714@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
	<20150817193223.GE26222@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150817193223.GE26222@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Jan Tulak <jtulak@redhat.com>

On Mon, Aug 17, 2015 at 12:32:23PM -0700, Christoph Hellwig wrote:
> On Mon, Aug 17, 2015 at 06:23:20PM +0200, Jan Tulak wrote:
> 
> > +#define XATTR_SIZE_MAX 65536    /* size of an extended attribute value (64k) */
> > +#define XATTR_LIST_MAX 65536    /* size of extended attribute namelist (64k) */
> 
> Eww, looks like we depend on these Linux values in the on disk
> defintion.  I think we need to add new XFS_XATTR_SIZE_MAX and
> XFS_XATTR_LIST_MAX defintions to xfs_format.h and use them where
> we currently use these.

Yeah, that looks like something we need to fix.

> > +#define MREMAP_FIXED 1
> > +#define MREMAP_MAYMOVE 2
> > +static inline void *mremap(void *old_address, size_t old_size,
> > +                    size_t new_size, int flags, ... /* void *new_address */)
> > +{
> > +	return NULL;
> > +}
> > +
> > +/* FSR */
> 
> Please just build the mremap file in xfs_io conditional.

Probably should be done on an autconf rule.

> 
> > +typedef int __fsblkcnt_t;
> > +typedef int __fsfilcnt_t;
> > +typedef long long int __fsblkcnt64_t;
> > +typedef long long int __fsfilcnt64_t;
> > +
> > +struct statvfs64
> > +{
> > +	unsigned long int f_bsize;
> > +	unsigned long int f_frsize;
> > +	__fsblkcnt64_t f_blocks;
> > +	__fsblkcnt64_t f_bfree;
> > +	__fsblkcnt64_t f_bavail;
> > +	__fsfilcnt64_t f_files;
> > +	__fsfilcnt64_t f_ffree;
> > +	__fsfilcnt64_t f_favail;
> > +	unsigned long int f_fsid;
> > +	int __f_unused;
> > +	unsigned long int f_flag;
> > +	unsigned long int f_namemax;
> > +	int __f_spare[6];
> > +};
> 
> Does MacOS support statvfs? or statfs?  We should use the proper API
> here instead of a dummy.  Or maybe just not build fsr on OSX for now,
> as that would solve the fsetxattr issue as well.

Apparently so:

https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man2/statfs.2.html

Note that we'll need to define _DARWIN_USE_64_BIT_INODE for OS X to
work correctly.

> > +struct mntent
> > +{
> 
> Another fsr issue, right?  Seems like it would need similar getmntinfo
> based code.  As a stopgap I'd suggest we stop building fsr on OSX for
> now.

That can be based on the HAVE_MNTENT autoconf detection....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
