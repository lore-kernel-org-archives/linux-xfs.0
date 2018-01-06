Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:36599 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753261AbeAFOxC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jan 2018 09:53:02 -0500
Subject: Re: Google Chrome cause locks held in system (kernel 4.15 rc2)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201712110014.vBB0ENwU088603@www262.sakura.ne.jp>
        <1512963298.23718.15.camel@gmail.com>
        <201712110348.vBB3mSFZ068689@www262.sakura.ne.jp>
        <1515248235.17396.4.camel@gmail.com>
In-Reply-To: <1515248235.17396.4.camel@gmail.com>
Message-Id: <201801062352.EFF56799.HFFLOMOJOFSQtV@I-love.SAKURA.ne.jp>
Date: Sat, 6 Jan 2018 23:52:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mikhail.v.gavrilov@gmail.com
Cc: mhocko@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

mikhail wrote:
> On Mon, 2017-12-11 at 12:48 +0900, Tetsuo Handa wrote:
> > mikhail wrote:
> > > > > netconsole works only within local network? destination ip may
> > > > > be from
> > > > > another network?
> > > > 
> > > > netconsole can work with another network.
> > > > 
> > > > (step 1) Verify that UDP packets are reachable. You can test with
> > > > 
> > > >          # echo test > /dev/udp/213.136.82.171/6666
> > > > 
> > > >          if you are using bash.
> > > 
> > > After this on remote machine was created folder with name of router
> > > external ip address.
> > > Inside this folder was places one file with name of current day.
> > > This
> > > file has size 0 of bytes and not contain "test" message inside.
> > > That is how it should be?
> > 
> > The message should be written to the log file. If not written, UDP
> > packets
> > are dropped somewhere. You need to solve this problem first.
> 
> I found root cause this problem. Here culprit udplogger, because it not
> flush buffers when terminated by ctrl-c.
> 
> Here my pull request with fix this problem:
> https://github.com/kohsuke/udplogger/pull/1/

Thank you. But excuse me?
Something unexpected must be happening in your environment.

udplogger will flush buffers upon '\n' or timeout (default is 10 seconds) or
too long line (default is 65536 bytes).

> 
> Also i fixed two segfault:
> 
> 1) When send two messages in one second from different hosts or ports.
> For reproduce just run
> "echo test > /dev/udp/127.0.0.1/6666 && echo test >
> /dev/udp/127.0.0.1/6666"
> in console.

I can't observe such problem.
udplogger is ready to concurrently receive from multiple sources.

2018-01-06 23:30:08 127.0.0.1:33637 test
2018-01-06 23:30:08 127.0.0.1:47459 test
2018-01-06 23:32:52 127.0.0.1:36343 test
2018-01-06 23:32:52 127.0.0.1:49087 test
2018-01-06 23:32:53 127.0.0.1:43124 test
2018-01-06 23:32:53 127.0.0.1:40711 test
2018-01-06 23:32:53 127.0.0.1:48455 test
2018-01-06 23:32:53 127.0.0.1:60887 test
2018-01-06 23:32:53 127.0.0.1:49617 test
2018-01-06 23:32:53 127.0.0.1:56967 test
2018-01-06 23:32:54 127.0.0.1:44289 test
2018-01-06 23:32:54 127.0.0.1:52134 test
2018-01-06 23:32:54 127.0.0.1:57924 test
2018-01-06 23:32:54 127.0.0.1:54044 test
2018-01-06 23:32:54 127.0.0.1:42350 test
2018-01-06 23:32:54 127.0.0.1:56750 test
2018-01-06 23:32:54 127.0.0.1:33790 test
2018-01-06 23:32:54 127.0.0.1:55627 test
2018-01-06 23:32:55 127.0.0.1:46477 test
2018-01-06 23:32:55 127.0.0.1:34978 test
2018-01-06 23:32:55 127.0.0.1:41563 test
2018-01-06 23:32:55 127.0.0.1:34146 test

> 
> 2) When exced limit of open files.
> Just run "echo test > /dev/udp/127.0.0.1/6666" more than 1024 times.
> 

I can't observe such problem.
udplogger switches to a new file upon acrossing 00:00:00 of the local time.
Simply repeating 1024 times can't reach max open files limit.

Are you using special environment? What is the shell? What is the compiler/version?
