Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Aug 2007 12:26:11 -0700 (PDT)
Received: from pat.uio.no (pat.uio.no [129.240.10.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l76JQ2bm007224
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2007 12:26:04 -0700
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
From: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	 <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
	 <20070806141333.0f54ab17.jlayton@redhat.com>
	 <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 15:04:23 -0400
Message-Id: <1186427063.6616.59.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jlayton@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org, xfs@oss.sgi.com, joel.becker@oracle.com, wli@holomorphy.com, reiserfs-devel@vger.kernel.org, dhowells@redhat.com, fuse-devel@lists.sourceforge.net, jffs-dev@axis.com, user-mode-linux-user@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu

On Mon, 2007-08-06 at 20:28 +0200, Miklos Szeredi wrote:

> Your patch is changing the API in a very unsafe way, since there will
> be no error or warning on an unconverted fs.  And that could lead to
> security holes.
> 
> If we would rename the setattr method to setattr_new as well as
> changing it's behavior, that would be fine.  But I guess we do not
> want to do that.

Which "unconverted fses"? If we're talking out of tree stuff, then too
bad: it is _their_ responsibility to keep up with kernel changes.

Trond
