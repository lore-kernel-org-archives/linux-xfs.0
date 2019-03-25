Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59871 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729036AbfCYSCY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:02:24 -0400
Date: Mon, 25 Mar 2019 19:02:13 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190325180213.GA31766@lst.de>
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com> <20190325001044.GA23020@dastard> <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com> <20190325154731.GT1183@magnolia> <CAOQ4uxjh2w3PeyftwJS5djndVp0kSRwf9ki1FUMRqCU9H+uDTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjh2w3PeyftwJS5djndVp0kSRwf9ki1FUMRqCU9H+uDTg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 25, 2019 at 07:56:33PM +0200, Amir Goldstein wrote:
> Sure, let's give that a shot. But allow me to stay skeptical, because
> I don't think there is a one-size-fits-all solution.
> If application doesn't need >4K atomicity and xfs imposes file-wide
> read locks, there is bound to exist a workload where ext4 can guaranty
> lower latencies than xfs.
> 
> Then again, if we fix rw_semaphore to do a good enough job for my
> workload, I may not care about those worst case workloads...

Downgrading these long standing guarantees is simply not an option.

Not quite sure what the I/O pattern of your workload is, but if it
is reads from other regions than you write to you should look into
implementing range locks.
