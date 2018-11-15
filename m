Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sour.ops.eusc.inter.net ([84.23.254.154]:27376 "EHLO
        sour.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387833AbeKPDRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 22:17:11 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: xfs remove / unlink extremely slow ?
From: Michael Arndt <Michael.Arndt@berlin.de>
In-Reply-To: <20181115153815.GA27512@bfoster>
Date: Thu, 15 Nov 2018 18:07:29 +0100
Content-Transfer-Encoding: 8BIT
Message-Id: <2CBCDE57-BEA2-4D64-929A-2C680CDBB62B@berlin.de>
References: <3927644F-734A-4A2A-BACB-DE44CBC812EB@berlin.de>
 <14251045-1CCF-4E35-95F1-F6597FD8FD8C@berlin.de>
 <20181114144511.GB19257@bfoster> <20181115153815.GA27512@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Brian,

Info, supporting your remark about VFS layer: 

I did a reboot of cluster headnode and after that the remove was „fast“ meanig the typical millsecond /single file  to seconds /  removal of whole trees.

What does your intuition say, what could be suspected in the VFS layer / lvm2 layer or below to trigger this problem 
( just to collect ideas, where to search). ?

Caused by the fact, that the problem was seen also two times before, the issue will reappear after some time.

Off topic: is the mount option delaylog still functional or obsoleted, because already default behaviour ?

best
Micha
thx for extremely friendly help
