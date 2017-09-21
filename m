Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751436AbdIUNRv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 09:17:51 -0400
Date: Thu, 21 Sep 2017 15:17:46 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: pathconf syscall for linux
Message-ID: <20170921131746.ewi7fwiegufa77mn@rh_laptop>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
 <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
 <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
 <20170919155528.GA8907@infradead.org>
 <563513ad-afb5-4c76-9f38-4b2e79e7af8a@redhat.com>
 <20170919203719.GD731@infradead.org>
 <20170919231716.tmdiz3vnzretwrks@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919231716.tmdiz3vnzretwrks@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Florian Weimer <fweimer@redhat.com>, Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 07:17:16PM -0400, Theodore Ts'o wrote:
> On Tue, Sep 19, 2017 at 01:37:19PM -0700, Christoph Hellwig wrote:
> > On Tue, Sep 19, 2017 at 09:17:28PM +0200, Florian Weimer wrote:
> > > We have a significant backlog, but I don't expect opposition to patches
> > > implementing syscall wrappers which are just slightly generic (and
> > > pathconfat should really be fine).
> > > 
> > > Technically, pathconfat might be tricky to maintain if it's expected to be a
> > > variadic dispatcher function, and the accompanying UAPI header isn't very
> > > clean.
> > 
> > (f)pathconf is defined as:
> > 
> >        long fpathconf(int fd, int name);
> >        long pathconf(const char *path, int name);
> > 
> > so there really shouldn't be any issue.
> 
> There might be some tricky bits will be if glibc feels it needs to
> override the values returned by the kernel (if it believes it may
> impose some limitations due to its implementation).  Also, not all
> file systems will implement some or all pathconf parameters initially
> (or perhaps ever).  So should the VFS be responsible for returning
> some intelligent defaults, or glibc?
> 
> Also, will application programs want to know whether they are getting
> kernel values versus glibc's best guess (which may be depedent on the
> kernel version, modulo distributions / handset/tablet vendors who
> might decide to backport the syscall to their kernels)?
> 
> It might be a good idea to come to a rough agreement (between the
> kernel and glibc devs) about how to handle some of these practical
> issues up front.
> 
> Cheers,
> 
> 					- Ted

Hi,

I think that it's reasonable to expect that we will implement the
following basic set of options. If I am not mistaken this is the basic
set that must be implemented by pathconf/fpathconf and it's also the
set of options that currently has linux specific implementation (or just
value definition) in glibc.


I think that most of those can be implemented directly in the vfs with
some exceptions, where we'll need to ask the file system. However this
should not be problem to implement right away when we introduce
pathconf.

Here is the list, although I am still not sure about some of those. Any
clarification on these would help.

_PC_LINK_MAX		include/uapi/linux/limits.h (linux limits)
_PC_MAX_CANON		include/uapi/linux/limits.h (linux limits)
_PC_MAX_INPUT		linux limits
_PC_NAME_MAX		linux limits
_PC_PATH_MAX		linux limits
_PC_PIPE_BUF		linux limits
_PC_CHOWN_RESTRICTED	currently yes
_PC_NO_TRUNC		specified per fs (at least affs set at mount)
_PC_VDISABLE		include/linux/tty.h __DISABLED_CHAR
_PC_SYNC_IO		we support O_SYNC, the question is how is it
			honored ? Currently my system returns undefined
_PC_ASYNC_IO		Not sure what exctly is ment by async here ?
			We always do asynchronous IO unless O_SYNC
			My system returns undefined
_PC_PRIO_IO		no support
_PC_SOCK_MAXBUF		?
_PC_FILESIZEBITS	per fs (s_maxbytes)
_PC_REC_INCR_XFER_SIZE 	?
_PC_REC_MAX_XFER_SIZE	?
_PC_REC_MIN_XFER_SIZE	? block size ?
_PC_REC_XFER_ALIGN	per fs (block size)
_PC_ALLOC_SIZE_MIN	per fs (block size)
_PC_SYMLINK_MAX		per fs (but we do not have limit AFACT)
_PC_2_SYMLINKS		per fs (do we have fs that don't have symlinks ?


As for the cases where glibc want's to override the value returned by
the kernel - I am not sure in what scenarios will they need to do it,
but if they do, it's just a matter of changing it...Not sure that I
understand you concern.

Also, at the moment we do not even know if it's a guess or a value returned
by kernel, so I'd say it does not matter. It can only get better from here.

Adding libc-alpha so they can share some of their wisdom. It'd be very
appreciated.

Thanks!
-Lukas
