Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7EBEmjL144523 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 06:14:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CBFF1B3045B
	for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 04:15:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YVm89hW22fliNCrD for
	<xfs@oss.sgi.com>; Sat, 14 Aug 2010 04:15:15 -0700 (PDT)
Date: Sat, 14 Aug 2010 07:15:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: xfsprogs Debian mantainaince
Message-ID: <20100814111513.GA8214@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: nathans@debian.org, anibal@debian.org
Cc: xfs@oss.sgi.com

Hi Nathan, hi Anibal,

if seen the constant flipping between native and non-native uploads
for the xfsprogs Debian packages between the two of you and it's
slightly annoying.  I know Nathan likes maintaining the Debian packages
in git, which also makes life for us XFS developers trying to build
debian packages a lot easier.

What about a compromise?  We'll add a debian-<dist> branches to the
xfsprogs-dev repository where we can track the exact packages uploaded
to Debian, including the -2/-3 etc packages revisions that only get
uploaded to Debian, while all important packaging changes happen in
the master branch, so that it can also be built from git into a Debian
package.  The advantage is that all package maintaince happens in git,
git master can be packaged easily, and in addition we track all Debian
uploads in git as well.  The only big prerequisite is that we get
a kernel.org account for Anibal so that he can also commit to it
directly.

Also can we add xfs@oss.sgi.com to the Cc list for debian xfs
bugreports? I think most issues are upstream ones anyway, and
automatically sending them to the XFS list will get them a bigger
audience.

All this also applies to xfsdump and the dmapi package, too.

And one last request, any chance to get xfsprogs for -testing rebuilt
against libblkid now that util-linux-2.17 has finally made it into
testing?  Beeing able to use blkid for alignment detection will be
very important so that XFS on Debian can deal with 4k sector disks
and hardware RAID arrays out of the box.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
