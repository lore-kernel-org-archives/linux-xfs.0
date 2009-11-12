Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nACG430L003610 for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 10:04:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65730D15BF3
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 08:04:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5sBAGZny7ofuTYNH for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2009 08:04:21 -0800 (PST)
Date: Thu, 12 Nov 2009 11:04:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: add discard support
Message-ID: <20091112160420.GB31050@infradead.org>
References: <20091007011850.GA32032@infradead.org>
	<1157959921.9631254878431584.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1157959921.9631254878431584.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


Adding the discard helper to the platform headers now causes the build
to fail for some external users of the xfs headers because off64_t doesn't
exist without the large file configure magic. E.g. for xfstests:

checking xfs/xfs.h usability... no
checking xfs/xfs.h presence... yes
configure: WARNING: xfs/xfs.h: present but cannot be compiled
configure: WARNING: xfs/xfs.h:     check for missing prerequisite headers?
configure: WARNING: xfs/xfs.h: see the Autoconf documentation
configure: WARNING: xfs/xfs.h:     section "Present But Cannot Be Compiled"
configure: WARNING: xfs/xfs.h: proceeding with the compiler's result
checking for xfs/xfs.h... no

commenting out the discard helper fixes this.  We might be able to just
switch to a int64_t or similar instead, even if that's a bit ugly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
