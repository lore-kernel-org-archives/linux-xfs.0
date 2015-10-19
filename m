Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 087C87F58
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 19:17:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC9D9304032
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 17:17:08 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id rDQTcqbGB86f4RiX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2015 17:17:07 -0700 (PDT)
Date: Sun, 18 Oct 2015 20:17:04 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: Richacl support
Message-ID: <20151019001704.GQ2678@thunk.org>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
	<20151016231615.GF15011@thunk.org>
	<CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
	<20151017143951.GA2678@thunk.org> <20151017225910.GT27164@dastard>
	<20151018003532.GD2678@thunk.org>
	<CAHc6FU6U-r4YjxdvhW_OAmdekzK-tBT62Hs_JBYFB0V65qDw4w@mail.gmail.com>
	<20151018214456.GM2678@thunk.org>
	<CAHc6FU7J9OESpAJzOKOmu-UP-bC_kzKT-oVg-MVKAaVzswOacA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU7J9OESpAJzOKOmu-UP-bC_kzKT-oVg-MVKAaVzswOacA@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Oct 19, 2015 at 12:46:49AM +0200, Andreas Gruenbacher wrote:
> The filesystem sets the MS_POSIXACL super-block flag for POSIX ACLs or
> the MS_RICHACL super-block flag for richacls. These flags are checked
> with the IS_POSIXACL(inode) and IS_RICHACL(inode) macros.

Ah, OK.  So it's either one thing or another.

> I can send the validation code; not sure how removing corrupt xattrs
> would fit into e2fsck though. Can e2fsck remove individual xattrs?

Yep.  Using the libext2fs function ext2fs_xattr_remove(), in
lib/ext2fs/ext_attr.c.  This requires the development branch of
e2fsprogs, but by adding a new feature flag, richacl is going to
require a 1.43 version of e2fsprogs (not yet released, but hopefully
will be released soon).

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
