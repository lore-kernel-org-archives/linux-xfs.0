Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:21560 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752048AbdLKDsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 22:48:39 -0500
Message-Id: <201712110348.vBB3mSFZ068689@www262.sakura.ne.jp>
Subject: Re: Google Chrome cause locks held in system (kernel 4.15 rc2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
MIME-Version: 1.0
Date: Mon, 11 Dec 2017 12:48:28 +0900
References: <201712110014.vBB0ENwU088603@www262.sakura.ne.jp> <1512963298.23718.15.camel@gmail.com>
In-Reply-To: <1512963298.23718.15.camel@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mikhail <mikhail.v.gavrilov@gmail.com>
Cc: mhocko@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

mikhail wrote:
> > > netconsole works only within local network? destination ip may be from
> > > another network?
> > 
> > netconsole can work with another network.
> > 
> > (step 1) Verify that UDP packets are reachable. You can test with
> > 
> >          # echo test > /dev/udp/213.136.82.171/6666
> > 
> >          if you are using bash.
> 
> After this on remote machine was created folder with name of router
> external ip address.
> Inside this folder was places one file with name of current day. This
> file has size 0 of bytes and not contain "test" message inside.
> That is how it should be?

The message should be written to the log file. If not written, UDP packets
are dropped somewhere. You need to solve this problem first.

> 
> > 
> > (step 2) Verify that you specified gateway's MAC address rather than
> >          target host's MAC address. "ff:ff:ff:ff:ff:ff" suggests that
> >          netconsole is unable to resolve correct MAC address.
> > 
> 
> I am not was specified MAC address when launch netconsole. The address
> "ff:ff:ff:ff:ff:ff" was settled by default.
> Anyway does it matter for remote machine placed behind router?
> Ok, I also setted right MAC address for remote machine. But nothing is
> changed.

If remote machine is in a different network segment, you need to specify
gateway's MAC address rather than remote machine's MAC address. For more
information about netconsole, please see
https://www.kernel.org/doc/Documentation/networking/netconsole.txt .
