Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 20:52:06 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l563q0Wt022962
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 20:52:03 -0700
Received: by nz-out-0506.google.com with SMTP id 4so13363nzn
        for <xfs@oss.sgi.com>; Tue, 05 Jun 2007 20:52:00 -0700 (PDT)
Message-ID: <d9c0b9d90706052022q6ebd064ao39659a8910e3f424@mail.gmail.com>
Date: Tue, 5 Jun 2007 23:22:56 -0400
From: "=?ISO-8859-1?Q?Germ=E1n_Po=F3-Caama=F1o?=" <german.poo@gmail.com>
Subject: Re: Reporting a bug
In-Reply-To: <20070605232457.GA85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Disposition: inline
References: <d9c0b9d90706041910t15584e05y16e7eba660c96d51@mail.gmail.com>
	 <20070605232457.GA85884050@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

2007/6/5, David Chinner <dgc@sgi.com>:
> On Mon, Jun 04, 2007 at 10:10:06PM -0400, Germán Poó-Caamaño wrote:
> > I having have some problems with a XFS partition in Debian Sarge:
> >
> > After a clean reboot (it supposed to be), my machine started with
> > kernel messages of problems, such us XFS_WANT_CORRUPTED_GOTO and
> > XFS_WANT_CORRUPTED_RETURN.
> >
> > It mainly was located in /var.  But, after cleaning that, I checked
> > other partitions.  I guessed that my root partition (/dev/sda5) was in
> > problems also.  I mounted as readonly partition and  I ran xfs_repair
> > on it.  xfs_repair moved 6 files (all of them ELF binaries) to
> > lost+found.  After reboot the machine, it can't boot anymore.
>
> Sounds like a critical binary for boot got lost...

I thought that in the beginning.  But, the crash and segfaults I
pasted in my second message were produced also when I ran Sysrescue
(LiveCD) and tried to work with that filesystem.

Anyway, I applied objdump -T to each file in lost+found.  A lot of
them were important (libgcc, tls/lpthreads, tls/libm, and such).

It seems there were duplicates, because for each file in lost+found
was a library in /lib or /lib/tls.

Some nasty behavior was something like:
  # mkdir foo
  # cd foo
  # foo: No such file or directory

ls over /etc was able to show me group, passwd and shadow.  But none
of them was available.  I copied group- to group.  ls show me two
'group' files.

> > Trying with Sysrescue 0.3.5 I get the following:
>
> What version of the XFS utilities has that got?
> You might do better booting knoppix and then downloading the
> latest tools and running them....

I used xfsprogs 2.8.18.

Unfortunately I haven't had another disk/partition to apply 'dd' to
the conflictive partition.
I discarded a memory problem, it passed a night session of memtest
without errors.

In another partition (137 GB) with *.a lot of* files (think it's used
for maildir). I got 17000+ files in lost+found).  It passed
xfs_repair.  After mounted it again, and a little load, some files
were deleted, but still listed with ls.  If I try to stat that file I
get 'No such file or directory', but still listed in the directory.

I knew that XFS required a robust hardware, I'm not sure if still is
true that statement.  Anyway, I thought the hardware was robust and
probably made a mistake.

-- 
Germán Poó Caamaño
http://www.gnome.org/~gpoo/
