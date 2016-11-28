Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:32875 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932373AbcK1QKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 11:10:35 -0500
Received: by mail-qt0-f180.google.com with SMTP id p16so126427733qta.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 08:10:34 -0800 (PST)
Subject: Re: Silent skipping of file during xfsrestore
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
 <20161128015956.GX28177@dastard>
 <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
 <20161128082116.GA28177@dastard>
From: Will Dormann <wdormann@gmail.com>
Message-ID: <eaf5e5dc-5fa8-176b-7d39-47570ee7fd83@gmail.com>
Date: Mon, 28 Nov 2016 11:10:36 -0500
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
> 
> There have also been situations where kernel bugs have meant xfsdump
> missed files. e.g. off-by-ones in bulkstat continuation code. These
> bugs had identical symptoms to what you are reporting, but given a
> new dump worked this is probably not the issue....


Another possible scenario that I'm wondering whether it's plausible:

My XFS filesystem was mildly corrupted (e.g. because of power failure or
other trouble).  But not in a way that was checked/noticed/corrected
automatically on system boot, or even had a noticeable effect on the
system other than the missing file on xfsrestore?

The system is back up and running, seemingly-fine.  But perhaps
obviously, my main concern here is to avoid this kind of scenario in the
future.   e.g., is there something I'm missing in my backup routine?
Silent failures on backup/restore are not very reassuring.



Thanks!
-WD
