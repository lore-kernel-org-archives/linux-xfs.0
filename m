Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55690 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726225AbfAVVxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 16:53:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7C56B2B75E
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 21:53:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 21:52:59 +0000
Message-ID: <bug-202127-201763-21DKJiDKVs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

--- Comment #32 from Dave Chinner (david@fromorbit.com) ---
On Tue, Jan 22, 2019 at 12:49:31PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202127
> 
> --- Comment #22 from daimh@umich.edu ---
> An update is that Broadcom engineer cannot reproduce the issue with Arch
> Linux
> kernel 4.20.3-arch1-1-ARCH and mkfs.xfs version 4.19.0. The difference is his
> raid-60 is 7T and 2T, while mine is 556T. 

IOWs, they didn't actually test your configuration, and so they
didn't see the problem you are seeing. Which implies they've got a
problem in their firmware where something overflows at a larger size
than 7TB.  If that were my raid card, I'd be tearing strips off the
support engineer's manager by now...

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
