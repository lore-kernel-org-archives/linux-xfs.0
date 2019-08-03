Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35813 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387429AbfHCIFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Aug 2019 04:05:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so76389752qto.2
        for <linux-xfs@vger.kernel.org>; Sat, 03 Aug 2019 01:05:21 -0700 (PDT)
Received: from lud1.home ([177.17.22.67])
        by smtp.gmail.com with ESMTPSA id g23sm665983qtq.49.2019.08.03.01.05.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 03 Aug 2019 01:05:20 -0700 (PDT)
Date: Sat, 3 Aug 2019 05:05:17 -0300
From: Luciano ES <lucmove@gmail.com>
Subject: Re: XFS file system corruption, refuses to mount
Message-ID: <20190803050517.55b15f57@lud1.home>
In-Reply-To: <20190803011106.GJ7138@magnolia>
References: <20181211183203.7fdbca0f@lud1.home>
        <20190803011106.GJ7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: XFS mailing list <linux-xfs@vger.kernel.org>

On Fri, 2 Aug 2019 18:11:06 -0700, Darrick J. Wong wrote:

> > Is there something I can do to recover the data?  
> 
> Try xfs_repair -n to see what it would do if you ran repair?

I tried it. It took a very long time.

Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
...................................... (a million dots)
Sorry, could not find valid secondary superblock
Exiting now.

I tested the file system (unlocked) with the fsck, lsblk, blkid and 
file commands, all of which confirm that it is an XFS file system. 
It just won't mount. Is there any recovery procedure?

-- 
Luciano ES
>>
