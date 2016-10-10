Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49313 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbcJJUO2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 16:14:28 -0400
Date: Mon, 10 Oct 2016 16:14:14 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1356481300.121245.1476130454192.JavaMail.zimbra@redhat.com>
In-Reply-To: <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com> <20161007070838.GA16260@quack2.suse.cz> <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com> <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com> <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com> <20161009215454.GM9806@dastard> <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>


> Here you are,
> 
> http://people.redhat.com/qcai/tmp/dmesg
Also, this turned out to be a regression and bisecting so far pointed out this commit,

commit 5d50ac70fe98518dbf620bfba8184254663125eb
Merge: 31c1feb 4e14e49
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Nov 11 20:18:48 2015 -0800

    Merge tag 'xfs-for-linus-4.4' of git://git.kernel.org/pub/scm/linux/kernel/g
    
    Pull xfs updates from Dave Chinner:
     "There is nothing really major here - the only significant addition is
      the per-mount operation statistics infrastructure.  Otherwises there's
      various ACL, xattr, DAX, AIO and logging fixes, and a smattering of
      small cleanups and fixes elsewhere.
    
      Summary:
    
       - per-mount operational statistics in sysfs
       - fixes for concurrent aio append write submission
       - various logging fixes
       - detection of zeroed logs and invalid log sequence numbers on v5 filesys
       - memory allocation failure message improvements
       - a bunch of xattr/ACL fixes
       - fdatasync optimisation
       - miscellaneous other fixes and cleanups"

    * tag 'xfs-for-linus-4.4' of git://git.kernel.org/pub/scm/linux/kernel/git/d
      xfs: give all workqueues rescuer threads
      xfs: fix log recovery op header validation assert
      xfs: Fix error path in xfs_get_acl
      xfs: optimise away log forces on timestamp updates for fdatasync
      xfs: don't leak uuid table on rmmod
      xfs: invalidate cached acl if set via ioctl
      xfs: Plug memory leak in xfs_attrmulti_attr_set
      xfs: Validate the length of on-disk ACLs
      xfs: invalidate cached acl if set directly via xattr
      xfs: xfs_filemap_pmd_fault treats read faults as write faults
      xfs: add ->pfn_mkwrite support for DAX
      xfs: DAX does not use IO completion callbacks
      xfs: Don't use unwritten extents for DAX
      xfs: introduce BMAPI_ZERO for allocating zeroed extents
      xfs: fix inode size update overflow in xfs_map_direct()
      xfs: clear PF_NOFREEZE for xfsaild kthread
      xfs: fix an error code in xfs_fs_fill_super()
      xfs: stats are no longer dependent on CONFIG_PROC_FS
      xfs: simplify /proc teardown & error handling
      xfs: per-filesystem stats counter implementation
      ...
