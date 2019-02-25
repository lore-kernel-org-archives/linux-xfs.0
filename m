Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f170.google.com ([209.85.208.170]:38630 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfBYWQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 17:16:54 -0500
Received: by mail-lj1-f170.google.com with SMTP id j19so8914790ljg.5
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 14:16:52 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 25 Feb 2019 15:16:40 -0700
Message-ID: <CAJCQCtRODsGw85CdJRD7EF9U2vx7EwFkaFQCtC1mPwckUkUBNw@mail.gmail.com>
Subject: XFS root filesystem corruption after selinux-policy-targeted update
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

https://bugzilla.redhat.com/show_bug.cgi?id=1679697

I'm not sure what the call trace is saying. User has been requested to
run xfs_repair -n to see if it's really corrupt and maybe get more
information in what manner it's corrupted. I don't think it's
selinux-policy related at all, I tried reproducing it in a ppc64le VM
and couldn't. But there's differences in the qemu commands we used
that I don't know enough about, which I note in the bug.

Thanks,

-- 
Chris Murphy
