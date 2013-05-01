Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 687A37F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 17:30:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41B97304043
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 15:30:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MfmXlne4id8R2RZf for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 15:30:24 -0700 (PDT)
Date: Thu, 2 May 2013 08:30:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Cleancache support in XFS
Message-ID: <20130501223022.GQ10481@dastard>
References: <51810CED.4080003@zynstra.com>
 <20130501162044.GN29359@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130501162044.GN29359@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: James Dingwall <james.dingwall@zynstra.com>, xfs@oss.sgi.com

On Wed, May 01, 2013 at 11:20:44AM -0500, Ben Myers wrote:
> Hi James, 
> 
> On Wed, May 01, 2013 at 01:39:09PM +0100, James Dingwall wrote:
> > In reference to: http://oss.sgi.com/archives/xfs/2012-05/msg00046.html
> > 
> > $ grep -r cleancache fs/xfs
> > on the 3.9 kernel source suggests that no patch was submitted to
> > enable cleancache for the XFS filesystem.  Since it was suggested
> > that this could be a one liner I've had a go and my first effort is
> > inline below.  While this seems to compile OK I have no experience
> > in filesystems so I would appreciate it if anyone can point out that
> > it is obviously wrong and likely to eat my data before I try booting
> > the kernel.
> > 
> > If it seems a reasonable attempt what would be the best way to check
> > that it isn't doing nasty things?
> 
> Hrm.. Looks like there is a doc in Documentation/vm/cleancache.txt which
> includes a list of attributes the filesystem needs to have to work properly
> with cleancache.

So, those points are:

| Some points for a filesystem to consider:
|
| - The FS should be block-device-based (e.g. a ram-based FS such
|  as tmpfs should not enable cleancache)

OK.

|- To ensure coherency/correctness, the FS must ensure that all
|  file removal or truncation operations either go through VFS or
|  add hooks to do the equivalent cleancache "invalidate" operations

There be dragons - do all the XFS ioctls do the right thing?

|- To ensure coherency/correctness, either inode numbers must
|  be unique across the lifetime of the on-disk file OR the
|  FS must provide an "encode_fh" function.

Ok.

|- The FS must call the VFS superblock alloc and deactivate routines
|  or add hooks to do the equivalent cleancache calls done there.

OK.

|- To maximize performance, all pages fetched from the FS should
|  go through the do_mpag_readpage routine or the FS should add
|  hooks to do the equivalent (cf. btrfs)

xfs uses mpage_readpages() so should be fine.

|- Currently, the FS blocksize must be the same as PAGESIZE.  This
|  is not an architectural restriction, but no backends currently
|  support anything different.

Which means that we need hooks in the mount path to determine if
this is the case or not. I note that neither ext3/ext4 do this check
so I can't determine why this restriction is mentioned, and I'm not
sure if it has any relevance to btrfs.

IOWs, I'd like to know why this restriction exists - what does
cleancache care about how the filesystem maps blocks to the page in
the page cache - any way the filesystem does this it uses
page->private to hide this fact from the page cache....

|- A clustered FS should invoke the "shared_init_fs" cleancache
|  hook to get best performance for some backends.

Not a problem.

So there's a couple of things that need to be explained and
explored, and a bunch of testing to be done....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
