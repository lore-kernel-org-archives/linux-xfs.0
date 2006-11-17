Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Nov 2006 07:54:52 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAHFsgaG024766
	for <xfs@oss.sgi.com>; Fri, 17 Nov 2006 07:54:44 -0800
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 953A9D1D7043
	for <xfs@oss.sgi.com>; Fri, 17 Nov 2006 07:53:51 -0800 (PST)
Message-ID: <455DDB0D.7000005@thebarn.com>
Date: Fri, 17 Nov 2006 09:53:49 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net> <20061116224527.GF11034@melbourne.sgi.com>
In-Reply-To: <20061116224527.GF11034@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

David Chinner wrote:

>
>@@ -135,9 +136,12 @@
>        __uint8_t       sb_shared_vn;   /* shared version number */
>        xfs_extlen_t    sb_inoalignmt;  /* inode chunk alignment, fsblocks */
>        __uint32_t      sb_unit;        /* stripe or raid unit */
>-       __uint32_t      sb_width;       /* stripe or raid width */
>+       __uint32_t      sb_width;       /* stripe or raid width */
>        __uint8_t       sb_dirblklog;   /* log2 of dir block size (fsbs) */
>-        __uint8_t       sb_dummy[7];    /* padding */
>+       __uint8_t       sb_logsectlog;  /* log2 of the log sector size */
>+       __uint16_t      sb_logsectsize; /* sector size for the log, bytes */
>+       __uint32_t      sb_logsunit;    /* stripe unit size for the log */
>+       __uint32_t      sb_features2;   /* additional feature bits */
> } xfs_sb_t;
>
>So before the sector size > 512 bytes code, there was padding to push the
>superblock out to 64bit alignement so that sb_dirblklog was correctly aligned.
>The xfs_sb_info structure:
>
>     { offsetof(xfs_sb_t, sb_unit),      0 },
>     { offsetof(xfs_sb_t, sb_width),     0 },
>     { offsetof(xfs_sb_t, sb_dirblklog),         0 },
>-    { offsetof(xfs_sb_t, sb_dummy),     1 },
>+    { offsetof(xfs_sb_t, sb_logsectlog), 0 },
>+    { offsetof(xfs_sb_t, sb_logsectsize),0 },
>     { offsetof(xfs_sb_t, sb_logsunit),  0 },
>+    { offsetof(xfs_sb_t, sb_features2),         0 },
>     { sizeof(xfs_sb_t),                 0 }
> };
>
>had the sb_dummy field as "no translate" so it effectively ignored it
>but it ensured that sb_dirblklog was sized correctly.
>
>The real bug here was whoever removed the dummy field and did not
>replace that with a comment ot say that the xfs_sb strucutre needs
>to be padded to 64 bits to ensure translation worked properly
>on 64 bit systems.
>
>I'd prefer explicit padding (with warning comments) over packing
>the structure. Thoughts?
>  
>
That seems safer to me and the comments will make the next  person to 
muck with
the structure think about padding.

>Cheers,
>
>Dave.
>  
>
