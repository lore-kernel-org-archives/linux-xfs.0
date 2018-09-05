Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48509 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbeIELjA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Sep 2018 07:39:00 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS filesystems?
Date: Wed, 05 Sep 2018 09:09:28 +0200
Message-ID: <4003432.r53nhXgZDq@merkaba>
In-Reply-To: <20180904222345.GV5631@dastard>
References: <20180903224919.GA16358@redhat.com> <8045369.1GWcTSHGau@merkaba> <20180904222345.GV5631@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-xfs@vger.kernel.org

Dave Chinner - 05.09.18, 00:23:
> On Tue, Sep 04, 2018 at 05:36:43PM +0200, Martin Steigerwald wrote:
> > Dave Chinner - 04.09.18, 02:49:
> > > On Mon, Sep 03, 2018 at 11:49:19PM +0100, Richard W.M. Jones 
wrote:
> > > > [This is silly and has no real purpose except to explore the
> > > > limits.
> > > > If that offends you, don't read the rest of this email.]
> > > 
> > > We do this quite frequently ourselves, even if it is just to
> > > remind
> > > ourselves how long it takes to wait for millions of IOs to be
> > > done.
> > 
> > Just for the fun of it during an Linux Performance analysis & tuning
> > course I held I created a 1 EiB XFS filesystem a sparse file on
> > another XFS filesystem on an SSD of a ThinkPad T520. It took
> > several hours to create, but then it was there and mountable. AFAIR
> > the sparse file was a bit less than 20 GiB.
> 
> Yup, 20GB of single sector IOs takes a long time.

Yeah. It was interesting to see that neither the CPU nor the SSD was 
fully utilized during that time tough.

> > Trying to write more data to it than the parent filesystem can hold
> > back then resulted in "lost buffer writes" or something like that
> > in kernel.log, but no visible error message to the process that
> > wrote the data.
> 
> That should mostly be fixed by now with all the error handling work
> that went into the generic writeback path a few kernel releases ago.
> Also, remember that the only guaranteed way to determine that there
> was a writeback error is to run fsync on the file, and most
> applications don't do that after writing their data.

Great. I saw the recent writeback error discussion as well.

Thanks,
-- 
Martin
