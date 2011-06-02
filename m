Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52EiI65203834 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 09:44:18 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4E15497B93
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 07:44:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UbvHc636rMoD8xoJ for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2011 07:44:17 -0700 (PDT)
Date: Thu, 2 Jun 2011 16:44:07 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
In-Reply-To: <BANLkTinBL5GbhUg5NLCqmLEfz0nNFrjf-w@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1106021639230.3931@dhcp-27-109.brq.redhat.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<20110602030802.GR561@dastard>
	<BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
	<20110602064040.GS561@dastard>
	<BANLkTinJcvvv2pfXBt7EZ9TXONb9jRe0uQ@mail.gmail.com>
	<alpine.LFD.2.00.1106021352330.3931@dhcp-27-109.brq.redhat.com>
	<BANLkTinBL5GbhUg5NLCqmLEfz0nNFrjf-w@mail.gmail.com>
MIME-Version: 1.0
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
To: "Amir G." <amir73il@users.sourceforge.net>
Cc: sandeen@redhat.com, Theodore Tso <tytso@mit.edu>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On Thu, 2 Jun 2011, Amir G. wrote:

--snip--
> 
> Ted actually brought this up in our ext4 developers meeting on LSF.
> He said we could register an ext4 module with the ext4dev external symbols
> and it would be useful for testing, since we already have all those tools that
> are aware of ext4dev.

I know, but my point is still valid. why to introduce non-existing FSTYP
into other tools, this is not proper course of action. If the goal is
really resurrect ext4dev we should do this first.

> 
> I  am still using a more low-tech method of cloning ext4 (sed) to build
> a standalone ext4dev module for testing, but it's the same principle.
> 
> >>
> >>
--snip--
> >>
> >> So, yes, it's true. There are other ways to accomplish what I am doing,
> >> but I am going out of my way to try to make the life of developers and testers
> >> easier and you are doing the exact opposite by raising objections to a rather
> >> trivial and harmless patch.
> >
> > What is easier for testers and developers ? I fail to see the reason for
> > including non-existing FSTYP into xfstests while it should be forgotten
> > by now. Just provide sources with whatever fs name you choose (or just
> > patches for ext4 preferably), provide patches to e2fsprogs and patches to
> > xfstests if you want people to test with it. And it should be easy for every
> > tester, or developer to use it, shouldn't it ? Is that a problem ?
> 
> Yes, it is a problem. You are thinking in terms of a developer who builds
> new kernels on a daily basis.
> Back in the time, when I developed next3, I asked some friend and
> people in the community
> if they could test it.
> It turned out that they don't even know how to build a kernel and they
> don't want
> to invest the time in doing that.
> This is when I realized that to get to a wider audience of testers, I
> need to make the testing
> process E A S Y !
> 
> And by E A S Y, I mean:
> 1. Take a Fedora 15 system
> 2. download http://next3.sourceforge.net/files/1.0.13/ext4dev_snapshots-1.0.13-x86_64.tar.gz
> 3. tar xfz ext4dev_snapshots-1.0.13-x86_64.tar.gz && cd ext4dev_snapshots-1.0.13
> 4. make && sudo make install && sudo make test

So you're saying that you can not patch xfstests (and other) sources in the
make time ??

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
