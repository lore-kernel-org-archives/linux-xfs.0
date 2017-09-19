Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41530 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751614AbdISXR0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 19:17:26 -0400
Date: Tue, 19 Sep 2017 19:17:16 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Message-ID: <20170919231716.tmdiz3vnzretwrks@thunk.org>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
 <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
 <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
 <20170919155528.GA8907@infradead.org>
 <563513ad-afb5-4c76-9f38-4b2e79e7af8a@redhat.com>
 <20170919203719.GD731@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919203719.GD731@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Florian Weimer <fweimer@redhat.com>, Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 01:37:19PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 09:17:28PM +0200, Florian Weimer wrote:
> > We have a significant backlog, but I don't expect opposition to patches
> > implementing syscall wrappers which are just slightly generic (and
> > pathconfat should really be fine).
> > 
> > Technically, pathconfat might be tricky to maintain if it's expected to be a
> > variadic dispatcher function, and the accompanying UAPI header isn't very
> > clean.
> 
> (f)pathconf is defined as:
> 
>        long fpathconf(int fd, int name);
>        long pathconf(const char *path, int name);
> 
> so there really shouldn't be any issue.

There might be some tricky bits will be if glibc feels it needs to
override the values returned by the kernel (if it believes it may
impose some limitations due to its implementation).  Also, not all
file systems will implement some or all pathconf parameters initially
(or perhaps ever).  So should the VFS be responsible for returning
some intelligent defaults, or glibc?

Also, will application programs want to know whether they are getting
kernel values versus glibc's best guess (which may be depedent on the
kernel version, modulo distributions / handset/tablet vendors who
might decide to backport the syscall to their kernels)?

It might be a good idea to come to a rough agreement (between the
kernel and glibc devs) about how to handle some of these practical
issues up front.

Cheers,

					- Ted
