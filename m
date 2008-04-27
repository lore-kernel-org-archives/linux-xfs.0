Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 16:48:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3RNmdO2006009
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:48:40 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A04B10C45F5
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:49:20 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158]) by cuda.sgi.com with ESMTP id jyPpbVM4rcyVgw1K for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:49:20 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so4052294fga.8
        for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 16:49:19 -0700 (PDT)
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Date: Mon, 28 Apr 2008 01:48:22 +0200
References: <200804270246.58828.vda.linux@googlemail.com> <20080427232317.GB103491721@sgi.com>
In-Reply-To: <20080427232317.GB103491721@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804280148.22358.vda.linux@googlemail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Monday 28 April 2008 01:23, David Chinner wrote:
> > This patch reduces xfs_page_state_convert() stack usage by 16 bytes
> > by eliminating some local variables, and reducing the size
> > of scope for other locals.
> > 
> > Compile tested only.
> 
> Can you start testing your patches? if you are touching the writeback
> or allocator path, there's a pretty high barrier to having patches
> excepted, and testing them before is one of them. Go and download the

Its you who asked for patches. It's not like I decided
to nag you because I have nothing better to do. Actually,
my plate is pretty full with other things already.

> XFSQA suite from the xfs-cmds CVS tree on oss.sgi.com, and run your
> patches through it....


On Tuesday 22 April 2008 03:28, David Chinner wrote:
> Patches are welcome - I'd be over the moon if any of the known 4k
> stack advocates sent a stack reduction patch for XFS, but it seems
> that actually trying to fix the problems is much harder than
> resending a one line patch every few months....

So I went ahead and actually spend a good chunk of the week
trying to help you.

I believe that my patches were sufficiently well thought-out,
carefully implemented and reasonably tested (for a guy who
never used xfs, have no xfs partitions, and not exactly
planning to use xfs in the future).

> pretty high barrier to having patches accepted

I was honestly trying to help you. I am still willing
to do it, but at some point you have to carry some part
of a burden (maybe review and run testing?).

If you are not going to accept patches, why you are
accusing people of not sending them to you?
--
vda
