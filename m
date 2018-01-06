Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:43589 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbeAFP2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jan 2018 10:28:55 -0500
Received: by mail-lf0-f65.google.com with SMTP id o76so1532788lfi.10
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jan 2018 07:28:55 -0800 (PST)
Message-ID: <1515252530.17396.16.camel@gmail.com>
Subject: Re: Google Chrome cause locks held in system (kernel 4.15 rc2)
From: mikhail <mikhail.v.gavrilov@gmail.com>
Date: Sat, 06 Jan 2018 20:28:50 +0500
In-Reply-To: <201801062352.EFF56799.HFFLOMOJOFSQtV@I-love.SAKURA.ne.jp>
References: <201712110014.vBB0ENwU088603@www262.sakura.ne.jp>
         <1512963298.23718.15.camel@gmail.com>
         <201712110348.vBB3mSFZ068689@www262.sakura.ne.jp>
         <1515248235.17396.4.camel@gmail.com>
         <201801062352.EFF56799.HFFLOMOJOFSQtV@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mhocko@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

On Sat, 2018-01-06 at 23:52 +0900, Tetsuo Handa wrote:
> Thank you. But excuse me?
> Something unexpected must be happening in your environment.
> 
> udplogger will flush buffers upon '\n' or timeout (default is 10
> seconds) or
> too long line (default is 65536 bytes).

Very strange because neither '\n' not 10 seconds helps to flush
buffers.
$ echo -e "test\n" > /dev/udp/127.0.0.1/6666
May be I used obsolete source? Could you check this?

> 
> > 
> > Also i fixed two segfault:
> > 
> > 1) When send two messages in one second from different hosts or
> > ports.
> > For reproduce just run
> > "echo test > /dev/udp/127.0.0.1/6666 && echo test >
> > /dev/udp/127.0.0.1/6666"
> > in console.
> 
> I can't observe such problem.
> udplogger is ready to concurrently receive from multiple sources.


Too strange because this condition
https://github.com/kohsuke/udplogger/blob/master/udplogger.c#L82
do not allow open two file in one second.

> > 
> > 2) When exced limit of open files.
> > Just run "echo test > /dev/udp/127.0.0.1/6666" more than 1024
> > times.

How much your "ulimit -n" ?
My is 1024.
$ ulimit -n
1024

May be your ulimit much greater or you launch udplogger under root?

> 
> Are you using special environment? What is the shell? What is the
> compiler/version?
> 

$ gcc --version
gcc (GCC) 7.2.1 20170915 (Red Hat 7.2.1-2)
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is
NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

