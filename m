Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:42774 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbeJBIfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 04:35:01 -0400
Date: Tue, 2 Oct 2018 02:54:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] vfs: check ->get_link return value
Message-ID: <20181002015410.GM32577@ZenIV.linux.org.uk>
References: <20181001224500.GE5872@magnolia>
 <20181001235251.GA10425@bombadil.infradead.org>
 <20181002002332.GA6706@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002002332.GA6706@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Mon, Oct 01, 2018 at 05:23:32PM -0700, Darrick J. Wong wrote:

> get_link doesn't need the EFSCORRUPTED return; all two of its callers
> handle null pointer returns correctly and they don't return the ->get_link
> return value directly to userspace.
> 
> It's just these two functions below whose callers assume they have to
> deal an error pointer or that it's totally safe to dereference it.

No.  The only case when ->get_link() has any business returning NULL is
when it has done nd_jump_link().  Those should never come without explicit
->readlink() and they should never be fed to vfs_get_link(), so they are
not a problem; anything else is a filesystem driver bug, plain and simple.

Check for NULL in fs/namei.c:get_link() is *NOT* "defensive programming"
bullshit; there it can legitimately happen (aforementioned procfs-style
symlinks).  Note that there it is not an error at all.

Current calling conventions are:
	* return ERR_PTR(-E...) on error
	* return pointer to symlink body to be traversed on success
	* return NULL when ->get_link() instances has jumped to destination
on its own and there's no "symlink body" to be traversed.  For such symlinks
we obviously need an explicit ->readlink() (for whatever string we want
readlink(2) to return).  These should not be occur on anything NFS-exported
or on overlayfs layers, since neither NFSD nor overlayfs don't know what
to do with such.

What you are proposing is a weird change along the lines of "if you
accidentally return NULL it will be treated as empty body, except when it
occurs on NFS exports or overlayfs layers; in such cases it will be
interpreted as fs corruption.  $DEITY help you if real procfs-style
symlink hits one of those, since nd_jump_link() called by those will
oops in such conditions".

As a mitigation strategy it sucks.  As part of calling conventions it's
confusing and AFAICS absolutely pointless.

NAK.  And I'm really curious - what has lead to that?  Because procfs-style
symlink in such conditions would have oopsed before it returned from
->get_link()...
