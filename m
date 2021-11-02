Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAE7C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 04:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EADD260F36
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 04:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhKBEuC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Nov 2021 00:50:02 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:39468 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhKBEuB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Nov 2021 00:50:01 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 1A24lNkp095197;
        Mon, 1 Nov 2021 21:47:26 -0700
Message-ID: <6180C25E.7030901@tlinx.org>
Date:   Mon, 01 Nov 2021 21:45:18 -0700
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

The restore finished, the beginning is:
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.8 (dump format 3.0)
xfsrestore: searching media for dump
xfsrestore: examining media file 0
xfsrestore: dump description: 
xfsrestore: hostname: Ishtar
xfsrestore: mount point: /home
xfsrestore: volume: /dev/Space/Home2
xfsrestore: session time: Mon Nov  1 07:37:47 2021
xfsrestore: level: 0
xfsrestore: session label: "home"
xfsrestore: media label: ""
xfsrestore: file system id: 5f41265a-3114-fb3c-2020-082214061852
xfsrestore: session id: 586026b8-5947-4b95-a213-1532ba25f503
xfsrestore: media id: 5fb4cd58-5cc9-4678-9829-a6539588a170
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsrestore: status at 18:21:14: 1289405/1338497 directories reconstructed, 96.3% complete, 13840475 directory entries processed, 60 seconds elapsed
xfsrestore: 1338497 directories and 14357961 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsrestore: NOTE: ino 259 salvaging file, placing in orphanage/256.0/root+usr+var_copies/20210316/usr/lib/mono/gac/System.Reactive.Runtime.Remoting/2.2.0.0__31bf3856ad364e35/System.Reactive.Runtime.Remoting.dll
...
there are a bunch of lines like that, 'wc' on the file shows:

> wc /tmp/xfsrestore.log 
  5320822  50100130 821050625 /tmp/xfsrestore.log

Then the end of the file looks like:

xfsrestore: NOTE: ino 8485912415 salvaging file, placing in orphanage/256.0/tools/samba/samba-4.14.2/third_party/resolv_wrapper/wscript
xfsrestore: WARNING: unable to rmdir /nhome/./orphanage: Directory not empty
xfsrestore: restore complete: 7643 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /backups/ishtar/home/home-211101-0-0737.dump OK (success)
xfsrestore: Restore Status: SUCCESS

The lines in between beginning and end appear to be 
an incrementing inode & file list of the disk as it was
put into the orphanage

The restored file system appears to slightly larger, but
that's likely because I cleared off some garbage from the
current home.

Ah, the xfsdump just finished:

>/root/bin/dump1fs#160(Xfsdump)> xfsdump -b 268435456 -l 0 -L home -e - /home
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.8 (dump format 3.0)
xfsdump: level 0 dump of Ishtar:/home
xfsdump: dump date: Mon Nov  1 18:15:07 2021
xfsdump: session id: 8f996280-21df-42c5-b0a0-3f1584ae1f54
xfsdump: session label: "home"
xfsdump: NOTE: root ino 192 differs from mount dir ino 256, bind mount?
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 1587242183552 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: ending media file
xfsdump: media file size 1577602668640 bytes
xfsdump: dump size (non-dir files) : 1574177966864 bytes
xfsdump: dump complete: 12536 seconds elapsed
xfsdump: Dump Status: SUCCESS


Except for the 5.3 million lines between the start+end, the xfsrestore output is above.

I can't imagine why you'd want the 5.3 million lines of
file listings, but if you do, I'll need to upload it somewhere.




