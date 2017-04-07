Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753290AbdDGRjt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Apr 2017 13:39:49 -0400
Date: Fri, 7 Apr 2017 13:39:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Processes stuck in D state when accessing XFSv5 filesystem
Message-ID: <20170407173946.GD55851@bfoster.bfoster>
References: <C1597D74-938F-4236-91F0-4CA1D6907F50@jabberwocky.com>
 <20170407165616.2269260a@harpe.intellique.com>
 <CC0DA53B-D439-476E-AEEE-44951FE8B69C@jabberwocky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CC0DA53B-D439-476E-AEEE-44951FE8B69C@jabberwocky.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Shaw <dshaw@jabberwocky.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-xfs@vger.kernel.org

On Fri, Apr 07, 2017 at 12:56:48PM -0400, David Shaw wrote:
> On Apr 7, 2017, at 10:56 AM, Emmanuel Florac <eflorac@intellique.com> wrote:
> > 
> > Le Thu, 6 Apr 2017 14:41:45 -0400
> > David Shaw <dshaw@jabberwocky.com> écrivait:
> > 
> >> I'm having a problem with processes getting "stuck" when accessing an
> >> XFS (v5) filesystem.  When it happens, I start getting the "blocked
> >> for more than 120 seconds" error, and the process stays in that state
> >> until I reboot.  The kernel is 3.10.0-514.2.2 and the xfsprogs is
> >> 4.5.0-9 (both Centos 7.3).
> >> 
> > 
> > Could it be that your system is under high IO load?
> 
> It's possible that the problem is instigated or made worse by high load, but once the processes enter D state, they stay there even when the system is idle.  They stay in D state until I reboot.
> 

There isn't enough information provided to suggest the filesystem is
locked up as opposed to waiting for (very slow) I/O, as suggested by
Emmanuel.

If the filesystem appears to be deadlocked, can you provide the complete
hung task output (echo w > /proc/sysrq-trigger) as well any activity
that might be shown by tracepoints if enabled when in this state
(trace-cmd start -e xfs:*; cat /sys/kernel/debug/tracing/trace_pipe)?

Brian

> David
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
