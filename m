Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42503 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfDQVkZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 17:40:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id p6so139254pgh.9
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 14:40:25 -0700 (PDT)
Date: Wed, 17 Apr 2019 14:40:23 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] nvme/012 & 013: avoid extremely slow xfs IO
Message-ID: <20190417214023.GA18727@vader>
References: <20190415012229.20689-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415012229.20689-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Apr 15, 2019 at 09:22:29AM +0800, Ming Lei wrote:
> It is observed that nvme/012 may take ~17 minutes to complete on aarch64,
> even worse it may trigger IO timeout on nvme-loop.
> 
> Eric and Dave replied that it is because of too small log size on small
> disk.
> 
> So pass '-l size=32m' to avoid the issue.
> 
> With this patch, nvme/012 can be completed in one minute.

Nice:

nvme/012 (run mkfs and data verification fio job on NVMeOF block device-backed ns) [passed]
    runtime  402.605s  ...  27.431s

Thanks, Ming, applied.
