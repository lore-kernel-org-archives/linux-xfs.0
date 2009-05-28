Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SEu2eU259652 for <xfs@oss.sgi.com>; Thu, 28 May 2009 09:56:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40D8B1A3535F
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 07:56:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1qQgncru7xcK5Bg2 for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 07:56:15 -0700 (PDT)
Date: Thu, 28 May 2009 10:56:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: regarding the inode64 mount option
Message-ID: <20090528145612.GA14684@infradead.org>
References: <4A1E81D8.7010706@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1E81D8.7010706@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Thu, May 28, 2009 at 02:21:44PM +0200, Michael Weissenbacher wrote:
> Hi XFS-List!
> I understand that the inode64 mount option allows inodes to be created beyond 1TB. There are also certain performance problems that can be cured by using this option when handling LOTS of inodes. During my tests i noticed that enabling it is like a one-way street. Inodes created with inode64 enabled aren't accessible when the option is left out.

Actually they should still be accessible, we just won't create new
inodes not addressable by 32bit inode numbers.

> Now i got a few questions:
> - Does the inode64 option work only on 64bit architectures or is it also possible to use it with i686

It is available for 32bit kernels starting with kernel 2.6.29.

> - Is there a way to convert the inodes back

There's an xfs_reno tool ported from IRIX to renumber the inodes.  I'll
see if I can finally get it packaged.

> - Why doesn't the filesystem remember that inode64 was used in the past and enable it automatically

Good question.  We could introduce a flag in the superblock for this.

> - Do i have to pass inode64 via grub / lilo if i want to use it on my root filesystem

Yes.

> I haven't found any definitive clear documentation abount the pro's and con's, so maybe you can give me some hints :-)

The only reason speaking against inode64 are old buggy programs that
can't cope with a 64bit ino_t, Eric had a quite scary list of those
in Fedora somewhere..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
