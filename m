Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:64960 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754555AbeAMIR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jan 2018 03:17:29 -0500
Date: Sat, 13 Jan 2018 09:17:25 +0100
From: Heinz Diehl <htd+ml@fritha.org>
Subject: Re: XFS journal corruption after every reboot/shutdown
Message-ID: <20180113081725.GA27564@fritha.org>
Reply-To: linux-xfs@vger.kernel.org
References: <20180111224451.GA3413@fritha.org>
 <20180111231358.GW16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180111231358.GW16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 12.01.2018, Dave Chinner wrote: 

> On XFS, this leaves the journal dirty so that when the filesystem
> is mounted on boot it can clean up things like orphan inodes that
> were present at the time of the remount,ro (e.g. open but unlinked
> files).

> IOWs, what you are seeing is normal filesystem behaviour that is a
> result of systemd being unable to unmount the root filesystem
> cleanly because it still has references open to the root filesystem.

Ok, I see. Thanks for clarifying!

> > I have also filed a bug report here because there's F27 on all machines:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1533620
 
> Not a bug, please close it.

I remember a time not too long ago where the root fs was clean after a
reboot/shutdown (maybe around F25?). So something must have changed
in the way systemd performs a reboot/shutdown..

Thanks,
 Heinz
 
