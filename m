Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0E0A7F58
	for <xfs@oss.sgi.com>; Sat, 17 Oct 2015 19:35:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F4BB8F8040
	for <xfs@oss.sgi.com>; Sat, 17 Oct 2015 17:35:40 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id FtgiHIGQQPYMcXcu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 17 Oct 2015 17:35:37 -0700 (PDT)
Date: Sat, 17 Oct 2015 20:35:32 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: Richacl support
Message-ID: <20151018003532.GD2678@thunk.org>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
	<20151016231615.GF15011@thunk.org>
	<CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
	<20151017143951.GA2678@thunk.org> <20151017225910.GT27164@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151017225910.GT27164@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, xfs@oss.sgi.com

On Sun, Oct 18, 2015 at 09:59:10AM +1100, Dave Chinner wrote:
> For XFS userspace we also need this feature bit for xfs_repair so
> that it doesn't attempt to validate the on-disk ACL format is in a
> valid posix ACL format. IOWs, we need an on-disk feature bit to
> indicate the on-disk format of the ACL in XFS.
> 
> Further, a user could mount the ext4 fs with "norichacl,acl" to
> force the kernel to parse the rich acls as posix acls because
> without a feature bit the fs does not know what format it's acls are
> in on-disk. This will only end in tears for users.

So at least for ext4, the richacl xattr using a completely different
index, and so it's not possible to interpret the richacl as an acl.
The only question is whether we pay attention to the richacl acl's at
all.  One thing that's not clear to me is what VFS is supposed to do
if an inode has both an Posix ACL xattr and a Richacl xattr at the
same time.

We're also not trying to validate the on-disk ACL format at all using
e2fsck, just as we're not trying to validate say, the SELinux xattr.
They are just bags of bits as far as e2fsck is concerned.  So for that
reason, at least as the patches I've seen for richacl for ext4,
e2fsprogs doesn't actually need a file system feature bit at all.  We
could in theory use the 1.42 version of e2fsck against an ext4 file
system with richacl, and modulo the incompat flag, there wouldn't be
any problems from e2fsck point of view.

What Andreas G. has said is that the only problem is if the file
system is mounted read/write, and someone creates an inode on a
non-richacl knowledgeable kernel, the inode would get created w/o an
richacl.  This might be surprising to the user if he or she was
expecting richacl semantics, but that would only happen if they had
say, enabled richacl's on a distribution that had full richacl support
(including the richacl userspace utilities so they could set and get
richacl entries), and then booted an older kernel on that
distribution.  This doesn't seem like _that_ likely a scenario, but I
suppose it could happen.  And whether you call the file system
"inconsistent" really depends on your point of view.  From the
perspective of fsck, which for ext4 is completely, happily ignorant of
richacl support, it's not inconsistent and all of the inodes are
valid.

> I asked this same question on the kernel side of things. While I
> think that from an "on-disk consistency" POV using RO_INCOMPAT would
> be fine, from a user visible POV the behaviour won't be compatible
> and so INCOMPAT makes sense from that perspective.

If you believe that the only real use of richacl will be primarily for
supporting Samba and NFSv4 servers, then using a read-only compat
feature flag isn't that terrible, and it might be helpful in the case
of someone using a rescue media that hasn't been updated yet to be
able to access the system --- since it seems unlikely that the user
would try to launch a Samba or NFSv4 server from a rescue CD.

But I different people of good will can differ with each other, and at
the end of the day I don't think it makes *that* much difference
unless we drop the use of the feature flag entirely.  Given that
systemd has infected all of the distributions, and systemd is getting
more and more tightly integrated into modern kernel features w/o
offerring backwards compatibility, it seems very likely to me that you
wouldn't even be able to *boot* a downrev kernel on a modern
distribution that has richacl support without seeing systemd or its
dependencies explode into millions of tiny pleaces, so I'm not that
terribly worried one way or another.  :-)

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
