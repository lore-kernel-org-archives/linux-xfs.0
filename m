Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:35357 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbcK1FAI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 00:00:08 -0500
Received: by mail-qt0-f175.google.com with SMTP id c47so112569759qtc.2
        for <linux-xfs@vger.kernel.org>; Sun, 27 Nov 2016 21:00:08 -0800 (PST)
Subject: Re: Silent skipping of file during xfsrestore
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
 <20161128015956.GX28177@dastard>
From: Will Dormann <wdormann@gmail.com>
Message-ID: <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
Date: Mon, 28 Nov 2016 00:00:06 -0500
MIME-Version: 1.0
In-Reply-To: <20161128015956.GX28177@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

On 11/27/16 8:59 PM, Dave Chinner wrote:
>> So what can cause a file to silently be skipped during restore?
> 
> Usually nothing. This is typical of xfsdump skipping a file due to
> some unexpected occurrence during backup. It's in the dump
> inventory as the directory was processed, but if somthing changed
> during the dump process (e.g. file gets replaced due to atomic
> overwrite via rename) then it may not end up being in the dump.

This file pretty much never gets written to after the first install of
the system, so I wouldn't suspect anything like that would have happened.


>> I'm
>> running the latest xfsdump/xfsrestore provided by Ubuntu 14.04, which is
>> 3.1.1.   I notice the same symptoms from my recovery environment, which
>> is SystemRescueCD 4.2.0
> 
> That's /old/. Try running the latest (3.1.6 IIRC) and see if that
> fixes the issue.


I tried running xfsrestore 3.1.6 on the existing 3.1.1 dump, and I got
the same symptoms:

---

 -> ls /etc/mythtv
            4032 session-settings
         4127166 session-settings~
        50343916 config.xml
         4884092 mysql.txt~

 -> add /etc/mythtv/config.xml

 -> extract

 --------------------------------- end dialog
---------------------------------

/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: mkdir etc
/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: mkdir etc/mythtv
/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: dump session label: ""
/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: dump session id:
f132cc65-5bd4-4a58-a810-52398fe99326
/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: stream 0, object 0, file 0
/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: restoring non-directory files
/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: media file 0 in object 0
of stream 0
/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: restore complete: 207
seconds elapsed
/home/wd/in/xfsdump-3.1.6/restore/xfsrestore: Restore Status: SUCCESS



---

If the latest xfsrestore indicates that a file is in a backup, but then
doesn't actually restore it when asked, isn't that still indicative of a
problem?  That is, if xfsrestore indicates that a file is in a backup,
shouldn't it be restoring something?


I tried creating a new dump with 3.1.6, and subsequently restoring with
3.1.6, and it did succeed in restoring config.xml.

However, that may possibly have nothing to do with any sort of fix.
Because I couldn't restore config.xml when I did my system restore, I
had to create a new copy of it from a file-level backup.  Therefore, the
original problematic file isn't present anywhere other than my existing
xfsdump backups.



-WD

