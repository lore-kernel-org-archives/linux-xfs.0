Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35292 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753078AbdJGOnr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Oct 2017 10:43:47 -0400
Received: by mail-qk0-f194.google.com with SMTP id w63so12074618qkd.2
        for <linux-xfs@vger.kernel.org>; Sat, 07 Oct 2017 07:43:47 -0700 (PDT)
Received: from lubh.lubhome ([179.35.11.249])
        by smtp.gmail.com with ESMTPSA id q82sm2384690qki.34.2017.10.07.07.43.45
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Oct 2017 07:43:46 -0700 (PDT)
Date: Sat, 7 Oct 2017 11:43:43 -0300
From: Luciano ES <lucmove@gmail.com>
Subject: Questions about backups with XFS
Message-ID: <20171007114343.3bd42f98@lubh.lubhome>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I have a few questions and I was torn between asking them separately 
and putting them all in one message. I decided for the latter and I 
hope this is not a problem.

Once upon a time, many many years ago, I used to make backup copies 
of my file systems with the 'cp -aux' command, including my live 
root file system. Luckily, I never had to restore any live root file 
system from those backups. They probably would never have worked.

Later on, someone taught me to do it like this:

find /source -xdev -print0 | cpio -pa0V /target

That command is supposed to copy everything, including special files 
(not really sure which) that mere cp or even rsync would not copy. 
I actually used that approach several times, including restoration, 
and it always worked.

For some reason, I stopped making backups of my live root file 
system, but I still backup other partitions with rsync, always with 
the --delete-before parameter, so the target is always an exact copy 
of the source.

I have been using XFS for a few years and thought that maybe it's 
time I enjoyed all the benefits of the XFS management tools.
However, I am uncertain about things I haven't been able to find in 
the documentation or even on the Web:

Question #1:
Does xfsdump really copy EVERYTHING? Can I backup a full live root 
file system with it and expect a restored copy to boot and run 
uneventfully? Or should I rather do a 'hard' image with xfs_copy? 

Question #2:
By the way, I see that pcmanfm can mount an xfs_copy image quite 
easily, but how do I mount it on the command line, and can I mount 
it in rw mode?

Question #3:
If I make incremental backups with several levels then perform a 
restore, I know that files added in subsequent levels will be added 
to the dump, but what happens with files that have been deleted in 
the source file system? Will they be removed from the dump? In other 
words, is there something analogous to rsync's --delete-before in 
xfsdump/xfsrestore?

Question #4:
Is there any benefit to making incremental backups of a small file 
system? I mean, it's just 10GB, and deleting the old backup and 
doing a level 0 dump from scratch would take what, 3 minutes.

Please note that my goal is disaster recovery. I am planning to run 
a few experiments on my live root file and must be able to restore 
it to a certain state whenever necessary.


Thanks in advance,

-- 
Luciano ES
>>
