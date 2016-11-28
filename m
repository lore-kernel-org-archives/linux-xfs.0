Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34260 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbcK1BtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2016 20:49:16 -0500
Received: by mail-qt0-f169.google.com with SMTP id n6so110053496qtd.1
        for <linux-xfs@vger.kernel.org>; Sun, 27 Nov 2016 17:49:15 -0800 (PST)
Received: from sslvpn-97-223.sei.cmu.edu (pool-74-109-198-208.pitbpa.fios.verizon.net. [74.109.198.208])
        by smtp.googlemail.com with ESMTPSA id o31sm27270155qtf.20.2016.11.27.17.49.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Nov 2016 17:49:14 -0800 (PST)
From: Will Dormann <wdormann@gmail.com>
Subject: Silent skipping of file during xfsrestore
Message-ID: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
Date: Sun, 27 Nov 2016 20:49:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

I recently did a restore of a xfsdump backup and I noticed that an
important file was missing after the restore completed.  I tried going
back in using interactive mode to see what was up:

-----

 -> ls /etc/mythtv
            4032 session-settings
         4127166 session-settings~
        50343916 config.xml
         4884092 mysql.txt~

 -> add /etc/mythtv

 -> extract

 --------------------------------- end dialog
---------------------------------

xfsrestore: mkdir etc
xfsrestore: mkdir etc/mythtv
xfsrestore: dump session label: ""
xfsrestore: dump session id: f132cc65-5bd4-4a58-a810-52398fe99326
xfsrestore: stream 0, object 0, file 0
xfsrestore: restoring non-directory files
xfsrestore: media file 0 in object 0 of stream 0
xfsrestore: restoring etc/mythtv/session-settings (4032 221708883)
xfsrestore: restoring regular file ino 4032 etc/mythtv/session-settings
xfsrestore: truncating etc/mythtv/session-settings from 0 to 1170
xfsrestore: restoring etc/mythtv/session-settings~ (4127166 4079738789)
xfsrestore: restoring regular file ino 4127166 etc/mythtv/session-settings~
xfsrestore: truncating etc/mythtv/session-settings~ from 0 to 1169
xfsrestore: restoring etc/mythtv/mysql.txt~ (4884092 1828724895)
xfsrestore: restoring regular file ino 4884092 etc/mythtv/mysql.txt~
xfsrestore: truncating etc/mythtv/mysql.txt~ from 0 to 99
xfsrestore: restore complete: 125 seconds elapsed
xfsrestore: Restore Status: SUCCESS
root@jerky:/mnt/rescue#


-----


Note that the file "config.xml" is present in the directory listing, but
when the restore completes with a SUCCESS status, that file is *not*
present.

My backup command is:
xfsdump -e -l0 - / | pigz > $backupdir/mythbuntu.dgz

My restore command is:
pigz -d -c mythbuntu.dgz | xfsrestore -p 10 -r - /mnt/restore


I don't see any special attributes set on /etc/mythtv/config.xml:
$ lsattr /etc/mythtv/config.xml
---------------- /etc/mythtv/config.xml

And even so, if a file is excluded, I'd figure that it wouldn't show up
in the xfsrestore directory listing, right?


So what can cause a file to silently be skipped during restore?   I'm
running the latest xfsdump/xfsrestore provided by Ubuntu 14.04, which is
3.1.1.   I notice the same symptoms from my recovery environment, which
is SystemRescueCD 4.2.0


Thanks!
-WD
