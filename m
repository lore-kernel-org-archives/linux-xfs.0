Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 13:44:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NLiOqw013908
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 13:44:26 -0800
Message-ID: <45B68181.2010707@sandeen.net>
Date: Tue, 23 Jan 2007 15:43:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: how to sync / commit data to disk?
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>	 <45B632F6.50705@sandeen.net> <d55656c10701231233kf7faf02xbdd59ec1e218afa4@mail.gmail.com>
In-Reply-To: <d55656c10701231233kf7faf02xbdd59ec1e218afa4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Gervai <grinapo@gmail.com>
Cc: xfs@oss.sgi.com

Peter Gervai wrote:
> Thanks for the very informative replies!
> 
> I try to address some questions, and maybe ask some more.
> 
> The original question was:
>> > What is the recommended way to make sure that a file is written
>> > physically to the disk? (apart from the cache of the disk.)
> 
> On 1/23/07, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> Another issue that I've seen with grub is that it seems to like to write
>> directly to the block device WHILE THE FILESYSTEM IS MOUNTED.
> 
> It does not seem to do evil in this case:
> 
> 3243  open("//boot/grub/stage2", O_RDWR) = 5
> 3243  fstat64(0x5, 0xf7c2e9f4)          = 0
> 3243  mmap2(NULL, 4096, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfffffffff7bc4000
> 3243  _llseek(5, 0, [0], SEEK_SET)      = 0
> 3243  read(5, 
> "RV\276\3\201\350(\1^\277\370\201f\213-\203}\4\0\17\204\312\0\200|\377\0t>f\213\35f1\300\260\1779E\4\177\3\213E\4)E\4f\1\5\307\4\20\0\211D\2f\211\ 
> 
> \\10\307D\6\0pPf1\300\211D\4f\211D\f\264B\315\23\17\202\237\0\273\0p\353Vf\213\5f1\322f\3674\210T\nf1"..., 
> 
> 512) = 512
> 3243  write(5, 
> "\352p\202\0\0\0\3\2\377\377\377\0\0\0\0\0\0\0000.97\0/boot/grub/menu.lst\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0 
> 
> \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\3721\300\216\330\216\320\216\300g"..., 
> 
> 512) = 512
> 3243  close(5)                          = 0
> 
> Now, for me it seems to be a very interesting question that why people
> would CARE whether it's synced or not, since they write it by the
> filesystem layer anyway? I do not know, and investigating the reason
> why 'grub-install' would worry about sync is beyond my available time.
> 
> The original problem was because grub-install froze xfs, then tried to
> do the above, which magically fail on the frozen filesystem, hanging
> the install till the cows come home. I tried to fix this, then started
> wondering how to do it properly, and now that you mentioned and I
> checked the trace I really start wondering about why to care... :-o

The other thing I've seen grub do is to go ahead & write nicely through 
the filesystem, then do a verification step of trying to go read 
directly from the block device while the filesystem is still mounted.

Again, not treating the filesystem well; until you unmount the fs 
there's not a lot to guarantee that all your data is where you expect it 
on disk (especially w/ a journalling fs, where metadata in the journal 
is really enough for safety, even if its not in its final disk location 
- and of course grub doesn't replay the journal....)

When I saw it hanging, I saw it hanging in this verification step, for 
the above reasons.  it wandered into unwritten metadata blocks. 
Skipping that verification  step would probably be a better idea, it's 
causing many more problems than it's likely to catch (unless you can 
unmount or otherwise quiesce the filesystem first...)

-Eric
