Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8HKI1tx089427 for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 15:18:02 -0500
Received: from hermes1.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74C9180FE8
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 13:18:48 -0700 (PDT)
Received: from hermes1.dur.ac.uk (hermes1.dur.ac.uk [129.234.248.1]) by
	cuda.sgi.com with ESMTP id LD3E9LsBf89lV0EK for
	<xfs@OSS.SGI.com>; Fri, 17 Sep 2010 13:18:48 -0700 (PDT)
Received: from mail.phyip3.dur.ac.uk (mail.phyip3.dur.ac.uk [129.234.186.130])
	by hermes1.dur.ac.uk (8.13.8/8.13.7) with ESMTP id o8HKIOAT001225
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 21:18:33 +0100
Received: from localhost (localhost [127.0.0.1])
	by mail.phyip3.dur.ac.uk (Postfix) with ESMTP id CB3918000E
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 21:18:24 +0100 (BST)
Received: from mail.phyip3.dur.ac.uk ([127.0.0.1])
	by localhost (mail.phyip3.dur.ac.uk [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id AoGb8Iw-D7it for <xfs@OSS.SGI.com>;
	Fri, 17 Sep 2010 21:18:22 +0100 (BST)
Received: from ty.sabi.co.UK (O1.PhyIP3.Dur.ac.UK [129.234.186.1])
	by mail.phyip3.dur.ac.uk (Postfix) with ESMTP id 83AC08000A
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 21:18:22 +0100 (BST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1Owh48-00035J-Ei
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 20:57:48 +0100
MIME-Version: 1.0
Message-ID: <19603.51260.32944.928119@tree.ty.sabi.co.uk>
Date: Fri, 17 Sep 2010 20:57:48 +0100
Subject: Re: LWN.net article: creating 1 billion files -> Tests we did
In-Reply-To: <20100916121350.3ab30ca5@harpe.intellique.com>
References: <201008191312.49346@zmi.at>
	<20100916121350.3ab30ca5@harpe.intellique.com>
From: pg@xfs2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <xfs@oss.sgi.com>


>> The subject is a bit harsh, but overall the article says: XFS
>> is slowest on creating and deleting a billion files XFS fsck
>> needs 30GB RAM to fsck that 100TB filesystem.

Hahahaha. Very funny. So what?

>> http://lwn.net/SubscriberLink/400629/3fb4bc34d6223b32/

LWN is usually fairly decent, but I have noticed it does
occasionally waste pixels on/bits things that the author(s)
misrepresent as storage or file system tests.

However in this case the main takeaway of the presentation
reported is that it is just a bad idea to assume that file systems
can scale to large collections of small files as DBMSes designed
for that purpose. So what?

> So We've made a test with 1KB files (space, space...) and a
> production kernel : 2.6.32.11 (yeah I know, 2.6.38 should be
> faster but you know, we upgrade our production kernels prudently :).

Why is this a test of anything other than how to waste time?

> mk1BFiles will create and delete 1000000000 files with 32
> threads Version: v0.2.4-10-gf6decd3, build: Sep 7 2010
> 13:39:34

> Creating 1000000000 files, started at 2010-09-07 13:45:16...
> Done, time spent: 89:35:12.262

Was there any intervening cache flush?

> Doing `ls -R`, started at 2010-09-11 07:20:28...
> Stat: ls (pid: 18844) status: ok, returned value: 0
> Cpu usage: user: 1:27:47.242, system: 20:18:21.689
> Max rss: 229.01 MBytes, page fault: major: 4, minor: 58694

Was there any intervening cache flush?

> Compute size used by 1000000000 files, started at 2010-09-12 09:30:52...
> Size used by files: 11.1759 TBytes
> Size used by directory: 32.897 GBytes
> Size used (total): 11.2080 TBytes
> Done, time spent: 25:50:32.355

Was there any intervening cache flush?

> Deleting 1000000000 files, started at 2010-09-13 11:21:24...
> Done, time spent: 68:37:38.117

Was there any intervening cache flush?

Why would anybody with even a little knowledge of computers and
systems want to use a filesystem as database for small records?

> Test run on a dual Opteron quad core, 16 GB RAM, kernel 2.6.32.11
> x86_64...

So what?

Some of the most amusing quotes from the LWN article are from the
comments.

 "Recently I did similiar tests for determining how well PostgreSQL
  would be able to deal with databases with potentially hundreds of
  thousands of tables. From what I found out, it's only limited by
  the file system's ability to work with that many files in a
  single directory."

HHAHAHAHAHAHAHA.

 "> But in what situations will it make more sense to not group a
  > billion of file items into logical groups?
 
  Things like squid cache directories, git object directories,
  ccache cache directories, that hidden thumbnails directory in
  your $HOME... They all have in common that the files are named
  by a hash or something similar. There is no logical grouping at
  all here; it is a completely flat namespace."

AAAAAAGGGGGHHHHHHHHHHH.

But the original presentation has absolutely the funniest bit:

 "Why Not Use a Database?
  ● Users and system administrators are familiar
    with file systems
      Backup, creation, etc are all well understood
  ● File systems handle partial failures pretty well
      Being able to recover part of the stored data is
      useful for some applications
  ● File systems are “cheap” since they come with
    your operating system!"

My evil translation of that is "because so many sysadms and
programmers are incompetent and stupid and wish for ponies".

Of course the best bit is where someone :-) was quoted making
sense:

  “Millions of files may work; but 1 billion is an utter
  absurdity. A filesystem that can store reasonably 1 billion
  small files in 7TB is an unsolved research issue...,”

The stupidest bit of the presentation was part of the quoted
reply:

  “Strangely enough, I have been testing ext4 and stopped filling
  it at a bit over 1 billion 20KB files on Monday (with 60TB of
  storage). Running fsck on it took only 2.4 hours.”

Where the idea that the 'fsck' time that matters is that of a
freshly created (and was the page cache flushed?), uncorrupted
filesystem is intensely comical. "Possible" does not mean
"reasonably". Just delirious.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
