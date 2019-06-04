Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:40447 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726877AbfFDJ3E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Jun 2019 05:29:04 -0400
Message-ID: <7a642f570980609ccff126a78f1546265ba913e2.camel@lynxeye.de>
Subject: understanding xfs vs. ext4 log performance
From: Lucas Stach <dev@lynxeye.de>
Date: Tue, 04 Jun 2019 11:21:15 +0200
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi all,

this question is more out of curiosity and because I want to take the
chance to learn something.

At work we've stumbled over a workload that seems to hit pathological
performance on XFS. Basically the critical part of the workload is a
"rm -rf" of a pretty large directory tree, filled with files of mixed
size ranging from a few KB to a few MB. The filesystem resides on quite
slow spinning rust disks, directly attached to the host, so no
controller with a BBU or something like that involved.

We've tested the workload with both xfs and ext4, and while the numbers
aren't completely accurate due to other factors playing into the
runtime, performance difference between XFS and ext4 seems to be an
order of magnitude. (Ballpark runtime XFS is 30 mins, while ext4
handles the remove in ~3 mins).

The XFS performance seems to be completly dominated by log buffer
writes, which happen with both REQ_PREFLUSH and REQ_FUA set. It's
pretty obvious why this kills performance on slow spinning rust.

Now the thing I wonder about is why ext4 seems to get a away without
those costly flags for its log writes. At least blktrace shows almost
zero PREFLUSH or FUA requests. Is there some fundamental difference in
how ext4 handles its logging to avoid the need for this ordering and
forced access, or is it ext just living more dangerously with regard to
reordered writes?

Does XFS really require such a strong ordering on the log buffer
writes? I don't understand enough of the XFS transaction code and
wonder if it would be possible to do the strongly ordered writes only
on transaction commit.

Regards,
Lucas
