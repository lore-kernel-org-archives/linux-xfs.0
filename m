Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34307 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbeFMJkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jun 2018 05:40:52 -0400
Received: by mail-wm0-f67.google.com with SMTP id l15-v6so17982619wmc.1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jun 2018 02:40:51 -0700 (PDT)
Date: Wed, 13 Jun 2018 11:40:48 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Reading/changing projid of a symlink
Message-ID: <20180613094048.6becmt42cvdhvg66@odin.usersys.redhat.com>
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
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 12, 2018 at 03:17:27PM -0700, Ilya Pronin wrote:
> So the only way to remove a symlink from a project is to remove it?
> 

Well, basically, yes.


> Here's my use case. In Apache Mesos we use XFS project quotas for disk
> space isolation. Every container sandbox is allocated its own project
> ID. When the container terminates its project ID is unset from the
> sandbox and files inside it, and can be used for other containers.
> Sandboxes of terminated containers stay on the host for some time for
> debugging, etc.

> With such approach the inability to remove projid from
> symlinks presents a small problem: when a project ID is reused for a
> new container, any lingering symlinks that still have that project ID
> will contribute to disk usage of the new container. Typically not
> much, but still that's inaccurate. I guess we'll need to change when
> we "deallocate" projids.

Hm, well, I see what you mean, but, as you said, xfs uses special xattrs to
manage inode quota information, handled by ioctl()s. Which, are not possible to
be issued in a symlink inode.

A few comments from my POV about it:

- Most of the space used in the project's quota by a symlink, is the space used
by the inode itself, unless you have really long links which don't fit into the
inode's literal area.
- Also, the space used by its directory entry in symlink's parent directory.

The symlink's project id, will always be related to the project id of its parent
directory.


At the end, Project quota, is a way to create a directory tree based quota,
where all inodes corresponding to a single project id, should be under the same
subtree. If you are creating a new subtree, under an already existing project
id, IMHO, the right approach would be to remove the project id from the old
directory tree, and add it to the new tree, and use user/group quotas for any
quota accounting that should be done filesystem-wide (instead of directory tree
wise). Still, this is just my opinion.

But at the end, you can't manually change symlink's project ids.

Cheers.

> 
> On Tue, Jun 12, 2018 at 7:36 AM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> > On Wed, May 30, 2018 at 05:26:46PM -0700, Ilya Pronin wrote:
> >> Hello,
> >>
> >> I am trying to recursively check/change projid on a directory that
> >> contains symlinks among other files. The way I do it is like this
> >> (attributes reading part as an example, modulo error handling):
> >>
> >> oflags = O_NOFOLLOW | O_RDONLY;
> >> if (S_ISDIR(stat->st_mode))
> >>         oflags |= O_DIRECTORY;
> >> if (S_ISLNK(stat->st_mode))
> >>         oflags |= O_PATH;
> >> fd = open(path, oflags, 0);
> >> xfsctl(NULL, fd, XFS_IOC_FSGETXATTR, &attr);
> >>
> >> The xfsctl() call fails with EBADF. Apparently this is because
> >> xfsctl() is implemented as ioctl(), at least on Linux, which doesn't
> >> work with file descriptors obtained with O_PATH. Is there any way to
> >> manipulate projid on symlinks?
> >>
> >
> > Not sure if somebody already replied you, I couldn't find anything in my mbox,
> > but you can't.
> >
> > Out of curiosity, why would you do that though?
> >
> >
> >> Thanks!
> >>
> >> --
> >> Ilya Pronin
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > Carlos
> 
> 
> 
> -- 
> Ilya Pronin

-- 
Carlos
