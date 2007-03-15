Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 09:29:18 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FGT96p002553
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 09:29:11 -0700
Date: Thu, 15 Mar 2007 17:17:04 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Announce: new-aops-1 for 2.6.21-rc3
Message-ID: <20070315161704.GH8321@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>, Mark Fasheh <mark.fasheh@oracle.com>
Cc: reiserfs-list@namesys.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, nfs@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net

OK, I've gone through and fixed several bugs until the thing actually
survives fsx-linux for both ext2 and ext3 ordered and writeback (both
when using the new aops, and the legacy prepare_write path). Actually
ext3 sometimes breaks, but it does in unpatched kernels anyway.

At 15 patches (including the initial buffered write deadlock fixes),
it is too much to keep posting -- not much has fundamentally changed,
so I'll just post occasionally if we make big changes. The quilt
format is probably easier for someone wishing to work on it anyway.

http://www.kernel.org/pub/linux/kernel/people/npiggin/patches/new-aops/

(excludes the OCFS2 patch that Mark sent, in anticipation of an update)

It would be really nice if filesystem developers could take a look
at the new interfaces some time, because otherwise they might get stuck
with it :) So I'm cc'ing a few filesystems that come to mind, that I 
haven't heard anything from. 

Thanks,
Nick
