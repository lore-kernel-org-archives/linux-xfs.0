Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o946dDhj049581 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 01:39:14 -0500
Received: from smtp03-01.atm.binero.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D05618A41AB
	for <xfs@oss.sgi.com>; Sun,  3 Oct 2010 23:40:15 -0700 (PDT)
Received: from smtp03-01.atm.binero.net (lb-smtp01.atm.binero.net
	[195.74.38.28]) by cuda.sgi.com with ESMTP id tjKp9MqVKulLCuKT
	for <xfs@oss.sgi.com>; Sun, 03 Oct 2010 23:40:15 -0700 (PDT)
Received: from [192.168.1.128] (81-235-239-15-no92.business.telia.com
	[81.235.239.15])
	by smtp03-01.atm.binero.net (Postfix) with ESMTPSA id BB779116324
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 08:40:13 +0200 (CEST)
Mime-Version: 1.0 (Apple Message framework v1081)
Subject: Re: No space left on device
From: Turbo Fredriksson <turbo@bayour.com>
In-Reply-To: <D3DB5B56-D15C-408C-B2B4-58626C23D798@bayour.com>
Date: Mon, 4 Oct 2010 08:40:13 +0200
Message-Id: <43FCE115-0B25-42C1-BEE7-D9448AD6D4C3@bayour.com>
References: <A7468B16-5A58-4012-B38B-784D89566D86@bayour.com>
	<20100924152324.GA5551@sgi.com>
	<2D51C7BA-FE51-48AF-9839-1A6AD2171510@bayour.com>
	<20100927160643.GA10594@sgi.com>
	<D3DB5B56-D15C-408C-B2B4-58626C23D798@bayour.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

[please keep all communication on/to the list for posterity]

On 27 sep 2010, at 18.26, Turbo Fredriksson wrote:

> On 27 sep 2010, at 18.06, Geoffrey Wehrman wrote:
> 
>> | > or to a much more recent kernel, and the problem will go
>> | > away.
>> | 
>> | How recent?
>> 
>> Based on the following FAQ, 2.6.35 or later.
>> http://xfs.org/index.php/XFS_FAQ#Q:_Can_I_just_try_the_inode64_option_to_see_if_it_helps_me.3F
> 
> That only stated that you can/could switch back
> and forth between 32/64bit. Not that it was/is
> solved - or solve my problem.
> 
> But thanx. I'll try a later kernel then.
> 
> 
> Ok, so 2.6.35.6 is the very latest!! I'm running
> 2.6.32, which is ancient... I had expected a much
> higher minor version... Thanx!

Ok, I'm now at 2.6.35.6, AMD64 compiled, which let me
create more files - using the inode64 mount option
and/or (did both at the same time :) moving what I
think was the first 5Gb data.

Unfortunately, I'm still using a 32bit user land
(can't upgrade at the moment).


celia:~# uname -a
Linux celia 2.6.35.6 #1 SMP Sat Oct 2 09:12:38 UTC 2010 x86_64 GNU/Linux
celia:~# file `which xfs_db`
/usr/sbin/xfs_db: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.8, stripped
celia:~# xfs_info /share
meta-data=/dev/mapper/movies-movies isize=256    agcount=340, agsize=6104768 blks
        =                       sectsz=512   attr=1
data    =                       bsize=4096   blocks=2075610112, imaxpct=10
        =                       sunit=0      swidth=0 blks
naming  =version 2              bsize=4096   ascii-ci=0
log     =internal               bsize=4096   blocks=32768, version=1
        =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime=none                   extsz=65536  blocks=0, rtextents=0


The big question is now, what do I do if/when (soon)
I have to grow the FS?!

On 24 sep 2010, at 17.23, Geoffrey Wehrman wrote:

> On Fri, Sep 24, 2010 at 04:07:23PM +0200, Turbo Fredriksson wrote:
> | The worst thing is that every time I grow
> | the FS, I have to reboot into a 32bit kernel:
> | 
> | xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
> 
> This may be becuase your are running 32bit userland.

On 24 sep 2010, at 23.17, Geoffrey Wehrman wrote:

> On Fri, Sep 24, 2010 at 10:46:47PM +0200, Turbo Fredriksson wrote:
> | On 24 sep 2010, at 17.23, Geoffrey Wehrman wrote:
> | > Once you have 64bit inodes, it is difficult to go back to 32bit inodes.
> | 
> | Figured that.. But will the growfs stop working?
> 
> The 64 bit growfs should work.
> 
> | I assume it won't help just recompiling the XFS
> | binaries since my libs et all is/will be 32bit?.
> 
> Correct.  You must have a 64 bit application/libraries/kernel.

Will my current kernel, but compiled as 32bit, work
without upgrading to a 64bit user land? Or is 2.6.35.6
also fixing the XFS_IOC_FSGROWFSDATA problem I've been
getting on 2.6.32/64bit?

But I guess I can't use that older kernel any more,
since I'm now using 64bit inodes.

The FAQ mentioned above, do say that I'm supposed to
go back and forth, but ... I'm a coward! (Actually,
I used to call myself 'careful', but I guess it's
really the same thing - also, I don't care any more :).


It doesn't seem reasonable that I could create a bigger
(i.e. 64bit) inode table - and files in that table,
switch back to a kernel that only understands 32bit
inode tables (correctly and/or 'is buggy'), grow the
FS, and then go back to using 64bit inodes and still
have all those files created in the 64bit inode table...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
