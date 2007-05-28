Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 May 2007 08:31:04 -0700 (PDT)
Received: from dh.localdomain (inn.nightwish.hu [217.20.130.190])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4SFUwWt024944
	for <xfs@oss.sgi.com>; Mon, 28 May 2007 08:30:59 -0700
From: Pallai Roland <dap@mail.index.hu>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Date: Mon, 28 May 2007 17:30:52 +0200
References: <200705241318.30711.dap@mail.index.hu> <20070525000547.GH85884050@sgi.com> <200705281453.55618.dap@mail.index.hu>
In-Reply-To: <200705281453.55618.dap@mail.index.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281730.53343.dap@mail.index.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com


On Monday 28 May 2007 14:53:55 Pallai Roland wrote:
> On Friday 25 May 2007 02:05:47 David Chinner wrote:
> > "-o ro,norecovery" will allow you to mount the filesystem and get any
> > uncorrupted data off it.
> >
> > You still may get shutdowns if you trip across corrupted metadata in
> > the filesystem, though.
>
> This filesystem is completely dead.
> [...]

 I tried to make a md patch to stop writes if a raid5 array got 2+ failed 
drives, but I found it's already done, oops. :) handle_stripe5() ignores 
writes in this case quietly, I tried and works.

 So how I lost my file system? My first guess about partially successed writes 
wasn't right: there wasn't real write to the disks after the second disk has 
been kicked, so the scenario is same to a simple power loss from this point 
of view. Am I thinking right?


 There's an another layer I used on this box between md and xfs: loop-aes. I 
used it since years and rock stable, but now it's my first suspect, cause I 
found a bug in it today:
 I assembled my array from n-1 disks, and I failed a second disk for a test 
and I found /dev/loop1 still provides *random* data where /dev/md1 serves 
nothing, it's definitely a loop-aes bug:

/dev/loop1: [0700]:180907 (/dev/md1) encryption=AES128 multi-key-v3
hq:~# dd if=/dev/md1 bs=1k count=128 skip=128 >/dev/null
dd: reading `/dev/md1': Input/output error
0+0 records in
0+0 records out
hq:~# dd if=/dev/loop1 bs=1k count=128 skip=128 | md5sum
128+0 records in
128+0 records out
131072 bytes (131 kB) copied, 0.027775 seconds, 4.7 MB/s
e2548a924a0e835bb45fb50058acba98  - (!!!)
hq:~# dd if=/dev/loop1 bs=1k count=128 skip=128 | md5sum
128+0 records in
128+0 records out
131072 bytes (131 kB) copied, 0.030311 seconds, 4.3 MB/s
c6a23412fb75eb5a7eb1d6a7813eb86b  - (!!!)

 It's not an explanation to my screwed up file system, but for me it's enough 
to drop loop-aes. Eh.


--
 d
