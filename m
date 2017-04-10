Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751396AbdDJPXw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 11:23:52 -0400
Date: Mon, 10 Apr 2017 11:23:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Processes stuck in D state when accessing XFSv5 filesystem
Message-ID: <20170410152348.GD3991@bfoster.bfoster>
References: <C1597D74-938F-4236-91F0-4CA1D6907F50@jabberwocky.com>
 <20170407165616.2269260a@harpe.intellique.com>
 <CC0DA53B-D439-476E-AEEE-44951FE8B69C@jabberwocky.com>
 <20170407173946.GD55851@bfoster.bfoster>
 <2F0091FC-EF20-4A63-B89E-C97094091953@jabberwocky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2F0091FC-EF20-4A63-B89E-C97094091953@jabberwocky.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Shaw <dshaw@jabberwocky.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-xfs@vger.kernel.org

On Sat, Apr 08, 2017 at 07:26:14AM -0400, David Shaw wrote:
> On Apr 7, 2017, at 1:39 PM, Brian Foster <bfoster@redhat.com> wrote:
> > 
> > On Fri, Apr 07, 2017 at 12:56:48PM -0400, David Shaw wrote:
> >> On Apr 7, 2017, at 10:56 AM, Emmanuel Florac <eflorac@intellique.com> wrote:
> >>> 
> >>> Le Thu, 6 Apr 2017 14:41:45 -0400
> >>> David Shaw <dshaw@jabberwocky.com> écrivait:
> >>> 
> >>>> I'm having a problem with processes getting "stuck" when accessing an
> >>>> XFS (v5) filesystem.  When it happens, I start getting the "blocked
> >>>> for more than 120 seconds" error, and the process stays in that state
> >>>> until I reboot.  The kernel is 3.10.0-514.2.2 and the xfsprogs is
> >>>> 4.5.0-9 (both Centos 7.3).
> >>>> 
> >>> 
> >>> Could it be that your system is under high IO load?
> >> 
> >> It's possible that the problem is instigated or made worse by high load, but once the processes enter D state, they stay there even when the system is idle.  They stay in D state until I reboot.
> >> 
> > 
> > There isn't enough information provided to suggest the filesystem is
> > locked up as opposed to waiting for (very slow) I/O, as suggested by
> > Emmanuel.
> 
> Ah, I didn't understand, thanks.
> 
> > If the filesystem appears to be deadlocked, can you provide the complete
> > hung task output (echo w > /proc/sysrq-trigger) as well any activity
> > that might be shown by tracepoints if enabled when in this state
> > (trace-cmd start -e xfs:*; cat /sys/kernel/debug/tracing/trace_pipe)?
> 
> I have the hung task output from a recent time this happened (http://www.jabberwocky.com/xfs/blocked.txt).  In it, "servxfs" is the process that reads from the XFS filesystem.  It's the process feeding a fuse filesystem.  "mmon" and "smbd" are both trying to access the fuse filesystem.  I suspect that they're blocking because the servxfs threads are blocking and thus not fulfilling the fuse requests.
> 

Interesting, nothing obvious stands out to me. It looks you have smbd
waiting on a pread over fuse and mmon waiting on a stat. Presumably the
smbd pread corresponds to the blocked servxfs pread and the stat to one
of the servxfs getxattr calls.

Any idea where the other servxfs getxattr comes in?

> I will get the xfs traces the next time it happens.  It seems to be happening 2-3 times a week, but frustratingly, I can't make it happen on demand.  Is there something I should look for in particular in the trace output, or some amount of time to capture it for?
> 

Can you elaborate on the resulting behavior? Are these same processes
always involved? Can you identify whether they are attempting to access
the same file(s) or not? Also, does the underlying filesystem continue
to function outside of these processes seemingly all blocked on reads?
E.g., can you read another file from the XFS fs or is all I/O blocked?

Because there are multiple layers involved here, presumably with custom
code in between (e.g., your fuse userspace), this might be easier to
reason about if you can dig more into what's blocked in the upper layers
to describe precisely what high level requests are active at the XFS
level.

Brian

> Thanks again for your help,
> 
> David
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
