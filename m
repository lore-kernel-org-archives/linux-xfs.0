Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:41341 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752346AbdLJVtj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 16:49:39 -0500
Received: by mail-lf0-f66.google.com with SMTP id f18so17086813lfg.8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Dec 2017 13:49:39 -0800 (PST)
Message-ID: <1512942574.23718.7.camel@gmail.com>
Subject: Re: Google Chrome cause locks held in system (kernel 4.15 rc2)
From: mikhail <mikhail.v.gavrilov@gmail.com>
Date: Mon, 11 Dec 2017 02:49:34 +0500
In-Reply-To: <201712092314.IGI39555.MtFFVLJFOQOSOH@I-love.SAKURA.ne.jp>
References: <1512705038.7843.6.camel@gmail.com>
         <20171208040556.GG19219@magnolia>
         <b60ae517-b9ca-a07f-36cf-ed11eb3c9180@I-love.SAKURA.ne.jp>
         <1512825438.4168.14.camel@gmail.com>
         <201712092314.IGI39555.MtFFVLJFOQOSOH@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, mhocko@kernel.org
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org

On Sat, 2017-12-09 at 23:14 +0900, Tetsuo Handa wrote:
> Under OOM lockup situation, kernel messages can unlikely be saved to
> syslog
> files, for writing to files involves memory allocation. Can you set
> up
> netconsole or serial console explained at
> http://events.linuxfoundation.org/sites/events/files/slides/LCJ2014-e
> n_0.pdf ?
> If neither console is possible, it would become difficult to debug.

netconsole works only within local network? destination ip may be from
another network?

[11415.184163] netpoll: netconsole: local port 6665
[11415.184168] netpoll: netconsole: local IPv4 address 0.0.0.0
[11415.184169] netpoll: netconsole: interface 'enp2s0'
[11415.184171] netpoll: netconsole: remote port 6666
[11415.184173] netpoll: netconsole: remote IPv4 address 213.136.82.171
[11415.184174] netpoll: netconsole: remote ethernet address
ff:ff:ff:ff:ff:ff
[11415.184179] netpoll: netconsole: local IP 192.168.1.85
[11415.184738] console [netcon0] enabled
[11415.184741] netconsole: network logging started


But on remote host nothing happens when I do SysRq-t

Of course I compiled and launched ./udplogger on remote host under
tmux. And add udp port 6666 to firewalld rule.
# firewall-cmd --permanent --add-port=6666/udp && systemctl restart
firewalld
