Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MESq4t088735 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:28:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F21F1EED1A1
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 07:28:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8EcYZhpfbsce0aBd for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 07:28:51 -0700 (PDT)
Date: Fri, 22 Jul 2011 10:28:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 1/3] configure.in: Declare a requirement for at
	least autoconf 2.50
Message-ID: <20110722142850.GB19681@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311292237-4155-1-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Jul 21, 2011 at 07:50:35PM -0400, Theodore Ts'o wrote:
> On Debian/Ubuntu systems, if autoconf version 2.13 is installed,
> autoconf will try to automatically figure out whether autoconf 2.13 or
> something more modern is required (since the autoconf maintainers,
> curses be upon them, didn't bother to maintain compatibility between
> autoconf 2.13 and 2.50).  Unfortunately, the hueristics aren't
> perfect, and although the configure.in file looks superficially like
> it will be compatible with autoconf 2.13, it isn't.  You will end up
> with a number of very subtle compilation failures if you use autoconf
> 2.13.
> 
> So declare a requirement for autoconf 2.50 using AC_PREREQ(2.50).

Thanks a lot, I've applied our xfsprogs and xfstests patches, and also
ported the change to the xfsdump and dmapi repositories.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
