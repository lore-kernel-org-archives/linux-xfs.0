Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33912 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932357AbcK1Qn3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 11:43:29 -0500
Received: by mail-qk0-f182.google.com with SMTP id q130so145645825qke.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 08:43:29 -0800 (PST)
Subject: Re: Silent skipping of file during xfsrestore
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
 <20161128015956.GX28177@dastard>
 <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
 <20161128082116.GA28177@dastard>
 <eaf5e5dc-5fa8-176b-7d39-47570ee7fd83@gmail.com>
 <3bf9711f-5fa4-4446-47f5-12108b8802c6@sandeen.net>
From: Will Dormann <wdormann@gmail.com>
Message-ID: <beb6ebbd-b794-6c96-3cff-42412cd963f7@gmail.com>
Date: Mon, 28 Nov 2016 11:43:30 -0500
MIME-Version: 1.0
In-Reply-To: <3bf9711f-5fa4-4446-47f5-12108b8802c6@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/16 11:32 AM, Eric Sandeen wrote:
> There is no explicit check on boot for xfs, so nothing would happen there.

Yeah, I thought that was the case.  Just wanted to make sure.


> Can you check timestamps on the file to be sure that your assumption
> that it's not getting written is correct?  I know cups likes to write
> and rewrite config files even if no changes occur, for example.

The problem is that I wiped the target partition clean before doing the
xfsrestore.   So the only copy that could be present anywhere is in the
xfsdump backups.    Is it possible to check the timestamp / metadata of
a file from within xfsrestore?

If not, then I don't think it will be possible to tell what about that
file may have been problematic.  The data in the file is pretty static,
and it's basically the database information that MythTV uses.  That is,
the hostname, username, and password for the MySQL database, and that's
about it.  Those things don't change.  There is also no open handle for
that file when the system is running.  It's just read in once on system
startup.

I replaced the file with a file-level backup that I had from over 3
years ago, and the system is now fine.  My faith in xfsdump is what I'm
still trying to repair.  :)


-WD
