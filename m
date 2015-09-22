Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 006D67F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 11:12:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 060CDAC00A
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 09:12:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Nol3J3Ok1zFl8SZd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 09:12:47 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150922155104.GA2296@thunk.org>
References: <20150922155104.GA2296@thunk.org>
	<20150922152450.32539.55285.stgit@warthog.procyon.org.uk>
Subject: Re: [RFC PATCH 1/2] VFS: Kill use of O_LARGEFILE inside the kernel
MIME-Version: 1.0
Content-ID: <1457.1442938362.1@warthog.procyon.org.uk>
Date: Tue, 22 Sep 2015 17:12:42 +0100
Message-ID: <1458.1442938362@warthog.procyon.org.uk>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> wrote:

> So what this means is that on 32-bit systems, if we have a userspace
> program which isn't using the Largefile-enabled, and it opens a file
> which is larger than can be addressed with a 32-bit off_t, it can get
> surprised and possibly cause data loss.

Good point.  I was initially thinking that 32-bit userspace on a 64-bit system
would have O_LARGEFILE automatically enabled - but I guess it'll trap through
the compat entry points which avoid that.

That said, fanotify and xfs_open_by_handle() will both automatically set
O_LARGEFILE irrespectively of the 32-bitness of the original caller.

Further, path-based truncate() makes no checks based on file-largeness, unlike
ftruncate().

> Is this something we are willing to live with?  After all, there was a
> originally a really good reason for the O_LARGEFILE flag in the first
> place, and it was primarily about making sure that a non-LARGEFILE
> capable program would hard fail on the open, instead of after it had
> trashed the user's data.

Okay, that seems reasonable - but it still leaves truncate() dangling.  I'm
not sure there's a good answer to that, though.

> Was there a reason that motivated this change, other than just an
> clean up?

Overlayfs and one or two other places need to potentially apply O_LARGEFILE to
the things that they do on behalf of userspace - but other than suppressing
some size checks, it seems to be ignored by the filesystems and the VM.

I vaguely seem to remember that at one point there were still filesystems that
couldn't handle large files and would reject such opens - but they appear to
all have been fixed.

David

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
