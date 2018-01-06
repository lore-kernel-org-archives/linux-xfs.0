Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:37527 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753666AbeAFRYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jan 2018 12:24:18 -0500
Received: by mail-lf0-f53.google.com with SMTP id f3so8181026lfe.4
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jan 2018 09:24:18 -0800 (PST)
Message-ID: <1515259453.17396.17.camel@gmail.com>
Subject: Re: Google Chrome cause locks held in system (kernel 4.15 rc2)
From: mikhail <mikhail.v.gavrilov@gmail.com>
Date: Sat, 06 Jan 2018 22:24:13 +0500
In-Reply-To: <201801070048.JAE30243.MLQOtHVFOOFJFS@I-love.SAKURA.ne.jp>
References: <1512963298.23718.15.camel@gmail.com>
         <201712110348.vBB3mSFZ068689@www262.sakura.ne.jp>
         <1515248235.17396.4.camel@gmail.com>
         <201801062352.EFF56799.HFFLOMOJOFSQtV@I-love.SAKURA.ne.jp>
         <1515252530.17396.16.camel@gmail.com>
         <201801070048.JAE30243.MLQOtHVFOOFJFS@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mhocko@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

On Sun, 2018-01-07 at 00:48 +0900, Tetsuo Handa wrote:
> mikhail wrote:
> > > > Also i fixed two segfault:
> > > > 
> > > > 1) When send two messages in one second from different hosts or
> > > > ports.
> > > > For reproduce just run
> > > > "echo test > /dev/udp/127.0.0.1/6666 && echo test >
> > > > /dev/udp/127.0.0.1/6666"
> > > > in console.
> > > 
> > > I can't observe such problem.
> > > udplogger is ready to concurrently receive from multiple sources.
> > 
> > 
> > Too strange because this condition
> > https://github.com/kohsuke/udplogger/blob/master/udplogger.c#L82
> > do not allow open two file in one second.
> 
> Oh, you got your copy of modified version of old version.
> 
> Please use original latest version at
> https://osdn.net/projects/akari/scm/svn/tree/head/branches/udplogger/
>  .


Thanks, I investigated the code of new version udplogger. I understood
why it is not subject to the problems described above. Because it uses
one file for all clients. The old version tried to create a separate
file for each client.

Why you not using git hosting?
Old version is quickly searchable by google.
Look here it's second place in search results:
https://imgur.com/a/IKHY8
And new version is impossible to find in searching engine, it's so sad.
