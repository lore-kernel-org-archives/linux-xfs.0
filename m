Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96Fjsi3075289 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 10:45:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF0731324C12
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 08:47:19 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id yqmeHGZZm87n9Qc1 for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 08:47:19 -0700 (PDT)
Message-ID: <4ACB6686.9080205@sandeen.net>
Date: Tue, 06 Oct 2009 10:47:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: moving libhandle to /usr
References: <20091006154249.GA1411@infradead.org>
In-Reply-To: <20091006154249.GA1411@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: nathans@debian.org, vapier@gentoo.org, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Currently we install the versioned libhandle into /lib by default,
> and all other libraries into /usr.  Given that no program in / actually
> uses libhandle this seems rather awkward to me.  From Mike's comments
> in the past I think Gentoo already installs it into /usr anyway.
> 
> Is there anything speaking against moving all libraries to /usr and
> switching Debian/Fedora to that aswell? 
> 

Seems fine to me;

/sbin/fsck.xfs:
	not a dynamic executable
/sbin/mkfs.xfs:
	libuuid.so.1 => /lib64/libuuid.so.1 (0x0000003327e00000)
	librt.so.1 => /lib64/librt.so.1 (0x0000003df3e00000)
	libpthread.so.0 => /lib64/libpthread.so.0 (0x0000003df2e00000)
	libc.so.6 => /lib64/libc.so.6 (0x0000003df2200000)
	/lib64/ld-linux-x86-64.so.2 (0x0000003df1e00000)
/sbin/xfs_repair:
	libuuid.so.1 => /lib64/libuuid.so.1 (0x0000003327e00000)
	librt.so.1 => /lib64/librt.so.1 (0x0000003df3e00000)
	libpthread.so.0 => /lib64/libpthread.so.0 (0x0000003df2e00000)
	libc.so.6 => /lib64/libc.so.6 (0x0000003df2200000)
	/lib64/ld-linux-x86-64.so.2 (0x0000003df1e00000)


As you say, nothing in /sbin needs it AFAICT.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
