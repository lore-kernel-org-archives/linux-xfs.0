Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030599AbdDSSIO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 14:08:14 -0400
Date: Wed, 19 Apr 2017 14:08:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
Message-ID: <20170419180811.GB41631@bfoster.bfoster>
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
 <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Weissenbacher <mw@dermichi.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 06:36:00PM +0200, Michael Weissenbacher wrote:
> On 19.04.2017 16:04, Carlos Maiolino wrote:
> > If I am not blind, the task currently owning the cpu isn't listed there, which I
> > suppose to be already running.
> Correct, the only process utilizing the CPU is xfsaild. It is also the
> only process doing I/O, and it looks like it's doing only reads. It
> (xfsaild) never shows up in dmesg as blocked.
> 

A snippet of tracepoint output from the fs might also be interesting
when you hit this state. E.g., 'trace-cmd start -e xfs:*' and save the
output of /sys/kernel/debug/tracing/trace_pipe to a file for a few
seconds or so.

> > Next time you hit it, could you please paste the stack trace of the task owning
> > the cpu? Which I suppose to be xfsaild according to your report.
> > 
> > A simple `cat /proc/<pid>/stack` is probably enough
> Sure, will do.

BTW, is the original /proc/meminfo output you posted from the system in
a normal state or when the problem occurs? If the former, could you
include it while the problem occurs as well?

Brian

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
