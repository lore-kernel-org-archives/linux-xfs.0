Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Aug 2007 11:14:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l76IE9bm013784
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2007 11:14:11 -0700
Date: Mon, 6 Aug 2007 14:13:33 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
 notify_change into helper function
Message-Id: <20070806141333.0f54ab17.jlayton@redhat.com>
In-Reply-To: <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	<E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, codalist@TELEMANN.coda.cs.cmu.edu, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org, xfs@oss.sgi.com, joel.becker@oracle.com, wli@holomorphy.com, reiserfs-devel@vger.kernel.org, dhowells@redhat.com, fuse-devel@lists.sourceforge.net, jffs-dev@axis.com, user-mode-linux-user@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu

On Mon, 06 Aug 2007 19:43:46 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> > Separate the handling of the local ia_valid bitmask from the one in
> > attr->ia_valid. This allows us to hand off the actual handling of the
> > ATTR_KILL_* flags to the .setattr i_op when one is defined.
> > 
> > notify_change still needs to process those flags for the local ia_valid
> > variable, since it uses that to decide whether to return early, and to pass
> > a (hopefully) appropriate bitmask to fsnotify_change.
> 
> I agree with this change and fuse will make use of it as well.
> 
> Maybe instead of unconditionally moving attr_kill_to_mode() inside
> ->setattr() it could be made conditional based on an inode flag
> similarly to S_NOCMTIME.  Advantages:
> 
>  - no need to modify a lot of in-tree filesystems
>  - no silent breakage of out-of-tree fs
> 
> Actually I think the new flag would be used by exacly the same
> filesystems as S_NOCMTIME, so maybe it would make sense to rename
> S_NOCMTIME to something more generic (S_NOATTRUPDATE or whatever) and
> use that.
> 
> But that could still break out-of-tree fs, so a separate flag is
> probably better.
> 

In the past I've been told that adding new flags is something of a
"last resort". Since it's not strictly necessary to fix this then
it may be best to avoid that.

That said, if the concensus is that we need a transition mechanism,
then I'd be open to such a suggestion.

-- 
Jeff Layton <jlayton@redhat.com>
