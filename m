Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60488 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751946AbeDLUmm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Apr 2018 16:42:42 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: New rash of fuzzer bugs on kernel.org bugzilla
Message-ID: <0bdeb0e5-fd1d-a4d8-1a1a-f9371b829026@sandeen.net>
Date: Thu, 12 Apr 2018 15:42:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: wen.xu@gatech.edu

behold:

https://bugzilla.kernel.org/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&component=XFS&email1=wen.xu%40gatech.edu&emailreporter1=1&emailtype1=substring&known_name=XFS%20bugs&list_id=983189&product=File%20System&query_based_on=XFS%20bugs&query_format=advanced

the return of the fuzzer.

If you were looking for something to do on xfs and wanted a self-contained reproducible bug with a testcase, well, there you go!

(I'm not sure who gets email from kernel.org bugzilla; I'd encourage anyone who works on xfs to keep an eye on the kernel.org bugzilla one way or another - but anyway, figured I'd highlight these.)

Wen, I think we need to find ways for you to help us help you, as well.
Turning a crank on a fuzzer and sending the bugs off to us for triage will only go so far and so fast, as we have limited resources as well.

One of the most recent bugs filed, which you say does not reproduce on 4.16 but does on 4.15 - honestly, we work on upstream.  Distros and others need to look after older kernels if they care.  If /you/ care, then I'd propose bisecting to find which commit made the problem go away, and propose it for -stable if it looks clearly like a bugfix, and cc: the list.  If you really don't care, then I'd say close the bug and only file against current upstream kernels.

As for the rest, in general, there are other things that can help:

Use CONFIG_FRAME_POINTER so that backtraces are readable
Be sure to include the full relevant dmesg, everything after the mount message
Include your full config so we know which debugging options are on or off
Put some effort into your "poc.c" so you can say /which/ action triggered the flaw.
Run with a debug kernel to catch use after free, etc.

We can always download the bits and do the full investigation from scratch, debug kernel runs, etc etc but anything you can do to give a head start is helpful.

If your goal is to help get these fixed, we'd love to have you contribute as much as you can to the triage steps.  It's probably more fulfilling to be actively engaged in the solution as well as the discovery.  ;)  Others may have further suggestions, or think that my suggestions are bad ones, but that's my $0.02 here.

Thanks,
-Eric
