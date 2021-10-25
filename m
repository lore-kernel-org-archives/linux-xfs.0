Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D041CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Oct 2021 22:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD3E460EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Oct 2021 22:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhJYWIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Oct 2021 18:08:06 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:39434 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhJYWIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Oct 2021 18:08:05 -0400
X-Greylist: delayed 2054 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2021 18:08:05 EDT
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 19PLUWBs031730
        for <linux-xfs@vger.kernel.org>; Mon, 25 Oct 2021 14:30:35 -0700
Message-ID: <617721E0.5000009@tlinx.org>
Date:   Mon, 25 Oct 2021 14:30:08 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: xfsrestore'ing from file backups don't restore...why not?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm trying to do a cumulative restore a directory 
from a multi-file backup w/names:
-rw-rw-r-- 1 1578485336160 Oct  1 06:51 home-211001-0-0437.dump
-rw-rw-r-- 1  262411348256 Oct 23 04:53 home-211023-1-0431.dump
-rw-rw-r-- 1    1881207032 Oct 25 04:31 home-211025-2-0430.dump



At first I tried "-i" but once I got a prompt, no files or directories
were visible.

So I tried restoring the full thing:

I'm getting 1000's of messages like where it doesn't seem to be able
to restore the file and instead places it in the orphanage:

xfsrestore: NOTE: ino 1879669758 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/coherent_tail_mean.html
xfsrestore: NOTE: ino 1879669759 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/count.html
xfsrestore: NOTE: ino 1879669760 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/covariance.html
xfsrestore: NOTE: ino 1879669761 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/density.html
xfsrestore: NOTE: ino 1879669762 salvaging file, placing in orphanage/256.0/tools/libboost/boost_1_64_0/doc/html/boost/accumulators/extract/extended_p_square.html


-----

I've seen this before and was able to restore the file I wanted from
the "orphanage" -- instead of installing into the directory
I gave, it gives the above messages.

xfsdump+restore claim to be from xfsdump-3.1.8-1.3.x86_64
from openSUSE with Build Date  : Tue Jan 29 16:46:13 2019

I have also tried this on an empty partition -- same thing.
Why am I not able to restore my backups?






