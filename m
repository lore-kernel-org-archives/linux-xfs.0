Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50331 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934377AbeFLWR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 18:17:29 -0400
Received: by mail-wm0-f66.google.com with SMTP id e16-v6so1400059wmd.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jun 2018 15:17:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
From: Ilya Pronin <ipronin@twitter.com>
Date: Tue, 12 Jun 2018 15:17:27 -0700
Message-ID: <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
Subject: Re: Reading/changing projid of a symlink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

So the only way to remove a symlink from a project is to remove it?

Here's my use case. In Apache Mesos we use XFS project quotas for disk
space isolation. Every container sandbox is allocated its own project
ID. When the container terminates its project ID is unset from the
sandbox and files inside it, and can be used for other containers.
Sandboxes of terminated containers stay on the host for some time for
debugging, etc. With such approach the inability to remove projid from
symlinks presents a small problem: when a project ID is reused for a
new container, any lingering symlinks that still have that project ID
will contribute to disk usage of the new container. Typically not
much, but still that's inaccurate. I guess we'll need to change when
we "deallocate" projids.

On Tue, Jun 12, 2018 at 7:36 AM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> On Wed, May 30, 2018 at 05:26:46PM -0700, Ilya Pronin wrote:
>> Hello,
>>
>> I am trying to recursively check/change projid on a directory that
>> contains symlinks among other files. The way I do it is like this
>> (attributes reading part as an example, modulo error handling):
>>
>> oflags = O_NOFOLLOW | O_RDONLY;
>> if (S_ISDIR(stat->st_mode))
>>         oflags |= O_DIRECTORY;
>> if (S_ISLNK(stat->st_mode))
>>         oflags |= O_PATH;
>> fd = open(path, oflags, 0);
>> xfsctl(NULL, fd, XFS_IOC_FSGETXATTR, &attr);
>>
>> The xfsctl() call fails with EBADF. Apparently this is because
>> xfsctl() is implemented as ioctl(), at least on Linux, which doesn't
>> work with file descriptors obtained with O_PATH. Is there any way to
>> manipulate projid on symlinks?
>>
>
> Not sure if somebody already replied you, I couldn't find anything in my mbox,
> but you can't.
>
> Out of curiosity, why would you do that though?
>
>
>> Thanks!
>>
>> --
>> Ilya Pronin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Carlos



-- 
Ilya Pronin
