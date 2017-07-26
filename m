Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pavilion.ashurst.eu.org ([85.119.82.45]:58639 "EHLO
        pavilion.ashurst.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdGZBKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 21:10:05 -0400
Received: from 109.21.187.81.in-addr.arpa ([81.187.21.109] helo=localhost)
        by pavilion.ashurst.eu.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <andyjpb@ashurst.eu.org>)
        id 1daAVa-0003CR-Tq
        for linux-xfs@vger.kernel.org; Wed, 26 Jul 2017 01:49:02 +0100
From: Andy Bennett <andyjpb@ashurst.eu.org>
Date: Wed, 26 Jul 2017 01:48:59 +0100
MIME-Version: 1.0
Message-ID: <575c9d8d-04c9-4d60-93d2-ccc86ec893a9@ashurst.eu.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Subject: Recover file after truncate
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I have a file (~6GiB) that I was doing some analysis on. In the course of 
this I managed to do 'xxd something-else my-file' and overwrote it with < 
4.0K of data.


Running xfs_bmap on it gives me:

-----
my-file:
        0: [0..7]: 236935320..236935327
-----

Running xfs_bmap on another, similar big, file that was created around the 
same time gives me:

-----
other-file:
        0: [0..4194175]: 335806496..340000671
        1: [4194176..13828055]: 342870632..352504511
-----


A quick experiment with xxd suggests that the inode of the file remains the 
same if it exists before xxd writes to it. So my new file still has the 
same inode as the one I want to recover.

There hasn't been any write activity on this file system since I made this 
mistake.


Is there any hope of recovering any part of the original data?

I have an xxd dump of the first 624 bytes of the original file and there 
are some recurring features in it.

Grepping through the partition for that signature gives me this:

-----
$ sudo grep -obUaP "\x66\x66\xa2" /dev/nvme0n1p8 |tee TRACE
grep: exceeded PCRE's line length limit
519554640:ff¢
4377654787:ff¢
7961215381:ff¢
10165641473:ff¢
10849981825:ff¢
17851384491:ff¢
23231901998:ff¢
33898050969:ff¢
41781142596:ff¢
51651699392:ff¢
56040569029:ff¢
56277711167:ff¢
56814897544:ff¢
61037797435:ff¢
61269592210:ff¢
73946170693:ff¢
75199462354:ff¢
76071192135:ff¢
-----


The partition is on an NVMe SSD.


I'm not sure how to use xfs_logprint but converting the inode number to hex 
and grepping through doesn't seem to give me any matches.



Is there a way to find out how this file was allocated and restore it or 
fish the data out some how?

My mount options are

-----
/dev/nvme0n1p8 on /var/spool type xfs (rw,relatime,attr2,inode64,noquota)
-----

...and I'm running under Debian Jessie.

I've not (knowingly) got any manual TRIM or DISCARD jobs that will run.



What's the best way of working out what current files the offsets from grep 
correspond to? I guess the ones that don't correspond to a current file 
might be my data?



Thanks for anything you can do to help.




Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF
