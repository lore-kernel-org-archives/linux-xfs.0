Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 05:56:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l78Cu8bm002902
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 05:56:11 -0700
Date: Wed, 8 Aug 2007 08:54:35 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into
 individual setattr functions (RESEND)
Message-Id: <20070808085435.722f2b10.jlayton@redhat.com>
In-Reply-To: <20070807171501.e31c4a97.akpm@linux-foundation.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

On Tue, 7 Aug 2007 17:15:01 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 6 Aug 2007 09:54:03 -0400
> Jeff Layton <jlayton@redhat.com> wrote:
> 
> > Apologies for the resend, but the original sending had the date in the
> > email header and it caused some of these to bounce...
> > 
> > ( Please consider trimming the Cc list if discussing some aspect of this
> > that doesn't concern everyone.)
> > 
> > When an unprivileged process attempts to modify a file that has the
> > setuid or setgid bits set, the VFS will attempt to clear these bits. The
> > VFS will set the ATTR_KILL_SUID or ATTR_KILL_SGID bits in the ia_valid
> > mask, and then call notify_change to clear these bits and set the mode
> > accordingly.
> > 
> > With a networked filesystem (NFS in particular but most likely others),
> > the client machine may not have credentials that allow for the clearing
> > of these bits. In some situations, this can lead to file corruption, or
> > to an operation failing outright because the setattr fails.
> > 
> > In this situation, we'd like to just leave the handling of this to
> > the server and ignore these bits. The problem is that by the time
> > nfs_setattr is called, the VFS has already reinterpreted the ATTR_KILL_*
> > bits into a mode change. We can't fix this in the filesystems where
> > this is a problem, as doing so would leave us having to second-guess
> > what the VFS wants us to do. So we need to change it so that filesystems
> > have more flexibility in how to interpret the ATTR_KILL_* bits.
> > 
> > The first patch in the following patchset moves this logic into a helper
> > function, and then only calls this helper function for inodes that do
> > not have a setattr operation defined. The subsequent patches fix up
> > individual filesystem setattr functions to call this helper function.
> > 
> > The upshot of this is that with this change, filesystems that define
> > a setattr inode operation are now responsible for handling the ATTR_KILL
> > bits as well. They can trivially do so by calling the helper, but they
> > must do so.
> > 
> > Some of the follow-on patches may not be strictly necessary, but I
> > decided that it was better to take the conservative approach and call
> > the helper when I wasn't sure. I've tried to CC the maintainers
> > for the individual filesystems as well where I could find them,
> > please let me know if there are others who should be informed.
> > 
> > Comments and suggestions appreciated...
> > 
> 
> From a purely practical standpoint: it's a concern that all filesytems need
> patching to continue to correctly function after this change.  There might
> be filesystems which you missed, and there are out-of-tree filesystems
> which won't be updated.
> 
> And I think the impact upon the out-of-tree filesystems would be fairly
> severe: they quietly and subtly get their secutiry guarantees broken (I
> think?)
> 

Yep. Any filesystem that declares a setattr op will have to deal with
the ATTR_KILL_S* flags themselves. The breakage will be silent too.

> Is there any way in which we can prevent these problems?  Say
> 
> - rename something so that unconverted filesystems will reliably fail to
>   compile?
> 

I suppose we could rename the .setattr inode operation to something
else, but then we'll be stuck with it for at least a while. That seems
sort of kludgey too...

> - leave existing filesystems alone, but add a new
>   inode_operations.setattr_jeff, which the networked filesytems can
>   implement, and teach core vfs to call setattr_jeff in preference to
>   setattr?
> 
> Something else?

There's also the approach suggested by Miklos: Add a new inode flag that
tells notify_change not to convert ATTR_KILL_S* flags into a mode
change. Basically, allow filesystems to "opt out" of that behavior. 

I'd definitly pick that over a new inode op. That would also allow the
default case be for the VFS to continue handling these flags.
Everything would continue to work but filesystems that need to handle
these flags differently would be able to do so.

Thoughts?

--
Jeff Layton <jlayton@redhat.com>
