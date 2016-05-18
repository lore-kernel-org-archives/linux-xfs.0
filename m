Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADE437CA0
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 15:44:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23D5DAC001
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 13:44:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2SjvdXfqFnyMtDEu for <xfs@oss.sgi.com>;
	Wed, 18 May 2016 13:44:47 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5E8439E
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 15:44:47 -0500 (CDT)
Subject: Re: struct fsxattr redefinition
References: <20160518163733.GB14165@tarantula.localdomain>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <237c0dad-b27a-7fa0-6283-2832ca00ac43@sandeen.net>
Date: Wed, 18 May 2016 15:44:46 -0500
MIME-Version: 1.0
In-Reply-To: <20160518163733.GB14165@tarantula.localdomain>
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
To: xfs@oss.sgi.com

On 5/18/16 11:37 AM, Jeffrey Bastian wrote:
> There was a discussion a few months ago about adding a guard for the
> fsxattr struct [0] because it's defined in two places, the Linux kernel
> header linux/fs.h [1] and xfsprogs header xfs/linux.h [2].

> xfs/linux.h has a FS_IOC_FSGETXATTR guard around the struct fsxattr
> definition, but this only works if linux/fs.h is included *before*
> xfs/linux.h (or xfs/xfs.h).  If you include linux/fs.h after, then you
> get a struct redefinition error.
> 
> Is it a requirement that linux/fs.h is included first?  If so, then
> there is a bug in xfstests because it includes them in the wrong order
> [3] and fails to build.  If there is not an order requirement, then both
> header files should probably have a HAVE_FSXATTR guard around the struct
> definition.

It seems best to me to include fs.h first.  That may not be written in
stone, but it's at least common practice.

Having the same definition in both places, and guards going both ways,
seems a little odd though.

Maybe xfsprogs' include/linux.h should just directly include
the kernel's linux/fs.h at the top - would that make sense?

-Eric

> [0] http://oss.sgi.com/archives/xfs/2016-02/msg00306.html
> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/fs.h?h=v4.6#n152
> [2] http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=include/linux.h;h=cc0f70ceed72406822885d878b939b3e66c03ffd;hb=53cefc406eb1047ce9dc85906a0117f8da9f44ca#l177
> [3] http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=blob;f=src/t_immutable.c;h=87ffc75f2d0229941ad6c5235ce9deea272d66c9;hb=HEAD#l41
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
