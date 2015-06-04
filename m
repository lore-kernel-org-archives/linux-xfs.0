Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F75F7FF2
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 22:16:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B7A68F8065
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 20:16:07 -0700 (PDT)
Received: from mail.windriver.com (mail.windriver.com [147.11.1.11]) by
	cuda.sgi.com with ESMTP id WQnDOe7SnXCMyTks (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 20:16:06 -0700 (PDT)
Date: Wed, 3 Jun 2015 23:15:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: randconfig build error with next-20150603, in fs/xfs/xfs_inode.c
Message-ID: <20150604031557.GS29898@windriver.com>
References: <CA+r1Zhh5oW+z_DwszUehhF+ke41soBzHPcC7QCYH9yV+0A=upA@mail.gmail.com>
	<CAP=VYLppm7teN4LMpOAgXFunmDjnYLFV_mdbZTPaPWMqTwQPtg@mail.gmail.com>
	<20150604030103.GJ9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150604030103.GJ9143@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, xfs@oss.sgi.com, linux-next <linux-next@vger.kernel.org>, Jim Davis <jim.epost@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>

[Re: randconfig build error with next-20150603, in fs/xfs/xfs_inode.c] On 04/06/2015 (Thu 13:01) Dave Chinner wrote:

> On Wed, Jun 03, 2015 at 10:36:54PM -0400, Paul Gortmaker wrote:
> > On Wed, Jun 3, 2015 at 12:31 PM, Jim Davis <jim.epost@gmail.com> wrote:
> > > Building with the attached random configuration file,
> > >
> > > fs/built-in.o: In function `xfs_ifree_cluster':
> > > /home/jim/linux/fs/xfs/xfs_inode.c:2268: undefined reference to `__umoddi3'
> > 
> > I don't think this is specific to a particular randconfig.
> > 
> > On ARM allmodconfig, I saw:
> > 
> > ERROR: "__aeabi_uldivmod" [fs/xfs/xfs.ko] undefined!
> > 
> > On powerpc with an older gcc-4.5 toolchain, I saw:
> > 
> > /bin/sh: line 1: 23453 Segmentation fault      powerpc-linux-ld -EB -m
> > elf64ppc -r -T /home/paul/git/linux-head/scripts/module-common.lds
> > arch/powerpc/lib/crtsavres.o --build-id -o fs/xfs/xfs.ko fs/xfs/xfs.o
> > fs/xfs/xfs.mod.o
> > make[2]: *** [fs/xfs/xfs.ko] Error 139
> > 
> > I have not investigated further than that.
> 
> A fix is already pending. Probably be in tomorrow's linux-next
> build.

Thanks Dave -- sounds good.  After all, the whole point of linux-next is
to spot these and vet out arch/merge issues before they get merged.

No matter what level of arch and config coverage I try to do, it seems
linux-next still finds a corner case that I somehow missed.

Hopefully we don't lose sight of that underlying goal and we don't
inadvertently intimidate folks from requesting their changes to be added
to linux-next.

Paul.
--

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
