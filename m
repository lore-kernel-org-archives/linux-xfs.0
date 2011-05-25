Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4P88XeT128052 for <xfs@oss.sgi.com>; Wed, 25 May 2011 03:08:33 -0500
Received: from mail-px0-f182.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67C3C1E34819
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 01:08:31 -0700 (PDT)
Received: from mail-px0-f182.google.com (mail-px0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	KFDeAatO9K8bVOGU for <xfs@oss.sgi.com>;
	Wed, 25 May 2011 01:08:31 -0700 (PDT)
Received: by pxi20 with SMTP id 20so5929659pxi.41
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 01:08:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110525002947.GK32466@dastard>
References: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
	<BANLkTin26bRHiaCxc15ZwjX__NR3QHaSFA@mail.gmail.com>
	<BANLkTimOA3W2V+0uPsjpPt=MqrbeGcfs5g@mail.gmail.com>
	<20110525002947.GK32466@dastard>
From: Nuno Subtil <subtil@gmail.com>
Date: Wed, 25 May 2011 01:08:11 -0700
Message-ID: <BANLkTi=Jjb1c0Zs0Fw+iLi7DbpE6fVPB_Q@mail.gmail.com>
Subject: Re: XFS umount issue
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
Cc: Paul Anderson <pha@umich.edu>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 24, 2011 at 17:29, Dave Chinner <david@fromorbit.com> wrote:
...
>> Mine is a Netgear Stora. The interesting bit is that the stock
>> firmware runs kernel 2.6.22.18 and uses XFS as well, but I don't know
>> how stable it was to begin with.
>
> Have you checked to see whether there are extra patches added to
> that kernel by Netgear? It's not uncommon for these embedded systems
> to run a kernel that has been patched to fix problems that you are
> seeing.

I looked through it and didn't see anything that stood out, although I
could have easily missed it (the diff is quite noisy, plus it sounds
like the vmap cache invalidation functions have changed names in the
meantime?).

The one interesting bit that I found was that the Netgear kernel
comments out the test that disables write barriers at mount time,
which I found quite odd, but it sounds unrelated to this issue.

Nuno

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
