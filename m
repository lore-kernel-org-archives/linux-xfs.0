Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 15:21:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2AMLICm002470
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 15:21:22 -0700
Date: Tue, 11 Mar 2008 09:21:35 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
Message-ID: <20080310222135.GZ155407@sgi.com>
References: <20080310000809.GU155407@sgi.com> <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com> <1a4a774c0803100302y17530814wee7522aa0dfd7668@mail.gmail.com> <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com> <20080213214551.GR155407@sgi.com> <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com> <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com> <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com> <20080310000809.GU155407@sgi.com> <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a4a774c0803100302y17530814wee7522aa0dfd7668@mail.gmail.com> <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian =?iso-8859-1?Q?R=F8snes?= <christian.rosnes@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Mon, Mar 10, 2008 at 09:34:14AM +0100, Christian Røsnes wrote:
> On Mon, Mar 10, 2008 at 1:08 AM, David Chinner <dgc@sgi.com> wrote:
> > On Fri, Mar 07, 2008 at 12:19:28PM +0100, Christian Røsnes wrote:
> >  > >  Actually, a single mkdir command is enough to trigger the filesystem
> >  > >  shutdown when its 99% full (according to df -k):
> >  > >
> >  > >  /data# mkdir test
> >  > >  mkdir: cannot create directory `test': No space left on device
> >
> >  Ok, that's helpful ;)
> >  So, can you dump the directory inode with xfs_db? i.e.
> >  # ls -ia /data
> 
> # ls -ia /data
>       128 .        128 ..        131 content  149256847 rsync
>
> >  The directory inode is the inode at ".", and if this is the root of
> >  the filesystem it will probably be 128. Then run:
> >  # xfs_db -r -c 'inode 128' -c p /dev/sdb1
> 
> # xfs_db -r -c 'inode 128' -c p /dev/sdb1
> core.magic = 0x494e
> core.mode = 040755
> core.version = 1
> core.format = 1 (local)
.....
> core.size = 32
....
> u.sfdir2.hdr.count = 2
> u.sfdir2.hdr.i8count = 0
> u.sfdir2.hdr.parent.i4 = 128
> u.sfdir2.list[0].namelen = 7
> u.sfdir2.list[0].offset = 0x30
> u.sfdir2.list[0].name = "content"
> u.sfdir2.list[0].inumber.i4 = 131
> u.sfdir2.list[1].namelen = 5
> u.sfdir2.list[1].offset = 0x48
> u.sfdir2.list[1].name = "rsync"
> u.sfdir2.list[1].inumber.i4 = 149256847

Ok, so a shortform directory still with heaps of space in it. so
it's definitely not a directory namespace creation issue.

> >  > >  xfs_db -r -c 'sb 0' -c p /dev/sdb1
> >  > >  ----------------------------------
> >  .....
> >  > >  fdblocks = 847484
> >
> >  Apparently there are still lots of free blocks. I wonder if you are out of
> >  space in the metadata AGs.
> >
> >  Can you do this for me:
> >
> >  -------
> >  #!/bin/bash
> >
> >  for i in `seq 0 1 15`; do
> >         echo freespace histogram for AG $i
> >         xfs_db -r -c "freesp -bs -a $i" /dev/sdb1
> >  done
> >  ------
> freespace histogram for AG 0
>    from      to extents  blocks    pct
>       1       1    2098    2098   3.77
>       2       3    8032   16979  30.54
>       4       7    6158   33609  60.46
>       8      15     363    2904   5.22

So with 256 byte inodes, we need a 16k allocation or a 4 block extent.
There's plenty of extents large enough to use for that, so it's
not an inode chunk allocation error.

> Btw - to debug this on a test-system, can I do a dd if=/dev/sdb1 or dd
> if=/dev/sdb,
> and output it to an image which is then loopback mounted on the test-system ?

That would work. Use /dev/sdb1 as the source so all you copy are
filesystem blocks.

> Ie. is there some sort of  "best practice" on how to copy this
> partition to a test-system
> for further testing ?

Do what fit's your needs - for debugging identical images are generally
best. For debugging metadata or repair problems, xfs_metadump works
very well (replaces data with zeros, though), and for imaging purposes
xfs_copy is very efficient.

On Mon, Mar 10, 2008 at 11:02:28AM +0100, Christian Røsnes wrote:
> On Mon, Mar 10, 2008 at 9:34 AM, Christian Røsnes
> <christian.rosnes@gmail.com> wrote:
> >  On Mon, Mar 10, 2008 at 1:08 AM, David Chinner <dgc@sgi.com> wrote:
> >  >  This does not appear to be the case I was expecting, though I can
> >  >  see how we can get an ENOSPC here with plenty of blocks free - none
> >  >  are large enough to allocate an inode chunk. What would be worth
> >  >  knowing is the value of resblks when this error is reported.
> >
> >  Ok. I'll see if I can print it out.
> 
> Ok. I added printk statments to xfs_mkdir in xfs_vnodeops.c:
> 
>  'resblks=45' is the value returned by:
> 
> resblks = XFS_MKDIR_SPACE_RES(mp, dir_namelen);
> 
> and this is the value when the error_return label is called.

That confirms we're not out of directory space or filesystem space.

> --
> 
> and inside xfs_dir_ialloc (file: xfs_utils.c) this is where it returns
> 
>        ...
> 
>        code = xfs_ialloc(tp, dp, mode, nlink, rdev, credp, prid, okalloc,
>                           &ialloc_context, &call_again, &ip);
> 
>         /*
>          * Return an error if we were unable to allocate a new inode.
>          * This should only happen if we run out of space on disk or
>          * encounter a disk error.
>          */
>         if (code) {
>                 *ipp = NULL;
>                 return code;
>         }
>         if (!call_again && (ip == NULL)) {
>                 *ipp = NULL;
>                 return XFS_ERROR(ENOSPC);   <============== returns here
>         }

Interesting. That implies that xfs_ialloc() failed here:

   1053         /*
   1054          * Call the space management code to pick
   1055          * the on-disk inode to be allocated.
   1056          */
   1057         error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode, okalloc,
   1058                             ialloc_context, call_again, &ino);
   1059         if (error != 0) {
   1060                 return error;
   1061         }
   1062         if (*call_again || ino == NULLFSINO) {  <<<<<<<<<<<<<<<<
   1063                 *ipp = NULL;
   1064                 return 0;
   1065         }


Which means that xfs_dialloc() failed without ian error or setting
*call_again but setting ino == NULLFSINO. That leaves these possible
failure places:

    544                 agbp = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
    545                 /*
    546                  * Couldn't find an allocation group satisfying the
    547                  * criteria, give up.
    548                  */
    549                 if (!agbp) {
    550                         *inop = NULLFSINO;
    551  >>>>>>>>>>             return 0;
    552                 }
........
    572         /*
    573          * If we have already hit the ceiling of inode blocks then clear
    574          * okalloc so we scan all available agi structures for a free
    575          * inode.
    576          */
    577
    578         if (mp->m_maxicount &&
    579             mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
    580                 noroom = 1;
    581                 okalloc = 0;
    582         }
........
    600                         if ((error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced))) {
    601                                 xfs_trans_brelse(tp, agbp);
    602                                 if (error == ENOSPC) {
    603                                         *inop = NULLFSINO;
    604  >>>>>>>>>>                             return 0;
    605                                 } else
    606                                         return error;
........
    629 nextag:
    630                 if (++tagno == agcount)
    631                         tagno = 0;
    632                 if (tagno == agno) {
    633                         *inop = NULLFSINO;
    634  >>>>>>>>>>             return noroom ? ENOSPC : 0;
    635                 }

Note that for the last case, we don't know what the value of "noroom" is.
noroom gets set to 1 if we've reached the maximum number of inodes in the
filesystem. Fromteh earlier superblock dump you did:

> dblocks = 71627792
.....
> inopblog = 3
.....
> imax_pct = 25
> icount = 3570112
> ifree = 0

and the code that calculates this is:

                icount = sbp->sb_dblocks * sbp->sb_imax_pct;
                do_div(icount, 100);
                do_div(icount, mp->m_ialloc_blks);
                mp->m_maxicount = (icount * mp->m_ialloc_blks)  <<
                                   sbp->sb_inopblog;

therefore:

	 m_maxicount = (((((71627792 * 25) / 100) / 4) * 4) << 3)
		     = 143,255,584

which is way larger than the 3,570,112 that you have already allocated.
Hence I think that noroom == 0 and the last chunk of code above is
a possibility.

Further - we need to allocate new inodes as there are none free. That
implies we are calling xfs_ialloc_ag_alloc(). Taking a stab in the
dark, I suspect that we are not getting an error from xfs_ialloc_ag_alloc()
but we are not allocating inode chunks. Why?

Back to the superblock:

> unit = 16
> width = 32

You've got a filesystem with stripe alignment set. In xfs_ialloc_ag_alloc()
we attempt inode allocation by the following rules:

	1. a) If we haven't previously allocated inodes, fall through to 2.
	   b) If we have previously allocated inode, attempt to allocate next
	      to the last inode chunk.

	2. If we do not have an extent now:
		a) if we have stripe alignment, try with alignment
		b) if we don't have stripe alignment try cluster alignment

	3. If we do not have an extent now:
		a) if we have stripe alignment, try with cluster alignment
		b) no stripe alignment, turn off alignment.

	4. If we do not have an extent now: FAIL.
		  
Note the case missing from the stripe alignment fallback path - it does not
try without alignment at all. That means if all those extents large enough
that we found above are not correctly aligned, then we will still fail
to allocate an inode chunk. if all the AGs are like this, then we'll
fail to allocate at all and fall out of xfs_dialloc() through the last
fragment I quoted above.

As to the shutdown that this triggers - the attempt to allocate dirties
the AGFL and the AGF by moving free blocks into the free list for btree
splits and cancelling a dirty transaction results in a shutdown.

Now, to test this theory. ;) Luckily, it's easy to test. mount the
filesystem with the mount option "noalign" and rerun the mkdir test.
If it is an alignment problem, then setting noalign will prevent
this ENOSPC and shutdown as the filesystem will be able to allocate
more inodes.

Can you test this for me, Christian?

Cheers,

Dave.





 
> 
> 
> Christian


-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
