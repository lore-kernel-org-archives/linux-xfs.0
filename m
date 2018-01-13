Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:38050 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbeAMWbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jan 2018 17:31:49 -0500
Received: by mail-ot0-f175.google.com with SMTP id h2so7908126oti.5
        for <linux-xfs@vger.kernel.org>; Sat, 13 Jan 2018 14:31:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180113081725.GA27564@fritha.org>
References: <20180111224451.GA3413@fritha.org> <20180111231358.GW16421@dastard>
 <20180113081725.GA27564@fritha.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 13 Jan 2018 15:31:48 -0700
Message-ID: <CAJCQCtS=qEmRtcqO+U-Ut_V5jFdyEjehiy+Vafxdt-PMvv-Z9g@mail.gmail.com>
Subject: Re: XFS journal corruption after every reboot/shutdown
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>

On Sat, Jan 13, 2018 at 1:17 AM, Heinz Diehl <htd+ml@fritha.org> wrote:

> I remember a time not too long ago where the root fs was clean after a
> reboot/shutdown (maybe around F25?). So something must have changed
> in the way systemd performs a reboot/shutdown..

I forget when, but plymouth started exempting itself from being force
quit by systemd on shutdown. In my case it was preventing remount ro.
I'm not even certain systemd tries to do umount on rootfs if an
initramfs is being used, I'm pretty sure it only does remount ro. And
in the successful remount ro case, I never see the log replay on XFS
at next boot.

You could try to mask the use of plymouth in systemd (or uninstall
it). If the problem goes away, that's the culprit. If it doesn't you
can probably track down what's holding up the remount ro with
https://freedesktop.org/wiki/Software/systemd/Debugging/#index2h1
And following the "eventually shuts down" section.


-- 
Chris Murphy
