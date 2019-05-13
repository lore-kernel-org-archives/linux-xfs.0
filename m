Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56535 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbfEMVTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 May 2019 17:19:52 -0400
Date: Tue, 14 May 2019 07:19:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
Message-ID: <20190513211947.GR29573@dread.disaster.area>
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tim Smith <tim.smith@vaultcloud.com.au>
Cc: linux-xfs@vger.kernel.org

On Mon, May 13, 2019 at 11:45:26AM +1000, Tim Smith wrote:
> Hey guys,
> 
> We've got a bunch of hosts with multiple spinning disks providing file
> server duties with xfs.
> 
> Some of the filesystems will go into a state where they report
> negative used space -  e.g. available is greater than total.
> 
> This appears to be purely cosmetic, as we can still write data to (and
> read from) the filesystem, but it throws out our reporting data.
> 
> We can (temporarily) fix the issue by unmounting and running
> `xfs_repair` on the filesystem, but it soon reoccurs.
....
> Example of a 'good' filesystem on the host:
.....
> fdblocks = 459388955
> 
> Example of a 'bad' filesystem on the host:
.....
> fdblocks = 4733263928


  decimal	 hex
 459388955	 1b61b7cb
4733263928	11a1fdfe8
                ^
		Single bit is wrong in the free block count.

IOWs, I'd say there's single bit errors happening somewhere in your
system. Whether it be memory corruption, machines being rowhammered,
uncorrected storage media errors, etc I have no idea. But it seems
suspicious that the free block count is almost exactly 0x100000000
out....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
