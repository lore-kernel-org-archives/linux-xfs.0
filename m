Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 08 Mar 2008 22:15:17 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m296EpBu021638
	for <xfs@oss.sgi.com>; Sat, 8 Mar 2008 22:14:53 -0800
Date: Sun, 9 Mar 2008 07:15:09 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 2.6.25-rc hangs (was: INFO: task mount:11202 blocked for more than
 120 seconds)
In-Reply-To: <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, 8 Mar 2008, Christian Kujau wrote:
> FWIW, it's 100% reproducible with 2.6.25-rc3 too...sigh :-\
> So, the last working kernel for me is 2.6.24.1 - that's a lot of bisecting 
> and I fear that compile errors will invalidate the bisecting results again or 
> make it impossible at all....I'll try anyway....tomorrow...

Bisecting failed as expected :-(
I tried to follow the git-bisect manpage (and have successfully used 
bisect in the past a few times), but I think ~5700 revisions between 
2.6.24 and 2.6.25 are just too much fuzz. The bisect logs so far, with
my comments inbetween:

git-bisect start
# 2.6.25-rc4, known to be bad:
# bad: [84c6f6046c5a2189160a8f0dca8b90427bf690ea] x86_64: make ptrace always sign-extend orig_ax to 64 bits
git-bisect bad 84c6f6046c5a2189160a8f0dca8b90427bf690ea
# 2.6.24, good:
# good: [49914084e797530d9baaf51df9eda77babc98fa8] Linux 2.6.24
git-bisect good 49914084e797530d9baaf51df9eda77babc98fa8
# 2.6.24, hard lockup during boot, bad:
# bad: [bd45ac0c5daae35e7c71138172e63df5cf644cf6] Merge branch 'linux-2.6'
git-bisect bad bd45ac0c5daae35e7c71138172e63df5cf644cf6

I marked the last one bad, because I could not boot any more. As it's a 
headless box, I could not get more details. It did not even respond so
sysrq-b. After marking this bad, I compiled and booted again - same 
result, hard lockup. So I tried again:

git bisect reset
git-bisect start
# 2.6.25-rc4, known to be bad:
# bad: [84c6f6046c5a2189160a8f0dca8b90427bf690ea] x86_64: make ptrace always sign-extend orig_ax to 64 bits
git-bisect bad 84c6f6046c5a2189160a8f0dca8b90427bf690ea
# 2.6.24, good:
# good: [49914084e797530d9baaf51df9eda77babc98fa8] Linux 2.6.24
git-bisect good 49914084e797530d9baaf51df9eda77babc98fa8
# 2.6.24, hard lockup during boot, marking good anyway:
# good: [bd45ac0c5daae35e7c71138172e63df5cf644cf6] Merge branch 'linux-2.6'
git-bisect good bd45ac0c5daae35e7c71138172e63df5cf644cf6
# lockup
# bad: [f0f1b3364ae7f48084bdf2837fb979ff59622523] Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
git-bisect bad f0f1b3364ae7f48084bdf2837fb979ff59622523

Although I could not boot with bd45ac0c5daae35e7c71138172e63df5cf644cf6, I 
marked it "good", as the lockup is totally unrelated to my problem. 
However, the box locks up as soon as I'm using the device-mapper. This 
time it does respond to sysrq-b.

But still: I'm unable to diagnose the system hang [0] and I fear that
2.6.25 is released and for the first time since ages I'd have to skip a release...

Help!

Christian.

[0] http://lkml.org/lkml/2008/3/7/308
-- 
BOFH excuse #288:

Hard drive sleeping. Let it wake up on it's own...
