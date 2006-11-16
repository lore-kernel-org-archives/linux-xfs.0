Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 14:46:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAGMkRaG025432
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:46:29 -0800
Date: Fri, 17 Nov 2006 09:45:27 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <20061116224527.GF11034@melbourne.sgi.com>
References: <455CB54F.8080901@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <455CB54F.8080901@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Nov 16, 2006 at 01:00:31PM -0600, Eric Sandeen wrote:
> see also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=212201
> 
> Bugzilla Bug 212201: Cannot build sysem with XFS file system.

.....
> The filesystem was also found to be marked w/ attr1, not attr2....
.....
> if you dd/hexdump the superblock, you will find the attr2 flag, but at
> the wrong offset.
> 
> This is because the xfs_sb_t struct is padded out to 64 bits on 64-bit
> arches, and the xfs_xlatesb() routine and xfs_sb_info[] array take this
> padding to mean that the last item is 4 bytes bigger than it is, and
> treats sb_features2 as 8 bytes not four.  This then gets endian-flipped out...

Ok.

> I can't quite figure out how this winds up causing problems if you stay
> on the x86_64 arch, as I'd expect that if the offset is wrong, it should
> at least be consistently wrong.  And in fact if you do mkfs,mount,xfs_info,
> it will tell you that you do have attr2. But somewhere along the line thing
> go wrong, and post-install, post-reboot, the filesystem thinks it is attr1,
> and is therefore corrupt.

Nor would I expect an i386 to have a problem either.

> I think that maybe some accesses are post-xfs_xlatesb, while others
> may access the un-flipped sb directly?  Or maybe this is sb logging
> code that has messed things up?  Not sure... needs more investigation.

More investigation - we shouldn't be operating on an untranslated
superblock - the first thing we do is read and translate it....

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Index: linux-2.6.18/fs/xfs/xfs_sb.h
> ===================================================================
> --- linux-2.6.18.orig/fs/xfs/xfs_sb.h
> +++ linux-2.6.18/fs/xfs/xfs_sb.h
> @@ -149,7 +149,7 @@ typedef struct xfs_sb
>  	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
>  	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
>  	__uint32_t	sb_features2;	/* additional feature bits */
> -} xfs_sb_t;
> +} __attribute__ ((packed)) xfs_sb_t;

I'd prefer not to pack the structure.

Over time, here's how this changed:

 typedef struct xfs_sb
 {
@@ -135,9 +136,12 @@
        __uint8_t       sb_shared_vn;   /* shared version number */
        xfs_extlen_t    sb_inoalignmt;  /* inode chunk alignment, fsblocks */
        __uint32_t      sb_unit;        /* stripe or raid unit */
-       __uint32_t      sb_width;       /* stripe or raid width */
+       __uint32_t      sb_width;       /* stripe or raid width */
        __uint8_t       sb_dirblklog;   /* log2 of dir block size (fsbs) */
-        __uint8_t       sb_dummy[7];    /* padding */
+       __uint8_t       sb_logsectlog;  /* log2 of the log sector size */
+       __uint16_t      sb_logsectsize; /* sector size for the log, bytes */
+       __uint32_t      sb_logsunit;    /* stripe unit size for the log */
+       __uint32_t      sb_features2;   /* additional feature bits */
 } xfs_sb_t;

So before the sector size > 512 bytes code, there was padding to push the
superblock out to 64bit alignement so that sb_dirblklog was correctly aligned.
The xfs_sb_info structure:

     { offsetof(xfs_sb_t, sb_unit),      0 },
     { offsetof(xfs_sb_t, sb_width),     0 },
     { offsetof(xfs_sb_t, sb_dirblklog),         0 },
-    { offsetof(xfs_sb_t, sb_dummy),     1 },
+    { offsetof(xfs_sb_t, sb_logsectlog), 0 },
+    { offsetof(xfs_sb_t, sb_logsectsize),0 },
     { offsetof(xfs_sb_t, sb_logsunit),  0 },
+    { offsetof(xfs_sb_t, sb_features2),         0 },
     { sizeof(xfs_sb_t),                 0 }
 };

had the sb_dummy field as "no translate" so it effectively ignored it
but it ensured that sb_dirblklog was sized correctly.

The real bug here was whoever removed the dummy field and did not
replace that with a comment ot say that the xfs_sb strucutre needs
to be padded to 64 bits to ensure translation worked properly
on 64 bit systems.

I'd prefer explicit padding (with warning comments) over packing
the structure. Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
