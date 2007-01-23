Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 12:34:08 -0800 (PST)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.227])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NKXtqw029574
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 12:33:56 -0800
Received: by wx-out-0506.google.com with SMTP id t4so1641375wxc
        for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 12:33:01 -0800 (PST)
Message-ID: <d55656c10701231233kf7faf02xbdd59ec1e218afa4@mail.gmail.com>
Date: Tue, 23 Jan 2007 21:33:01 +0100
From: "Peter Gervai" <grinapo@gmail.com>
Subject: Re: how to sync / commit data to disk?
In-Reply-To: <45B632F6.50705@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
	 <45B632F6.50705@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Thanks for the very informative replies!

I try to address some questions, and maybe ask some more.

The original question was:
> > What is the recommended way to make sure that a file is written
> > physically to the disk? (apart from the cache of the disk.)

On 1/23/07, Eric Sandeen <sandeen@sandeen.net> wrote:

> Another issue that I've seen with grub is that it seems to like to write
> directly to the block device WHILE THE FILESYSTEM IS MOUNTED.

It does not seem to do evil in this case:

3243  open("//boot/grub/stage2", O_RDWR) = 5
3243  fstat64(0x5, 0xf7c2e9f4)          = 0
3243  mmap2(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7bc4000
3243  _llseek(5, 0, [0], SEEK_SET)      = 0
3243  read(5, "RV\276\3\201\350(\1^\277\370\201f\213-\203}\4\0\17\204\312\0\200|\377\0t>f\213\35f1\300\260\1779E\4\177\3\213E\4)E\4f\1\5\307\4\20\0\211D\2f\211\
\\10\307D\6\0pPf1\300\211D\4f\211D\f\264B\315\23\17\202\237\0\273\0p\353Vf\213\5f1\322f\3674\210T\nf1"...,
512) = 512
3243  write(5, "\352p\202\0\0\0\3\2\377\377\377\0\0\0\0\0\0\0000.97\0/boot/grub/menu.lst\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\3721\300\216\330\216\320\216\300g"...,
512) = 512
3243  close(5)                          = 0

Now, for me it seems to be a very interesting question that why people
would CARE whether it's synced or not, since they write it by the
filesystem layer anyway? I do not know, and investigating the reason
why 'grub-install' would worry about sync is beyond my available time.

The original problem was because grub-install froze xfs, then tried to
do the above, which magically fail on the frozen filesystem, hanging
the install till the cows come home. I tried to fix this, then started
wondering how to do it properly, and now that you mentioned and I
checked the trace I really start wondering about why to care... :-o


Then Chris Wedgwood <cw@f00f.org> said:
> GRUB IS BROKEN

Apart from that it is so far he best boot manager I found (still I'm
open to suggestions of better, free boot managers, but please not on
this list), which is completely based on my extremely subjective point
of view (which includes XFS support, naturally), and which may be
completely opposite to the point of view of any human or nonhuman
being, it is not, as you have seen above. It uses a dirty hack which
works, I accept that. Specifying --stage2 seems to avoid that hack
altogether anyway.

> wrt to grub, i thought it did this for xfs anyhow?
I accept the "BROKEN" comment regarding this one. ;-) It is a broken
implementation. Freeze, ten tries to write. Doomed to fail.


Iustin Pop <iusty@k1024.org> commnted about:
> I usually unmount the /boot partition if I need to reinstall grub

Manually it's ok but this is about grub-install, a "vendor" provided
script which cannot assume that you have a separate boot partition.


"Geir A. Myrestrand" <geir.myrestrand@falconstor.com> added:
> Call the sync before you freeze the file system, not after. You can't
> write to the file system when it is frozen, so it makes no sense to call
> sync after a freeze.

I thought that freeze lets already written but unsynced data to be written.


It seems to me that sync before freeze seems to be a good way to make
sure things are on the disk where they gonna stay, as far as it is
possible in such a hacky case.

Thanks, and feel free to comment more, if you like.

-- 
 byte-byte,
    grin
