Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 23:38:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4M6cCsc021735
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 23:38:12 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52757BC02C7
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 23:39:02 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id pBHwxY21a2ACCrSq for <xfs@oss.sgi.com>; Wed, 21 May 2008 23:39:02 -0700 (PDT)
Subject: Re: [patch] rudimetary fallocate support for xfs_io
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20080522061029.GO173056135@sgi.com>
References: <20080522061029.GO173056135@sgi.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 16:39:01 +1000
Message-Id: <1211438341.25294.506.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, 2008-05-22 at 16:10 +1000, David Chinner wrote:
> 
> +#if defined(__i386__)
> +#define __NR_fallocate 324
> +#elif defined(__x86_64__)
> +#define __NR_fallocate 285
> +#elif defined(__ia64__)
> +#define __NR_fallocate 1303
> +#endif
> +
> +static int
> +fallocate(int fd, int cmd, off64_t start, off64_t len)
> +{
> +       return syscall(__NR_fallocate, fd, cmd, start, len);
> +}

This will cause xfsprogs build breakage on any architecture
other than the above three; check out the approach taken in
xfs-cmds/attr/libattr/syscalls.c to avoid this (give ENOSYS
for the unknown archs).

cheers.

-- 
Nathan
