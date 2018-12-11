Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f178.google.com ([209.85.222.178]:33558 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbeLKUcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 15:32:08 -0500
Received: by mail-qk1-f178.google.com with SMTP id o89so9470567qko.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Dec 2018 12:32:07 -0800 (PST)
Received: from lud1.home ([177.98.82.44])
        by smtp.gmail.com with ESMTPSA id 205sm7982931qkf.22.2018.12.11.12.32.05
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 12:32:06 -0800 (PST)
Date: Tue, 11 Dec 2018 18:32:03 -0200
From: Luciano ES <lucmove@gmail.com>
Subject: I got file system corruption with XFS
Message-ID: <20181211183203.7fdbca0f@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I needed to restore something from my backups, an external hard disk 
that is kept separately, always disconnected until I really need it. 

But the file system refused to be mounted: "structure needs cleaning," 
it said.

I googled and didn't find much hope about it. I followed what little 
advice I found: I ran xfs_repair and it didn't work. So I ran it 
again with -L and it worked, but the software itself warned me that 
some files could not be recovered. I'll never know which ones.

I always liked XFS and thought those dreaded days of file system 
corruption and lost files were far behind. So my only question is: 
Why does that happen? The disk is not even used 99% of the time.
How does an XFS file system go belly up just like that?

TIA

-- 
Luciano ES
>>
