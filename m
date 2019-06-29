Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52150 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbfF2Rb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Jun 2019 13:31:58 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6C5BD28735
        for <linux-xfs@vger.kernel.org>; Sat, 29 Jun 2019 17:31:57 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Sat, 29 Jun 2019 17:31:56 +0000
Message-ID: <bug-203947-201763-3bw6dZMvJI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203947-201763@https.bugzilla.kernel.org/>
References: <bug-203947-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203947

--- Comment #8 from Darrick J. Wong (djwong+kernel@djwong.org) ---
Ok, so I reproduced it locally and tracked the crash to this part of
xfs_bmapi_read() where we dereference *ifp:

        if (!(ifp->if_flags & XFS_IFEXTENTS)) {                                 
                error = xfs_iread_extents(NULL, ip, whichfork);                 
                if (error)                                                      
                        return error;                                           
        }                                                                       

Looking at xfs_iformat_fork(), it seems that if there's any kind of error
formatting the attr fork it'll free ip->i_afp and set it to NULL, so I think
the fix is to add an "if (!afp) return -EIO;" somewhere.

Not sure how we actually get to this place, though.  fsstress is running
bulkstat, which is inactivating an inode with i_nlink == 0 and a corrupt attr
fork that won't load.  Maybe we hit an inode that had previously gone through
unlinked processing after log recovery but was lurking on the mru waiting to be
inactivated, but then bulkstat showed up (with its IGET_DONTCACHE) which forced
immediate inactivation?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
