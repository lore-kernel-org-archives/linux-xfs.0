Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33307 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752857AbcK1WAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 17:00:32 -0500
Received: by mail-qk0-f174.google.com with SMTP id x190so155503153qkb.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:00:31 -0800 (PST)
Subject: Re: Silent skipping of file during xfsrestore
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
 <20161128015956.GX28177@dastard>
 <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
 <20161128082116.GA28177@dastard>
 <d555ad16-5b1e-1c22-5ee2-b4f248164b06@gmail.com>
 <20161128213350.GB28177@dastard>
From: Will Dormann <wdormann@gmail.com>
Message-ID: <3c5d290e-c960-bf5e-ee38-1ece24c6d929@gmail.com>
Date: Mon, 28 Nov 2016 17:00:29 -0500
MIME-Version: 1.0
In-Reply-To: <20161128213350.GB28177@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/16 4:33 PM, Dave Chinner wrote:
> On Mon, Nov 28, 2016 at 08:17:00AM -0500, Will Dormann wrote:
>> If this isn't possible, then I suspect that an xfsdump/xfsrestore of a
>> (running?) system perhaps isn't as robust as I had hoped. 
> 
> It has never been 100% robust when run on a live filesystem that is
> being modified as the backup is running. If you want robust, exact
> point in time backups, then snapshot the filesystem and run the
> backup from the snapshot. Then remove the snapshot once the backup
> completes....


Good to know!  In the past I had done offline backups, but I had
eventually figured that xfsdump + mysqldump might get me what I want
without rebooting.

Given that I don't have any LVM to provide snapshots, the best bet may
be to have an offline backup for guaranteed, bare-metal restores.  And
xfsdump/mysqldump for more-handy online backups / restores.


Thanks for the help.


-WD
