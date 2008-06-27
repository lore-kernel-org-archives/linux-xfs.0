Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 19:23:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R2N8XZ015300
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 19:23:09 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23E5028FB32
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 19:24:08 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id kJZzinrB6GcF9wlg for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 19:24:08 -0700 (PDT)
Date: Thu, 26 Jun 2008 20:24:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush requirements
Message-ID: <20080627022407.GB7703@parisc-linux.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <1214512405.21035.110.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214512405.21035.110.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Daniel Walker <dwalker@mvista.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 01:33:25PM -0700, Daniel Walker wrote:
> I think there is some basis to make the changes that you have here.
> Specifically this email and thread,
> 
> http://lkml.org/lkml/2008/4/15/232

You've completely missed the point.  The current semaphore code is
_more_ efficient than the current completion code.  I'm very comfortable
having two APIs here, one for completion-like semantics and one for
mutex-like semantics.  Confusing them like this makes no sense at all.

> However, I don't like how your implementing this as specifically a
> "flush" mechanism for XFS, and the count is limited to just 1 .. There
> are several other places that do this kind of counting with semaphores,
> and have counts above 1..

Then leave them as semaphores.  Really.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
