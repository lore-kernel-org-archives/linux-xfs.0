Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Aug 2007 07:56:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l76Euebm015851
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2007 07:56:42 -0700
Message-Id: <200708061317.l76DHc8e001653@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Date: Wed, 25 Jul 2007 12:47:28 -0400
Subject: [PATCH 00/25] move handling of setuid/gid bits from VFS into individual setattr functions
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

( Please consider trimming the Cc list if discussing some aspect of this that doesn't concern everyone )

When an unprivileged process attempts to modify a file that has the
setuid or setgid bits set, the VFS will attempt to clear these bits. The
VFS will set the ATTR_KILL_SUID or ATTR_KILL_SGID bits in the ia_valid
mask, and then call notify_change to clear these bits and set the mode
accordingly.

With a networked filesystem (NFS in particular but most likely others),
the client machine may not have credentials that allow for the clearing
of these bits. In some situations, this can lead to file corruption, or
to an operation failing outright because the setattr fails.

In this situation, we'd like to just leave the handling of this to
the server and ignore these bits. The problem is that by the time
nfs_setattr is called, the VFS has already reinterpreted the ATTR_KILL_*
bits into a mode change. We can't fix this in the filesystems where
this is a problem, as doing so would leave us having to second-guess
what the VFS wants us to do. So we need to change it so that filesystems
have more flexibility in how to interpret the ATTR_KILL_* bits.

The first patch in the following patchset moves this logic into a helper
function, and then only calls this helper function for inodes that do
not have a setattr operation defined. The subsequent patches fix up
individual filesystem setattr functions to call this helper function.

The upshot of this is that with this change, filesystems that define
a setattr inode operation are now responsible for handling the ATTR_KILL
bits as well. They can trivially do so by calling the helper, but they
must do so.

Some of the follow-on patches may not be strictly necessary, but I
decided that it was better to take the conservative approach and call
the helper when I wasn't sure. I've tried to CC the maintainers
for the individual filesystems as well where I could find them,
please let me know if there are others who should be informed.

Comments and suggestions appreciated...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
