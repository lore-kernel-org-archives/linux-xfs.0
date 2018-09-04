Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44613 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbeIDUCX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 16:02:23 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS filesystems?
Date: Tue, 04 Sep 2018 17:36:43 +0200
Message-ID: <8045369.1GWcTSHGau@merkaba>
In-Reply-To: <20180904004940.GR5631@dastard>
References: <20180903224919.GA16358@redhat.com> <20180904004940.GR5631@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-xfs@vger.kernel.org

Dave Chinner - 04.09.18, 02:49:
> On Mon, Sep 03, 2018 at 11:49:19PM +0100, Richard W.M. Jones wrote:
> > [This is silly and has no real purpose except to explore the limits.
> > If that offends you, don't read the rest of this email.]
> 
> We do this quite frequently ourselves, even if it is just to remind
> ourselves how long it takes to wait for millions of IOs to be done.

Just for the fun of it during an Linux Performance analysis & tuning 
course I held I created a 1 EiB XFS filesystem a sparse file on another 
XFS filesystem on an SSD of a ThinkPad T520. It took several hours to 
create, but then it was there and mountable. AFAIR the sparse file was a 
bit less than 20 GiB.

Trying to write more data to it than the parent filesystem can hold back 
then resulted in "lost buffer writes" or something like that in 
kernel.log, but no visible error message to the process that wrote the 
data.

Thanks,
-- 
Martin
