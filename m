Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B7827CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 14:28:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A522304077
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 12:28:45 -0700 (PDT)
Date: Wed, 22 May 2013 15:28:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: Cleancache support in XFS
Message-ID: <20130522192834.GD10617@phenom.dumpdata.com>
References: <51810CED.4080003@zynstra.com> <20130501162044.GN29359@sgi.com>
	<20130501223022.GQ10481@dastard> <518222D3.3080109@zynstra.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518222D3.3080109@zynstra.com>
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
To: James Dingwall <james.dingwall@zynstra.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, May 02, 2013 at 09:24:51AM +0100, James Dingwall wrote:
> Dave Chinner wrote:
> >On Wed, May 01, 2013 at 11:20:44AM -0500, Ben Myers wrote:
> >>Hi James,

Hey folks,
I am walking through my vacation-emails-mbox.

> >>
> >>On Wed, May 01, 2013 at 01:39:09PM +0100, James Dingwall wrote:
> >>>In reference to: http://oss.sgi.com/archives/xfs/2012-05/msg00046.html
> >>>
> >>>$ grep -r cleancache fs/xfs
> >>>on the 3.9 kernel source suggests that no patch was submitted to
> >>>enable cleancache for the XFS filesystem.  Since it was suggested
> >>>that this could be a one liner I've had a go and my first effort is
> >>>inline below.  While this seems to compile OK I have no experience
> >>>in filesystems so I would appreciate it if anyone can point out that
> >>>it is obviously wrong and likely to eat my data before I try booting
> >>>the kernel.
> >>>
> >>>If it seems a reasonable attempt what would be the best way to check
> >>>that it isn't doing nasty things?
> >>Hrm.. Looks like there is a doc in Documentation/vm/cleancache.txt which
> >>includes a list of attributes the filesystem needs to have to work properly
> >>with cleancache.
> >So, those points are:
> I had started to look at these too but I feel very out of my depth!
> I had similar conclusions to what Dave wrote but I don't think my
> thoughts should carry very much (any) weight.  Anyway I gambled and
> booted my xen domU with this patch and so far so good...  xen top
> shows that tmem is now being used where previously it wasn't.  I'll
> try running the xfstests at the weekend after a couple more days up
> time to see what happens.

And how did it go?
> >
> >| Some points for a filesystem to consider:
> >|
> >| - The FS should be block-device-based (e.g. a ram-based FS such
> >|  as tmpfs should not enable cleancache)
> >
> >OK.
> >
> >|- To ensure coherency/correctness, the FS must ensure that all
> >|  file removal or truncation operations either go through VFS or
> >|  add hooks to do the equivalent cleancache "invalidate" operations
> >
> >There be dragons - do all the XFS ioctls do the right thing?
> vfs_unlink() calls *dir->i_op->unlink, in xfs_iops.c for S_IFDIR there is:
> 
> if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
>         inode->i_op = &xfs_dir_ci_inode_operations;
> else
>         inode->i_op = &xfs_dir_inode_operations;
> 
> where .unlink in xfs_dir_inode_operations is xfs_vn_unlink() in either
> condition.
> 
> I can't work out how to follow the vfs_truncate() in to the filesystem
> code and perhaps there are other paths that would lead to file removal.

Did that ever get worked out or are you waiting for a response on that?

> 
> >
> >|- To ensure coherency/correctness, either inode numbers must
> >|  be unique across the lifetime of the on-disk file OR the
> >|  FS must provide an "encode_fh" function.
> >
> >Ok.
> >
> >|- The FS must call the VFS superblock alloc and deactivate routines
> >|  or add hooks to do the equivalent cleancache calls done there.
> >
> >OK.
> >
> >|- To maximize performance, all pages fetched from the FS should
> >|  go through the do_mpag_readpage routine or the FS should add
> >|  hooks to do the equivalent (cf. btrfs)
> >
> >xfs uses mpage_readpages() so should be fine.

OK.
> I think there is a cleancache documentation bug since no other fs
> calls do_mpage_readpage().

The mpage_readpage goes "through the do_mpage(sic)_readpage" routine.
There is a bug in that it says 'mpa' instead of 'mpage'.

> >
> >|- Currently, the FS blocksize must be the same as PAGESIZE.  This
> >|  is not an architectural restriction, but no backends currently
> >|  support anything different.
> >
> >Which means that we need hooks in the mount path to determine if
> >this is the case or not. I note that neither ext3/ext4 do this check
> >so I can't determine why this restriction is mentioned, and I'm not
> >sure if it has any relevance to btrfs.
> >
> >IOWs, I'd like to know why this restriction exists - what does
> >cleancache care about how the filesystem maps blocks to the page in
> >the page cache - any way the filesystem does this it uses
> >page->private to hide this fact from the page cache....
> + Konrad (cleancache maintainer) for any opinion.

That is a bug. It should not care about the size of it - as long
as 'struct page *' is passed in. If the underlaying architecture
has 64KB pages, it should work (and I think it does as zcache2
can do it).


> >
> >|- A clustered FS should invoke the "shared_init_fs" cleancache
> >|  hook to get best performance for some backends.
> >
> >Not a problem.
> >
> >So there's a couple of things that need to be explained and
> >explored, and a bunch of testing to be done....

Any patches that I can put on my environment to test it?
Thanks.
> >
> James

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
