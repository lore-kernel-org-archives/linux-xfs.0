Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38961 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726529AbfACWvN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 17:51:13 -0500
Date: Fri, 4 Jan 2019 09:51:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202127] cannot mount or create xfs on a  597T device
Message-ID: <20190103225108.GP4205@dastard>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
 <bug-202127-201763-gkEuA391xL@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202127-201763-gkEuA391xL@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 03, 2019 at 10:18:56PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202127
> 
> --- Comment #3 from daimh@umich.edu ---
> [root@watsons-s1 ~]# blockdev --getsz  --getsize64 --getss --getpbsz 
> --getiomin   --getioopt /dev/sda
> 1195272830976
> 611979689459712
> 512
> 4096
> 1048576
> 262144

Ok, so iomin=1MB  and ioopt=256k. That's an invalid block device
configuration. If this is coming from hardware RAID (e.g. via a scsi
code page) then this is a firmware bug. If this is coming from a
softare layer (e.g. lvm, md, etc) then it may be a bug in one of
those layers.

IOWs, we need to know what your storage stack configuration is and
what hardware underlies /dev/sda. Can you attach the storage stack
and hardware information indicated in this link for us?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Eric, we probably need to catch this in mkfs when validating blkid
information - the superblock verifier is too late to be catching
bad config info like this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
