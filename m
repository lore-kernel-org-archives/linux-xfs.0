Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E69DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 01:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74DFD60EDF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 01:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhKBBwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 21:52:01 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:39466 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKBBwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 21:52:01 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 1A21nOE8074872;
        Mon, 1 Nov 2021 18:49:26 -0700
Message-ID: <618098A7.2010103@tlinx.org>
Date:   Mon, 01 Nov 2021 18:47:19 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     Dave Chinner <david@fromorbit.com>
CC:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: cause of xfsdump msg: root ino 192 differs from mount dir ino
 256
References: <617721E0.5000009@tlinx.org> <20211026004814.GA5111@dread.disaster.area> <617F0A6D.6060506@tlinx.org> <61804CD4.8070103@tlinx.org> <20211101211244.GC449541@dread.disaster.area>
In-Reply-To: <20211101211244.GC449541@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2021/11/01 14:12, Dave Chinner wrote:

> Can you attach the full output for the xfs_dump and xfsrestore
> commands 
---
Full output for the dump shouldn't be long, but the xfs is
about 20% done and already has a 240MB output file because,
essentially, every file on the filesystem is listed
in the output in the form:
xfsrestore: NOTE: ino 2268735942 salvaging file, placing in orphanage/256.0/root+usr+var_copies/20190301/root/usr/lib/perl5/vendor_perl/5.18/WWW/Mechanize/Examples.pod

If the ratios hold, that's looking to be over 1G of output.
(uncompressed, but still...)

Um you sure about wanting that?  If so, where?

