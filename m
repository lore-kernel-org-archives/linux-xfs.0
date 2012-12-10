Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA9AJwg205872 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 03:10:19 -0600
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [195.71.86.230]) by
	cuda.sgi.com with ESMTP id ukGrKaeCCu8xrnsl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Dec 2012 01:12:46 -0800 (PST)
Date: Mon, 10 Dec 2012 10:12:39 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: XFS write cache flush policy
Message-ID: <20121210091239.GA21114@citd.de>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de> <20121210005820.GG15784@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121210005820.GG15784@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Lin Li <sdeber@gmail.com>, xfs@oss.sgi.com

On 10.12.2012 11:58, Dave Chinner wrote:
> On Sat, Dec 08, 2012 at 08:29:27PM +0100, Matthias Schniedermeyer wrote:
> > On 06.12.2012 09:51, Lin Li wrote:
> > > Hi, Guys. I recently suffered a huge data loss on power cut on an XFS
> > > partition. The problem was that I copied a lot of files (roughly 20Gb) to
> > > an XFS partition, then 10 hours later, I got an unexpected power cut. As a
> > > result, all these newly copied files disappeared as if they had never been
> > > copied. I tried to check and repair the partition, but xfs_check reports no
> > > error at all. So I guess the problem is that the meta data for these files
> > > were all kept in the cache (64Mb) and were never committed to the hard
> > > disk.
> > > 
> > > What is the cache flush policy for XFS? Does it always reserve some fixed
> > > space in cache for metadata? I asked because I thought since I copied such
> > > a huge amount of data, at least some of these files must be fully committed
> > > to the hard disk, then cache is only 64Mb anyway. But the reality is all of
> > > them were lost. the only possibility I can think is some part of the cache
> > > was reserved for meta data, so even the cache is fully filled, this part
> > > will not be written to the disk. Am I right?
> > 
> > I have the same problem, several times.
> > 
> > The latest just an hour ago.
> > I'm copying a HDD onto another. Plain rsync -a /src/ /tgt/ Both HDDs are 
> > 3TB SATA-drives in a USB3-enclosure with a dm-crypt layer in between.
> > About 45 minutes into copying the target HDD disconnects for a moment.
> > 45minutes means someting over 200GB were copied, each file is about 
> > 900MB.
> > After remounting the filesystems there were exactly 0 files.
> 
> This sounds like an entirely different problem to what the OP
> reported.

For me it sounds only like different timing.
Otherwise i don't see much difference in files vanished after a few 
hours(of inactiviry) and a few minutes (while still beeing active).

> Did the filesystem have an error returned?

No.

> i.e. did it shut down (what's in dmesg)?

There's not much XFS could have done after the block-device vanished.
A dis-/r-eappierung block-device gets a new name because the old name is 
still "in use", the block-devic gets cleaned up after 'umount'ing and 
closing the dm-crypt device.

When the USB3-HDD disconnected it reappered a moment later under a new 
name, it bounced between sdc <-> sdf.

In syslog it's a plain "USB disconnect, device number XX" message.
Followed by a standard new device found message-bombardment. In between 
there are some error-messages, but as it's pratically a yanked out and 
replugged cable, a little complaing by the kernel is to be expected.

> Did you run repair in between the shutdown and remount?

No.

XFS (dm-3): Mounting Filesystem
XFS (dm-3): Starting recovery (logdev: internal)
XFS (dm-3): Ending recovery (logdev: internal)

> How many files in that 200GB of data?

At 0.9GB/file at least 220.

> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> Basically, you have an IO error situation, and you have dm-crypt
> in-between buffering an unknown about of changes. In my experience,
> data loss eventsi are rarely filesystem problems when USB drives or
> dm-crypt is involved...

I don't know the inner workings auf dm-*, but shouldn't it behave 
transparent and rely on the block-layer for buffering.

> > After that i started a "while true; do sync ; done"-loop in the 
> > background.
> > And just while i was writing this email the HDD disconnected a second 
> > time. But this time the files up until the last 'sync' were retained.
> 
> Exactly as I'd expect.
> 
> > And something like this has happend to me at least a half dozen times in 
> > the last few month. I think the first time was with kernel 3.5.X, when i 
> > was actually booting into 3.6 with a plain "reboot" (filesystem might 
> > not have been umounted cleanly.), after the reboot the changes of about 
> > the last half hour were gone. e.g. i had renamed a directory about 15 
> > minutes before i rebooted and after the reboot the directory had it's 
> > old name back.
> > 
> > Kernel in all but (maybe)one case is between 3.6 and 3.6.2 (currently), 
> > the first time MIGHT have been something around 3.5.8 but i'm not sure. 
> > HDDs were either connected by plain SATA(AHCI) or by USB3 enclosure. All 
> > affected filesystems were/are with a dm-crypt layer inbetween.
> 
> Given that dm-crypt is the common factor here, I'd start by ruling
> that out. i.e. reproduce the problem without dm-crypt being used.

That's a slight problem for me, pratically everything i have is 
encrypted.

Now that i think about it, maybe dm-crypt really is to blame, up until a 
few month ago i was using loop-AES. After dm-crypt got the capability to 
emulate it i have moved over to dm-crypt because the loop-AES support in 
Debian got worse over time. I didn't have any problems until after i 
moved to dm-crypt, but OTOH i'm not the only one using dm-crypt. But 
OTOOH maybe not so many people use the loop-AES compatibility-mode.



-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
