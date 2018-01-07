Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:46673 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbeAGDmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jan 2018 22:42:52 -0500
Subject: Re: Google Chrome cause locks held in system (kernel 4.15 rc2)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1515248235.17396.4.camel@gmail.com>
        <201801062352.EFF56799.HFFLOMOJOFSQtV@I-love.SAKURA.ne.jp>
        <1515252530.17396.16.camel@gmail.com>
        <201801070048.JAE30243.MLQOtHVFOOFJFS@I-love.SAKURA.ne.jp>
        <1515259453.17396.17.camel@gmail.com>
In-Reply-To: <1515259453.17396.17.camel@gmail.com>
Message-Id: <201801071242.CCD05710.HFFVQJMtOOFOSL@I-love.SAKURA.ne.jp>
Date: Sun, 7 Jan 2018 12:42:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mikhail.v.gavrilov@gmail.com
Cc: mhocko@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

mikhail wrote:
> Thanks, I investigated the code of new version udplogger. I understood
> why it is not subject to the problems described above. Because it uses
> one file for all clients. The old version tried to create a separate
> file for each client.
> 
> Why you not using git hosting?

Because I don't have my git trees. svn is sufficient.

> Old version is quickly searchable by google.

Using old version is fine.
What you are seeing is a bug which exists in kohsuke's version.

> Look here it's second place in search results:
> https://imgur.com/a/IKHY8
> And new version is impossible to find in searching engine, it's so sad.
> 

In my search result, my version is printed first.
URL of my version is explicitly shown in the LCJ2014-en_0.pdf file.
I can't afford investigating modified/variant versions which are called "udplogger".
I don't have control for preventing modified/variant versions from appearing. ;-)

Anyway, please report when you succeeded to reproduce slowdown problem.
