Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5R4EbmN031091
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 23:14:37 -0500
Received: from mail4.task.com.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74B962FE36
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 21:14:36 -0700 (PDT)
Received: from mail4.task.com.br (mail4.task.com.br [75.126.195.14]) by
	cuda.sgi.com with ESMTP id YE3JGMWLVZYkXmnk for
	<linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 21:14:36 -0700 (PDT)
Message-ID: <4E0803AA.20809@task.com.br>
Date: Mon, 27 Jun 2011 01:14:34 -0300
From: Marcus Pereira <marcus@task.com.br>
MIME-Version: 1.0
Subject: Re: mkfs.xfs error creating large agcount an raid
References: <4E063BC6.9000801@task.com.br>	<4E0694CC.8050003@hardwarefreak.com>	<4E06C967.2060107@task.com.br>	<20110626235959.GC32466@dastard>
	<4E07FA07.4050907@hardwarefreak.com>
In-Reply-To: <4E07FA07.4050907@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Em 27-06-2011 00:33, Stan Hoeppner escreveu:
>
> I recommend 3 changes, one of which I previously mentioned:
>
> 1.  Use 8 mirror pairs instead of 4
> 2.  Don't use striping.  Make an mdraid --linear device of the 8 mirrors
> 3.  Format with '-d agcount=3D32' which will give you 4 AGs per spindle
>
> Test this configuration and post your results.

I am thanks for all advices. I will make the tests and post, may take =

some time.

About all other messages. My system may not be a Ferrari but its not a =

Volks. I certainly do not have that many HDs in fiber channel, but the =

sever is a dual core Xeon 6 cores with HT. Linux sees a total of 24 =

cores, total RAM is 24GB. The HDs are all SAS 15Krpm and the system runs =

on SSD. They are dedicated to handle the maildir files and I have =

several of those servers running nicely.
But I don=92t want to make the thread about my system larger.

Yes, I don=92t know much about XFS and Allocation groups, thanks for you =

all to help me a bit.

At the end the reason why I opened the thread it the error and the =

developers should take some care about that.

Ok, no reason to use that many agcount but giving a "mkfs.xfs: pwrite64 =

failed: No space left on device" error for me stills seems a bug.
I manage to create a XFS volume with agcount=3D30000 on a normal device, =

no error or warning.
On md or lvm arrays I got that error at some point.

Marcus


-- =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
