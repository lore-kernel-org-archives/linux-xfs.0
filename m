Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BEE77F3F
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 16:45:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16608AC002
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 14:45:05 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 7S3960e7fOt6NjkO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2015 14:45:00 -0700 (PDT)
Date: Sun, 18 Oct 2015 17:44:56 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: Richacl support
Message-ID: <20151018214456.GM2678@thunk.org>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
	<20151016231615.GF15011@thunk.org>
	<CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
	<20151017143951.GA2678@thunk.org> <20151017225910.GT27164@dastard>
	<20151018003532.GD2678@thunk.org>
	<CAHc6FU6U-r4YjxdvhW_OAmdekzK-tBT62Hs_JBYFB0V65qDw4w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU6U-r4YjxdvhW_OAmdekzK-tBT62Hs_JBYFB0V65qDw4w@mail.gmail.com>
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

On Sun, Oct 18, 2015 at 10:46:23PM +0200, Andreas Gruenbacher wrote:
> > The only question is whether we pay attention to the richacl acl's at
> > all.  One thing that's not clear to me is what VFS is supposed to do
> > if an inode has both an Posix ACL xattr and a Richacl xattr at the
> > same time.
> 
> The VFS will either look for POSIX ACLs or for a richacl; it won't
> even notice if both are present.

How does this work in practice?  Does it look for richacl's first, and
if it doesn't find it, it will then look for a Posix ACL, or vice
versa?

> Right now, filesystems that e2fsck is perfectly happy with can still
> cause errors when used. It would be nice to fix that.
> 
> With POSIX ACLs, this problem is slightly less severe because the ACL
> isn't looked at for the owner; it would even be possible to replace a
> corrupted POSIX ACL. Richacls unfortunately don't allow this
> optimization.

Is there code we can use to verify a richacl, and if it's corrupted,
what are the options about how we can fix it?  Or do we just remove
it, and just use the inode's i_uid field for the owner instead of
whatever might be in the richacl?

Ideally, if you can send the patch to add support to validate / fix
Richacl's in e2fsck, that would be great.

> This really should be a feature flag and not a mount option, it just
> doesn't make sense to switch at mount time.
> 
> From this discussion, I'm even more convinced that we should use an
> incompat feature rather than a ro-incompat feature.

OK, let's go with that.

    	  					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
