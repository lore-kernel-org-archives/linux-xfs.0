Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30957 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbdJFPiG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 11:38:06 -0400
Date: Fri, 6 Oct 2017 08:38:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: agcount for 2TB, 4TB and 8TB drives
Message-ID: <20171006153803.GI7122@magnolia>
References: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2017 at 10:46:20AM +0200, Gandalf Corvotempesta wrote:
> Hi to all,
> i'm new to XFS.
> 
> Which is the proper agcount for 2TB, 4TB and 8TB drives (not part of any RAID) ?
> 
> mkfs.xfs automatically choosen 4 AGs. Isn't this too low ?

No.  Have a look at calc_default_ag_geometry in libxcmd/topology.c for
how we calculate the default AG count / size.  4TB single-disks and
smaller get 4 AGs; larger than that get 1AG per TB.  RAID arrays are
different.

Semirelated question: for a solid state disk on a machine with high CPU
counts do we prefer agcount == cpucount to take advantage of the
high(er) iops and lack of seek time to increase parallelism?

(Not that I've studied that in depth.)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
