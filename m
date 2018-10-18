Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:3761 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbeJRJkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 05:40:22 -0400
Date: Thu, 18 Oct 2018 12:41:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 201453] New: Bug 1640090 - [xfstests xfs/490]: xfs_db print
 a bad (negative number) as agi freecount
Message-ID: <20181018014150.GF6311@dastard>
References: <bug-201453-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-201453-201763@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 17, 2018 at 11:20:42AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> # _scratch_xfs_get_metadata_field "recs[1].freecount" "agi 0" "addr root"       
> -197
> ]# xfs_db -c "agi 0" -c "addr root" -c "print recs[1]" /dev/loop1               
> recs[1] = [startino,holemask,count,freecount,free]
> 1:[128,0,64,-197,0xffffffffffffffe0]
.....
> And it's not reproducible on x86_64:
> # xfs_db -c "agi 0" -c "addr root" -c "print recs[1]" /dev/loop1
> recs[1] = [startino,holemask,count,freecount,free] 
> 1:[128,0,64,59,0xffffffffffffffe0]

-197 = -(256 - 59)

This looks like a sign extension problem in the xfs_db code. s390 is
a big endian system, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
