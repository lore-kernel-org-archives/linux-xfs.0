Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:56841 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753387AbcK1CMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2016 21:12:00 -0500
Date: Mon, 28 Nov 2016 12:59:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Silent skipping of file during xfsrestore
Message-ID: <20161128015956.GX28177@dastard>
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Will Dormann <wdormann@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Nov 27, 2016 at 08:49:13PM -0500, Will Dormann wrote:
> Hi folks,
> 
> I recently did a restore of a xfsdump backup and I noticed that an
> important file was missing after the restore completed.  I tried going
> back in using interactive mode to see what was up:
> 
> -----
> 
>  -> ls /etc/mythtv
>             4032 session-settings
>          4127166 session-settings~
>         50343916 config.xml
>          4884092 mysql.txt~
> 
>  -> add /etc/mythtv
> 
>  -> extract
> 
>  --------------------------------- end dialog
> ---------------------------------
> 
> xfsrestore: mkdir etc
> xfsrestore: mkdir etc/mythtv
> xfsrestore: dump session label: ""
> xfsrestore: dump session id: f132cc65-5bd4-4a58-a810-52398fe99326
> xfsrestore: stream 0, object 0, file 0
> xfsrestore: restoring non-directory files
> xfsrestore: media file 0 in object 0 of stream 0
> xfsrestore: restoring etc/mythtv/session-settings (4032 221708883)
> xfsrestore: restoring regular file ino 4032 etc/mythtv/session-settings
> xfsrestore: truncating etc/mythtv/session-settings from 0 to 1170
> xfsrestore: restoring etc/mythtv/session-settings~ (4127166 4079738789)
> xfsrestore: restoring regular file ino 4127166 etc/mythtv/session-settings~
> xfsrestore: truncating etc/mythtv/session-settings~ from 0 to 1169
> xfsrestore: restoring etc/mythtv/mysql.txt~ (4884092 1828724895)
> xfsrestore: restoring regular file ino 4884092 etc/mythtv/mysql.txt~
> xfsrestore: truncating etc/mythtv/mysql.txt~ from 0 to 99
> xfsrestore: restore complete: 125 seconds elapsed
> xfsrestore: Restore Status: SUCCESS
> root@jerky:/mnt/rescue#
> 
> 
> -----
> 
> 
> Note that the file "config.xml" is present in the directory listing, but
> when the restore completes with a SUCCESS status, that file is *not*
> present.
> 
> My backup command is:
> xfsdump -e -l0 - / | pigz > $backupdir/mythbuntu.dgz
> 
> My restore command is:
> pigz -d -c mythbuntu.dgz | xfsrestore -p 10 -r - /mnt/restore
> 
> 
> I don't see any special attributes set on /etc/mythtv/config.xml:
> $ lsattr /etc/mythtv/config.xml
> ---------------- /etc/mythtv/config.xml
> 
> And even so, if a file is excluded, I'd figure that it wouldn't show up
> in the xfsrestore directory listing, right?
> 
> 
> So what can cause a file to silently be skipped during restore?

Usually nothing. This is typical of xfsdump skipping a file due to
some unexpected occurrence during backup. It's in the dump
inventory as the directory was processed, but if somthing changed
during the dump process (e.g. file gets replaced due to atomic
overwrite via rename) then it may not end up being in the dump.

> I'm
> running the latest xfsdump/xfsrestore provided by Ubuntu 14.04, which is
> 3.1.1.   I notice the same symptoms from my recovery environment, which
> is SystemRescueCD 4.2.0

That's /old/. Try running the latest (3.1.6 IIRC) and see if that
fixes the issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
