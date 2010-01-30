Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UJA8Md231103 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 13:10:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8859C1C92398
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:11:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uT0aLcH3FAOakiF7 for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:11:15 -0800 (PST)
Date: Sat, 30 Jan 2010 14:11:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
Message-ID: <20100130191113.GC10181@infradead.org>
References: <4B633F9A.8000404@sandeen.net>
	<20100130105501.GA22909@infradead.org>
	<4B645B0D.205@sandeen.net> <20100130172502.GA788@thunk.org>
	<4B647AFE.5000507@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B647AFE.5000507@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, ext4 development <linux-ext4@vger.kernel.org>, tytso@mit.edu, Giel de Nijs <giel@vectorwise.com>, xfs-oss <xfs@oss.sgi.com>

On Sat, Jan 30, 2010 at 12:31:26PM -0600, Eric Sandeen wrote:
> These are the deps that I know xfstests has, to build and to run:
> 
> BuildRequires:  autoconf, libtool, xfsprogs-devel, e2fsprogs-devel
> BuildRequires:  libacl-devel, libattr-devel, libaio-devel
> 
> Requires:       bash, xfsprogs, xfsdump, perl, acl, attr, bind-utils
> Requires:       bc, indent, quota
> 
> which isn't so bad...

Doesn't seem to bad.  Indent is afaik only needed for the weird 122 test
which doesn't apply to non-xfs filesystems.

> I'm not sure an xfsprogs dependency is so onerous; plenty has depended
> on e2fsprogs through the years and we've lived with that ;)  But
> the lag time for xfsprogs to use released xfs_io functionality is a
> bit of a bummer.
> 
> But I guess I don't have a great answer for who else uses xfs_io:

I use xfs_io in lots various local scripts.  It's a really handly
tool for exercising some of the more weird I/O related syscalls.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
