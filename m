Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933469AbeFMGXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jun 2018 02:23:42 -0400
Date: Tue, 12 Jun 2018 23:23:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Reading/changing projid of a symlink
Message-ID: <20180613062341.GA24317@infradead.org>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
 <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Pronin <ipronin@twitter.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

On Tue, Jun 12, 2018 at 03:17:27PM -0700, Ilya Pronin wrote:
> So the only way to remove a symlink from a project is to remove it?

Yes.

> Here's my use case. In Apache Mesos we use XFS project quotas for disk
> space isolation. Every container sandbox is allocated its own project
> ID. When the container terminates its project ID is unset from the
> sandbox and files inside it, and can be used for other containers.
> Sandboxes of terminated containers stay on the host for some time for
> debugging, etc. With such approach the inability to remove projid from
> symlinks presents a small problem: when a project ID is reused for a
> new container, any lingering symlinks that still have that project ID
> will contribute to disk usage of the new container. Typically not
> much, but still that's inaccurate. I guess we'll need to change when
> we "deallocate" projids.

There isn't really much we can do in XFS about it.  Traditionally in
all Unix variants you can never get a file descriptor for a symlink,
and all normal file operations always follow symlinks.  So you need
special new syscalls to handle the symlink.  Now Linux added the
O_PATH mount option a while ago which actually allows you to get
a file descriptor on symlinks, but just very limited ones that do
not actually support calls into the underlying file system.

So to support your use case we'd either need a new lioctl system
call, or some way to support limited ioctls on O_PATH fds.  Either
would be a VFS change and would turn into a huge discussion.  Once
that is done however wiring up the XFS bits would be trivial.
