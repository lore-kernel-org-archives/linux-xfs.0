Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:47323 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdLKAOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 19:14:38 -0500
Message-Id: <201712110014.vBB0ENwU088603@www262.sakura.ne.jp>
Subject: Re: Google Chrome cause locks held in system (kernel 4.15 rc2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
MIME-Version: 1.0
Date: Mon, 11 Dec 2017 09:14:23 +0900
References: <201712092314.IGI39555.MtFFVLJFOQOSOH@I-love.SAKURA.ne.jp> <1512942574.23718.7.camel@gmail.com>
In-Reply-To: <1512942574.23718.7.camel@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mikhail <mikhail.v.gavrilov@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, mhocko@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

mikhail wrote:
> On Sat, 2017-12-09 at 23:14 +0900, Tetsuo Handa wrote:
> > Under OOM lockup situation, kernel messages can unlikely be saved to syslog
> > files, for writing to files involves memory allocation. Can you set up
> > netconsole or serial console explained at
> > http://events.linuxfoundation.org/sites/events/files/slides/LCJ2014-en_0.pdf ?
> > If neither console is possible, it would become difficult to debug.
> 
> netconsole works only within local network? destination ip may be from
> another network?

netconsole can work with another network.

(step 1) Verify that UDP packets are reachable. You can test with

         # echo test > /dev/udp/213.136.82.171/6666

         if you are using bash.

(step 2) Verify that you specified gateway's MAC address rather than
         target host's MAC address. "ff:ff:ff:ff:ff:ff" suggests that
         netconsole is unable to resolve correct MAC address.
