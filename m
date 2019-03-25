Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f47.google.com ([209.85.161.47]:42940 "EHLO
        mail-yw1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbfCYSoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 14:44:13 -0400
MIME-Version: 1.0
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard> <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
 <20190325154731.GT1183@magnolia> <CAOQ4uxjh2w3PeyftwJS5djndVp0kSRwf9ki1FUMRqCU9H+uDTg@mail.gmail.com>
 <20190325180213.GA31766@lst.de>
In-Reply-To: <20190325180213.GA31766@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 25 Mar 2019 20:44:01 +0200
Message-ID: <CAOQ4uxgWnBDHZhn3kAWuO3L=u9sJB-LSQ9JHOC=qG+pGCzQ4Tw@mail.gmail.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 25, 2019 at 8:02 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Mar 25, 2019 at 07:56:33PM +0200, Amir Goldstein wrote:
> > Sure, let's give that a shot. But allow me to stay skeptical, because
> > I don't think there is a one-size-fits-all solution.
> > If application doesn't need >4K atomicity and xfs imposes file-wide
> > read locks, there is bound to exist a workload where ext4 can guaranty
> > lower latencies than xfs.
> >
> > Then again, if we fix rw_semaphore to do a good enough job for my
> > workload, I may not care about those worst case workloads...
>
> Downgrading these long standing guarantees is simply not an option.

Right. Not without user opt-in.

>
> Not quite sure what the I/O pattern of your workload is, but if it
> is reads from other regions than you write to you should look into
> implementing range locks.

Workload is a VM image file (VDI) accessed with random IO
pattern over SMB. I am still studying the accurate rd/wr mix
patterns that really matter to customers.

Thanks,
Amir.
