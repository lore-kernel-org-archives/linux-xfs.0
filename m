Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16D8C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 22:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F19E22A85
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 22:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgLUWFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 17:05:36 -0500
Received: from smtp1.onthe.net.au ([203.22.196.249]:37903 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUWFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Dec 2020 17:05:35 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2020 17:05:34 EST
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id B7DDF61938
        for <linux-xfs@vger.kernel.org>; Tue, 22 Dec 2020 08:54:53 +1100 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id mhZpe-EsAUvl for <linux-xfs@vger.kernel.org>;
        Tue, 22 Dec 2020 08:54:53 +1100 (AEDT)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 882C061935
        for <linux-xfs@vger.kernel.org>; Tue, 22 Dec 2020 08:54:53 +1100 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 6BC32680D6F; Tue, 22 Dec 2020 08:54:53 +1100 (AEDT)
Date:   Tue, 22 Dec 2020 08:54:53 +1100
From:   Chris Dunlop <chris@onthe.net.au>
To:     linux-xfs@vger.kernel.org
Subject: Extreme fragmentation ho!
Message-ID: <20201221215453.GA1886598@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I have a 2T file fragmented into 841891 randomly placed extents. It takes 
4-6 minutes (depending on what else the filesystem is doing) to delete the 
file. This is causing a timeout in the application doing the removal, and 
hilarity ensues.

The fragmentation is the result of reflinking bits and bobs from other 
files into the subject file, so it's probably unavoidable.

The file is sitting on XFS on LV on a raid6 comprising 6 x 5400 RPM HDD:

# xfs_info /home
meta-data=/dev/mapper/vg00-home  isize=512    agcount=32, agsize=244184192 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=1
          =                       reflink=1
data     =                       bsize=4096   blocks=7813893120, imaxpct=5
          =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I'm guessing the time taken to remove is not unreasonable given the speed 
of the underlying storage and the amount of metadata involved. Does my 
guess seem correct?

I'd like to do some experimentation with a facsimile of this file, e.g.  
try the remove on different storage subsystems, and/or with a external fast 
journal etc., to see how they compare.

What is the easiest way to recreate a similarly (or even better, 
identically) fragmented file?

One way would be to use xfs_metadump / xfs_mdrestore to create an entire 
copy of the original filesystem, but I'd really prefer not taking the 
original fs offline for the time required. I also don't have the space to 
restore the whole fs but perhaps using lvmthin can address the restore 
issue, at the cost of a slight(?) performance impact due to the extra 
layer.

Is it possible to using the output of xfs_bmap on the original file to 
drive ...something, maybe xfs_io, to recreate the fragmentation? A naive 
test using xfs_io pwrite didn't produce any fragmentation - unsurprisingly, 
given the effort XFS puts into reducing fragmentation.

Cheers,

Chris
