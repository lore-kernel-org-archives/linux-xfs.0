Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 15:00:04 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0OMxvqw005536
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 14:59:59 -0800
Date: Thu, 25 Jan 2007 09:58:52 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [DISCUSS] xfs allocation bitmap method over linux raid
Message-ID: <20070124225852.GO33919298@melbourne.sgi.com>
References: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: dgc@sgi.com, xfs@oss.sgi.com

On Wed, Jan 24, 2007 at 08:34:22AM +0200, Raz Ben-Jehuda(caro) wrote:
> David Hello.
> I have looked up in LKML and hopefully you are the one to ask in
> regard to xfs file system in Linux.
> My name is Raz and I work for a video servers company.
> These servers demand high throughput from the storage.
> We applied XFS file system on our machines.
> 
> A video server reads a file in a sequential manner. So, if a
> file extent size is not a factor of the stripe unit size a sequential
> read over a raid would break into several small pieces which
> is undesirable for performance.
> 
> I have been examining the bitmap of a file over Linux raid5.
> According to the documentation XFS tries to align a file on
> stripe unit size.

Yup.

> What I have done is to fix the bitmap allocation method during
> the writing to be aligned by the stripe unit size.
> The thing is , though this seems to work , I do not know whether I
> missed something.
> 
> The bellow is a patch (a mere two lines) i have applied to the
> file system and I would be really grateful to have your opinion.
> 
> 
> diff -ru --exclude='*.o'
> /d1/rt/kernels/linux-2.6.17-UNI/fs/xfs/xfs_iomap.c
> linux-2.6.17-UNI/fs/xfs/xfs_iomap.c
> --- /d1/rt/kernels/linux-2.6.17-UNI/fs/xfs/xfs_iomap.c  2006-06-18
> 01:49:35.000000000 +0000
> +++ linux-2.6.17-UNI/fs/xfs/xfs_iomap.c 2006-12-26 14:11:02.000000000 +0000
> @@ -441,8 +441,8 @@
>    if (unlikely(rt)) {
>        if (!(extsz = ip->i_d.di_extsize))
>            extsz = mp->m_sb.sb_rextsize;
> -   } else {
> -       extsz = ip->i_d.di_extsize;
> +   } else {
> +        extsz =  mp->m_dalign; // raz fix alignment to raid stripe unit
>    }
> 
>    isize = ip->i_d.di_size;
> @@ -663,7 +663,7 @@
>        if (!(extsz = ip->i_d.di_extsize))
>            extsz = mp->m_sb.sb_rextsize;
>    } else {
> -       extsz = ip->i_d.di_extsize;
> +       extsz =  mp->m_dalign; //  raz fix alignment to raid stripe unit
>    }
> 
>    offset_fsb = XFS_B_TO_FSBT(mp, offset);

No, that changes the default behaviour of XFS and breaks the extent
allocation size hint code, which is what you should be using to
do this. i.e:

# xfs_io -c "chattr -R +e +E" -c "extsize <sunit>" /path/to/mnt

Will set the inode extent size on all new files and directories in the
filesystem to <sunit>. You'll get a bunch of errors from this
command because you cannot change the extsize of a file that already
has extents allocated to it, so it's best to apply this right after
mkfs when the filesystem is empty.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
