Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D5737F4E
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 14:38:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1CF69AC002
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 12:38:48 -0800 (PST)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com
	[209.85.192.41]) by cuda.sgi.com with ESMTP id AnNU55xU39x3CdCF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Dec 2014 12:38:46 -0800 (PST)
Received: by mail-qg0-f41.google.com with SMTP id e89so853679qgf.14
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 12:38:45 -0800 (PST)
Message-ID: <54972FD0.5010601@gmail.com>
Date: Sun, 21 Dec 2014 15:38:40 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: finobt option for end user
References: <CAHJqNbx8qrs6OosFq1TGz4jqzxh82zvLRzxQ1oWpOp5MP6h3oQ@mail.gmail.com>
In-Reply-To: <CAHJqNbx8qrs6OosFq1TGz4jqzxh82zvLRzxQ1oWpOp5MP6h3oQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alphazo <alphazo@gmail.com>, xfs@oss.sgi.com

On 12/20/14 17:52, Alphazo wrote:
> Hello,
> 
> I'm pretty new to XFS. I'm considering moving away from ext4 to XFS because
> of the new self-describing option, performance and reliability improvements
> that XFS went through over the past year. Now I'm puzzled with the new free
> inode btree option (finobt). I tried to find some documentation about it
> but couldn't find the pros or cons. So from an end-user perspective with a
> couple of TB worth of photos:
> - Does it improve overall reliability?
> - Does it provide faster fsck/repair?
> - Does it improve any read or write operation?
> - Is it safe to use and does it recover as well as with finobt=0?
> - What is the typical case for enabling it and would you recommend using it
> for any new fs creation?
> 
> Thank you in advance for your pointers.
> Alphazo

As a user...

You could try it out and see:

mkfs.xfs -m crc=1,finobt=1 <block_device_to_format>

Here, on old junk hardware, finobt aids greatly in multitasking on 
small-file creation.  It may not have the same effect on your hardware.

finobt has given very, very little trouble since it was accepted into the 
kernel code and xfsprogs.

Recovery and reliability have become roughly equal between old XFS, new 
XFS, and new XFS with finobt.  They just approach the problem in different 
ways.  With old XFS, I rely heavily on xfs_repair and xfsdump to show 
filesystem issues.  With new XFS, the kernel code is more likely to complain 
as the issues are happening.

finobt introduces the slightest bit of overhead that might be noticed at the 
point of resource exhaustion.  Otherwise, its overhead might be hard to spot.

As for safety and reliability, I'm working with kernel 3.18 with the drives' 
write caches shut off and using the latest xfsprogs.  It works great.  The 
new v5-superblock XFS progresses at a fast pace, and it helps greatly to 
keep up with it.  kernel 3.18 seems to be a better kernel, period.  YMMV.

Try a test filesystem first and test to your liking first.  If something 
goes wrong, you should find that out in two weeks of testing the file 
system.

Just curious, though, with that volume of images, is there a possibility of 
making a read-only filesystem?  That would take a lot of the safety and 
recovery issues out of the equation, even if you stick with ext4.  It would 
make your main concern to sha256sum the files so that you can check them 
later for bit-rot.

Good luck!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
