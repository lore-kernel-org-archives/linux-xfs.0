Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:36078 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754549AbcK1NRD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 08:17:03 -0500
Received: by mail-qt0-f178.google.com with SMTP id w33so121349465qtc.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 05:17:02 -0800 (PST)
Subject: Re: Silent skipping of file during xfsrestore
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
 <20161128015956.GX28177@dastard>
 <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
 <20161128082116.GA28177@dastard>
From: Will Dormann <wdormann@gmail.com>
Message-ID: <d555ad16-5b1e-1c22-5ee2-b4f248164b06@gmail.com>
Date: Mon, 28 Nov 2016 08:17:00 -0500
MIME-Version: 1.0
In-Reply-To: <20161128082116.GA28177@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/16 3:21 AM, Dave Chinner wrote:
> I think you misunderstand how the inventory and dump process
> works. The dump process first builds the inventory inode map that it
> needs to back up, then goes and backs up what it mapped in the
> inventory.  The filesystem can change between the inventory build
> an dump trying to backup the file, and if the file does not match
> the inventory for some reason (e.g. different inode generation
> number) it will skip it. The file does not get removed from the
> inventory, though, because that's already been written to the dump
> file.


Got it.  Thanks.   At the end of the backup, wouldn't xfsdump know what
files were not able to be backed up, though?   In my case, I had a level
0 backup, and also a level 1 backup.   The problematic file wasn't
present / able-to-be-restored in either backup set.

That is, if somebody does a level 0 backup, and a file isn't properly
backed up for whatever reason, that file is flagged as "not backed up".
That would allow it to be subsequently backed up in a
higher-level-number backup.   Note that in my case, I tried restoring
from the most-recent level 1 backup, the most-recent level 0 backup, and
an older level 0 backup as well.  None were able to restore the file.

If this isn't possible, then I suspect that an xfsdump/xfsrestore of a
(running?) system perhaps isn't as robust as I had hoped.  In
particular, that you might not have all of the files that you need, but
you won't know until you actually go to use the system you restored.



Thanks
-WD
