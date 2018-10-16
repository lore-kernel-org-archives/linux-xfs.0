Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f54.google.com ([209.85.221.54]:46816 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeJPUri (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Oct 2018 16:47:38 -0400
Received: by mail-wr1-f54.google.com with SMTP id n11-v6so25316300wru.13
        for <linux-xfs@vger.kernel.org>; Tue, 16 Oct 2018 05:57:15 -0700 (PDT)
Date: Tue, 16 Oct 2018 14:57:12 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [QUESTION] multiple fsync() vs single sync()
Message-ID: <20181016125712.5k5xt4lzhi76qaj6@odin.usersys.redhat.com>
References: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Romain Le Disez <romain.le-disez@corp.ovh.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>


Hi,

> 
> In this pseudo-code (extracted from OpenStack Swift [1]):
>     fd=open("/tmp/tempfile", O_CREAT | O_WRONLY);
>     write(fd, ...);
>     fsetxattr(fd, ...);
>     fsync(fd);
>     rename("/tmp/tempfile", "/data/foobar");
>     dirfd = open("/data", O_DIRECTORY | O_RDONLY);
>     fsync(dirfd);
> 
> OR (the same without temporary file):
>     fd=open("/data", O_TMPFILE | O_WRONLY);
>     write(fd, ...);
>     fsetxattr(fd, ...);
>     fsync(fd);
>     linkat(AT_FDCWD, "/proc/self/fd/" + fd, AT_FDCWD, "/data/foobar", AT_SYMLINK_FOLLOW);
>     dirfd = open("/data", O_DIRECTORY | O_RDONLY);
>     fsync(dirfd);
> 
> 
> I’m guaranteed that, what ever happen, I’ll have a complete file (data+xattr) or no file at all in the directory /data.
> 
> First question: is that a correct assumption or is there any loopholes?

Unless you have broken storage, and you are not using volatile write-cache, an
fsync of both file and directory is enough.

> 
> Second question, if I replace the two fsync() by one sync(), do I get the same guarantee?
>     fd=open("/data", O_TMPFILE | O_WRONLY);
>     write(fd, ...);
>     fsetxattr(fd, ...);
>     linkat(AT_FDCWD, « /proc/self/fd/" + fd, AT_FDCWD, "/data/foobar", AT_SYMLINK_FOLLOW);
>     sync();

IIRC, sync() on Linux is supposed to have the same guarantees of syncfs(), once
we wait for IO completion on sync (POSIX doesn't guarantee sync() will return
until everything is written to backing storage, but Linux does wait for IO
completion).

Short answer is, sync() does work the same way as if you run fsync() on every
file on your filesystem. The question would be. Do you want to fsync() all files
in your filesystem? This may take way longer than a pair of fsync() on the file
and its directory. But it's your call, as I said sync() will behave as if you
have ran a fsyn() on every file/directory on your filesystem.

Cheers

> 
> From what I understand of the FAQ [1], write_barrier guarantee that journal (aka log) will be written before the inode (aka metadata). Did I miss something?
> 
> Many thanks for your help.
> 
> [1] https://github.com/openstack/swift/blob/2.19.0/swift/obj/diskfile.py#L1674-L1694
> [2] http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_problem_with_the_write_cache_on_journaled_filesystems.3F
> 
> -- 
> Romain
> 

-- 
Carlos
