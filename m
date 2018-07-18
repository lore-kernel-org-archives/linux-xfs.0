Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35049 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbeGRTUk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 15:20:40 -0400
Received: by mail-lf0-f41.google.com with SMTP id f18-v6so4180165lfc.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 11:41:29 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 18 Jul 2018 12:41:27 -0600
Message-ID: <CAJCQCtSJUV-0LYCTS2mfeZWA812aqc5oQagsWZ5fi3xuXQ9ncA@mail.gmail.com>
Subject: filefrag and reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

xfsprogs 4.17.0 mkfs with reflink=1
kernel 4.17.6

$ fallocate -l 1g tmp2
$ cp --reflink tmp2 tmp3
$ filefrag -v *
Filesystem type is: 58465342
File size of tmp2 is 1073741824 (262144 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..  130136:         24..    130160: 130137:             unwritten
   1:   130137..  260280:     131082..    261225: 130144:     130161: unwritten
   2:   260281..  262143:     264714..    266576:   1863:     261226:
last,unwritten,eof
tmp2: 3 extents found
File size of tmp3 is 1073741824 (262144 blocks of 4096 bytes)
tmp3: 0 extents found
[chris@f28s xfs]$


Is this expected? When I do it on Btrfs, I see identical information
for the two files after reflink copy, with flags "unwritten,shared".

Regular files behave as expected, I'm only seeing this on reflink
copies of fallocated files.




-- 
Chris Murphy
