Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 07:52:27 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KEptDW009819
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 07:51:57 -0700
Message-ID: <44BF8500.1010708@dgreaves.com>
Date: Thu, 20 Jul 2006 14:28:32 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: FAQ updated (was Re: XFS breakage...)
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost> <20060720171310.B1970528@wobbly.melbourne.sgi.com>
In-Reply-To: <20060720171310.B1970528@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Justin Piszcz <jpiszcz@lucidpixels.com>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cw@f00f.org, ml@magog.se, radsaq@gmail.com

Nathan Scott wrote:
> Correction there - no -stable exists with this yet, I guess that'll
> be 2.6.17.7 once its out though.
> 
>> what action do you suggest i do now?
> 
> I've captured the state of this issue here, with options and ways
> to correct the problem:
> 	http://oss.sgi.com/projects/xfs/faq.html#dir2
> 
> Hope this helps.

It does, thanks :)


Does this problem exist in 2.16.6.x??

>From various comments like:
  Unless 2.6.16.x is a dead-end could we please also have this patch put
  into there?
and
  a result (I believe) of the corruption bug that was in 2.6.16/17.
and
  I just want to confirm this bug as well and unfortunately it was my
  system disk too who had to take the hit. Im running 2.6.16
I assume it does.

But the FAQ says:
Q: What is the issue with directory corruption in Linux 2.6.17?
In the Linux kernel 2.6.17 release a subtle bug...

which implies it's not...

HELP

So given this is from 2.6.16.9:
                        /*
                         * One less used entry in the free table.
                         */
                        INT_MOD(free->hdr.nused, ARCH_CONVERT, -1);
                        xfs_dir2_free_log_header(tp, fbp);

and it looks awfully similar to the patch which says:

--- linux-2.6.17.2.orig/fs/xfs/xfs_dir2_node.c
+++ linux-2.6.17.2/fs/xfs/xfs_dir2_node.c
@@ -970,7 +970,7 @@ xfs_dir2_leafn_remove(
 			/*
 			 * One less used entry in the free table.
 			 */
-			free->hdr.nused = cpu_to_be32(-1);
+			be32_add(&free->hdr.nused, -1);
 			xfs_dir2_free_log_header(tp, fbp);

Should 2.6.16.x replace
  INT_MOD(free->hdr.nused, ARCH_CONVERT, -1);
with
  be32_add(&free->hdr.nused, -1);

I hope so because I assumed there simply wasn't a patch for 2.6.16 and
applied this 'best guess' to my servers and rebooted/remounted successfully.

David


-- 
