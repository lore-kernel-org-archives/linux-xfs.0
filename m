Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 04:25:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QBPPK9006738
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:25:25 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B71711D63DD
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:26:26 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id hIt4jkGloz52dyfe for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:26:26 -0700 (PDT)
Date: Thu, 26 Jun 2008 05:26:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush requirements
Message-ID: <20080626112612.GW4392@parisc-linux.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214455277-6387-2-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> XFS object flushing doesn't quite match existing completion semantics.  It
> mixed exclusive access with completion. That is, we need to mark an object as
> being flushed before flushing it to disk, and then block any other attempt to
> flush it until the completion occurs.

This sounds like mutex semantics.  Why are the existing mutexes not
appropriate for your needs?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
