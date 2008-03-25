Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 16:08:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PN8fZo009179
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 16:08:42 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 098FC102D591
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 16:09:14 -0700 (PDT)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id rc7dpjquOwW52a4p for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 16:09:14 -0700 (PDT)
From: "NeilBrown" <neilb@suse.de>
Date: Wed, 26 Mar 2008 10:09:00 +1100 (EST)
Message-ID: <45922.192.168.1.70.1206486540.squirrel@neil.brown.name>
In-Reply-To: <20080325221321.GC20257@josefsipek.net>
References: <9a8748490803121513w285cd45rb6b26a3d842cac1b@mail.gmail.com>
    <20080312221511.GC31632@fieldses.org>
    <9a8748490803121516u36395872i70cc88b0439adc74@mail.gmail.com>
    <18394.1501.991087.80264@notabene.brown> <47DAEFD0.9020407@m2000.com>
    <47E92F8E.7030504@m2000.com> <20080325190943.GF2237@fieldses.org>
    <32953.192.168.1.70.1206477121.squirrel@neil.brown.name>
    <20080325212425.GA20257@josefsipek.net>
    <34178.192.168.1.70.1206481102.squirrel@neil.brown.name>
    <20080325221321.GC20257@josefsipek.net>
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com, Adam Schrotenboer <adam@m2000.com>, Jesper Juhl <jesper.juhl@gmail.com>, Trond Myklebust <trond.myklebust@netapp.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, Thomas Daniel <tdaniel@m2000.com>, Frederic Revenu <frevenu@m2000.com>, Jeff Doan <jdoan@m2000.com>

On Wed, March 26, 2008 9:13 am, Josef 'Jeff' Sipek wrote:
> On Wed, Mar 26, 2008 at 08:38:22AM +1100, NeilBrown wrote:
> ...
>> However you still need to do something about the generation number.  It
>> must be set to something.
>
> Right.
>
>> When you allocate an inode that doesn't currently exist on the device,
>> you obviously cannot increment the old value and use that.
>
> Makes sense.
>
>> However you can do a lot better than always using 0.
>
> I looked at the code (xfs_ialloc.c:xfs_ialloc_ag_alloc)
>
>  290                 /*
>  291                  * Set initial values for the inodes in this buffer.
>  292                  */
>  293                 xfs_biozero(fbuf, 0, ninodes <<
> args.mp->m_sb.sb_inodelog);
>  294                 for (i = 0; i < ninodes; i++) {
>  295                         free = XFS_MAKE_IPTR(args.mp, fbuf, i);
>  296                         free->di_core.di_magic =
> cpu_to_be16(XFS_DINODE_MAGIC);
>  297                         free->di_core.di_version = version;
>  298                         free->di_next_unlinked =
> cpu_to_be32(NULLAGINO);
>  299                         xfs_ialloc_log_di(tp, fbuf, i,
>  300                                 XFS_DI_CORE_BITS |
> XFS_DI_NEXT_UNLINKED);
>  301                 }
>
> xfs_biozero(...) turns into a memset(buf, 0, len), and since the loop that
> follows doesn't change the generation number, it'll stay 0.
>
>> The simplest would be to generate a 'random' number (get_random_bytes).
>> Slightly better would be to generate a random number at boot time
>> and use that, incrementing it each time it is used to set the
>> generation number for an inode.
>
> I'm not familiar enough with NFS, do you want something that's
> monotonically
> increasing or do you just test for inequality?  If it is inequality, why
> not
> just use something like the jiffies - that should be unique enough.
>

What we need is for the "filehandle" to be stable and unique.
By 'stable' I mean that every time I get the filehandle for a particular
file, I get the same string of bytes.
By 'uniqie' I mean that if I get two filehandles for two different
files, they must differ in at least one bit.
If a file is deleted and the inode is re-used for a new file, then the
old and new files are different and must have different file handles.

The filehandle is traditionally generated from the inode number and
a generation number, but the filesystem can actually do whatever it
likes.  xfs does it with xfs_fs_encode_fh().

Certainly you could initialise the i_generation to jiffies in
xfs_ialloc_ag_alloc.  That would be a suitable fix.  get_random_bytes
might be better, but the difference probably wouldn't be noticeable.

NeilBrown
