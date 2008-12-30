Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUCnfXM012600 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 06:49:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91C4217967BE
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 04:49:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BPX7TIT2MdAH3TqT for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 04:49:37 -0800 (PST)
Date: Tue, 30 Dec 2008 07:49:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs-cmds: fix parallel installs in include/ dirs
Message-ID: <20081230124936.GA26322@infradead.org>
References: <49594CD9.3010402@sandeen.net>
	<20081230115224.GA24210@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081230115224.GA24210@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 30, 2008 at 06:52:24AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 29, 2008 at 04:19:05PM -0600, Eric Sandeen wrote:
> > This is for http://oss.sgi.com/bugzilla/show_bug.cgi?id=759
> > "fix parallel issue with include/ symlinks"
> > 
> > Doing something like "make -j2 install install-dev" would lead
> > to a race of removing & creating symlinks in include/
> > 
> > Thanks to Mike for reporting & suggesting the fix.
> 
> Looks good and I've put in in my queue.

Actually spoken too soon.   This breaks the acl build for me with:

 gcc -g -O2 -DNDEBUG -funsigned-char -fno-strict-aliasing -Wall
 -DVERSION=\"2.2.47\" -DLOCALEDIR=\"/usr/share/locale\"
 -DPACKAGE=\"acl\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64
 -include perm_copy.h -c acl_get_fd.c  -fPIC -DPIC -o .libs/acl_get_fd.o
 acl_get_fd.c:27:24: error: acl/libacl.h: No such file or directory
 acl_get_fd.c: In function 'acl_get_fd':
 acl_get_fd.c:62: warning: implicit declaration of function
 'acl_from_mode'
 acl_get_fd.c:62: warning: return makes pointer from integer without a
 cast

It looks like the acl link in include/ doesn't get created properly
with this patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
