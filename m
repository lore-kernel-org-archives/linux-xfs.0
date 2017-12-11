Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34172 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbdLKDfD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 22:35:03 -0500
Received: by mail-lf0-f65.google.com with SMTP id x20so17621645lff.1
        for <linux-xfs@vger.kernel.org>; Sun, 10 Dec 2017 19:35:02 -0800 (PST)
Message-ID: <1512963298.23718.15.camel@gmail.com>
Subject: Re: Google Chrome cause locks held in system (kernel 4.15 rc2)
From: mikhail <mikhail.v.gavrilov@gmail.com>
Date: Mon, 11 Dec 2017 08:34:58 +0500
In-Reply-To: <201712110014.vBB0ENwU088603@www262.sakura.ne.jp>
References: <201712092314.IGI39555.MtFFVLJFOQOSOH@I-love.SAKURA.ne.jp>
         <1512942574.23718.7.camel@gmail.com>
         <201712110014.vBB0ENwU088603@www262.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: mhocko@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

On Mon, 2017-12-11 at 09:14 +0900, Tetsuo Handa wrote:
> mikhail wrote:
> 
On Sat, 2017-12-09 at 23:14 +0900, Tetsuo Handa wrote:

Under OOM lockup situation, kernel messages can unlikely be saved to syslog
files, for writing to files involves memory allocation. Can you set up
netconsole or serial console explained at
http://events.linuxfoundation.org/sites/events/files/slides/LCJ2014-en_0.pdf ?
If neither console is possible, it would become difficult to debug.


netconsole works only within local network? destination ip may be from
another network?

> 
> netconsole can work with another network.
> 
> (step 1) Verify that UDP packets are reachable. You can test with
> 
>          # echo test > /dev/udp/213.136.82.171/6666
> 
>          if you are using bash.


After this on remote machine was created folder with name of router
external ip address.
Inside this folder was places one file with name of current day. This
file has size 0 of bytes and not contain "test" message inside.
That is how it should be?

> 
> (step 2) Verify that you specified gateway's MAC address rather than
>          target host's MAC address. "ff:ff:ff:ff:ff:ff" suggests that
>          netconsole is unable to resolve correct MAC address.
> 

I am not was specified MAC address when launch netconsole. The address
"ff:ff:ff:ff:ff:ff" was settled by default.
Anyway does it matter for remote machine placed behind router?
Ok, I also setted right MAC address for remote machine. But nothing is
changed.
