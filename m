Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 206777CA1
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 08:06:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 024C48F8033
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 06:06:25 -0800 (PST)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com
	[209.85.213.179]) by cuda.sgi.com with ESMTP id
	Bgrwr6JEHgyCKauN (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2016 06:06:14 -0800 (PST)
Received: by mail-ig0-f179.google.com with SMTP id y8so14318228igp.0
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 06:06:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160218133240.GA5228@lst.de>
References: <20160218133240.GA5228@lst.de>
Date: Thu, 18 Feb 2016 15:06:14 +0100
Message-ID: <CAMuHMdVixG0ihW4pMG7Zv3RgQ+g4nTfof0o4P_kmu7RRFyE9Rg@mail.gmail.com>
Subject: Re: [fengguang.wu@intel.com: [pnfs:xfs-nfsd-clone]
	57b7d25bf4c57ebe0fbd2d8c5b37edf503175e1f BUILD DONE]
From: Geert Uytterhoeven <geert@linux-m68k.org>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-m68k <linux-m68k@lists.linux-m68k.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com

Hi Christoph,

On Thu, Feb 18, 2016 at 2:32 PM, Christoph Hellwig <hch@lst.de> wrote:
> Looks like the structure size checker found it's first victim on m68k,
> which doesn't seem to pad to 4 byte boundaries.  I don't think it actually
> matters in practice as we'll always the hacky appromiation of a variable
> sized array behind it.  I guess we should move this to a modern C99 VLA
> and mark it as __packed?

Marking it __packed causes the compiler to assume that the other 32-bit
values may not be aligned.

You can add 2 padding bytes to struct xfs_attr_leaf_name_remote.
Or change name[1] to name[3].

> ----- Forwarded message from kbuild test robot <fengguang.wu@intel.com> -----
>
> Date: Thu, 18 Feb 2016 21:26:23 +0800
> From: kbuild test robot <fengguang.wu@intel.com>
> Subject: [pnfs:xfs-nfsd-clone] 57b7d25bf4c57ebe0fbd2d8c5b37edf503175e1f
>         BUILD DONE
> To: Christoph Hellwig <hch@lst.de>
>
> git://git.infradead.org/users/hch/pnfs.git  xfs-nfsd-clone
> 57b7d25bf4c57ebe0fbd2d8c5b37edf503175e1f  nfs4: fix stateid handling for the NFS v4.2 operations
>
> fs/xfs/xfs_ondisk.h:22:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
> fs/xfs/xfs_ondisk.h:74:2: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
> include/linux/compiler.h:502:38: error: call to '__compiletime_assert_74' declared with attribute error: XFS: sizeof(xfs_attr_leaf_name_remote_t) is wrong, expected 12

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
