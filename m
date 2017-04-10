Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751705AbdDJIBa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 04:01:30 -0400
Date: Mon, 10 Apr 2017 16:01:27 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by
 chattr [ver #12]
Message-ID: <20170410080127.GD22845@eguan.usersys.redhat.com>
References: <149168615504.10019.12886002807349389794.stgit@warthog.procyon.org.uk>
 <149168617693.10019.12322515006388694205.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149168617693.10019.12322515006388694205.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, Apr 08, 2017 at 10:16:16PM +0100, David Howells wrote:
> diff --git a/src/statx.h b/src/statx.h
> index 711d1ba..f361a68 100644
> --- a/src/statx.h
> +++ b/src/statx.h
> @@ -19,7 +19,7 @@
>  #define __NR_statx 383
>  #elif defined (__ILP32__)
>  #define __NR_statx (__X32_SYSCALL_BIT + 332)
> -#else
> +#elif defined(__x86_64__)
>  #define __NR_statx 332
>  #endif

Seems like this only enables statx(2) test on specific arches, even if
current arch has wired up statx syscall.

For example, I noticed as for 4.11-rc6 kernel, many platforms have
enabled statx syscall:

eguan@eguan:~/workspace/src/kernel$ git lo | grep -i "wire up statx"
1493aa6 xtensa: wire up statx system call
fdfe4a3 generic syscalls: Wire up statx syscall
e3b1ebd m68k: Wire up statx
f717629 powerpc: Wire up statx() syscall
63d32d1 parisc: Wire up statx system call
a1016e9 ARM: wire up statx syscall
8bd49ac s390: wire up statx system call
9cb74b5 MIPS: Wire up statx system call

But many of them are not covered in this test. (Tested with ppc64 host
and test _notrun there.)

How about including <sys/syscall.h> to get __NR_statx definition first
and define our own syscall number only if it's not yet defined?

Thanks,
Eryu

>  
> @@ -159,7 +159,12 @@ static inline
>  int xfstests_statx(int dfd, const char *filename, unsigned flags,
>  		   unsigned int mask, struct statx *buffer)
>  {
> +#ifdef __NR_statx
>  	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
> +#else
> +	errno = ENOSYS;
> +	return -1;
> +#endif
>  }
