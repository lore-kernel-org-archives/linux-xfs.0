Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A923B7FF6
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 21:37:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45525AC003
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 19:37:28 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	qknq6MHB4LjICR51 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 19:37:26 -0700 (PDT)
Received: by wibut5 with SMTP id ut5so6566304wib.1
	for <xfs@oss.sgi.com>; Wed, 03 Jun 2015 19:37:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+r1Zhh5oW+z_DwszUehhF+ke41soBzHPcC7QCYH9yV+0A=upA@mail.gmail.com>
References: <CA+r1Zhh5oW+z_DwszUehhF+ke41soBzHPcC7QCYH9yV+0A=upA@mail.gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 3 Jun 2015 22:36:54 -0400
Message-ID: <CAP=VYLppm7teN4LMpOAgXFunmDjnYLFV_mdbZTPaPWMqTwQPtg@mail.gmail.com>
Subject: Re: randconfig build error with next-20150603, in fs/xfs/xfs_inode.c
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
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Jun 3, 2015 at 12:31 PM, Jim Davis <jim.epost@gmail.com> wrote:
> Building with the attached random configuration file,
>
> fs/built-in.o: In function `xfs_ifree_cluster':
> /home/jim/linux/fs/xfs/xfs_inode.c:2268: undefined reference to `__umoddi3'

I don't think this is specific to a particular randconfig.

On ARM allmodconfig, I saw:

ERROR: "__aeabi_uldivmod" [fs/xfs/xfs.ko] undefined!

On powerpc with an older gcc-4.5 toolchain, I saw:

/bin/sh: line 1: 23453 Segmentation fault      powerpc-linux-ld -EB -m
elf64ppc -r -T /home/paul/git/linux-head/scripts/module-common.lds
arch/powerpc/lib/crtsavres.o --build-id -o fs/xfs/xfs.ko fs/xfs/xfs.o
fs/xfs/xfs.mod.o
make[2]: *** [fs/xfs/xfs.ko] Error 139

I have not investigated further than that.

Paul.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
