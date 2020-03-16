Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEC6C10DCE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 02:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27CF1206BE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 02:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgCPCDv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Mar 2020 22:03:51 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54451 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729387AbgCPCDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Mar 2020 22:03:51 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E78263A4D07;
        Mon, 16 Mar 2020 13:03:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jDf6U-00061N-TM; Mon, 16 Mar 2020 13:03:42 +1100
Date:   Mon, 16 Mar 2020 13:03:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andi Kleen <andi@firstfloor.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Shutdown preventing umount
Message-ID: <20200316020342.GP10776@dread.disaster.area>
References: <20200314133107.4rv25sp4bvhbjjsx@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314133107.4rv25sp4bvhbjjsx@two.firstfloor.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=SoHpTpO9l86dxiEN2VAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 14, 2020 at 06:31:10AM -0700, Andi Kleen wrote:
> 
> Hi,
> 
> I had a cable problem on a USB connected XFS file system, triggering 
> some IO errors, and the result was that any access to the mount point
> resulted in EIO. This prevented unmounting the file system to recover
> from the problem. 

Full dmesg output, please.

> I also tried xfs_io with shutdown -f, but it had the same problem
> because xfs_io couldn't access anything on the file system.

Because the IO errors had already shut the filesystem down, as
per the dmesg output you quoted below.

> How is that supposed to work? Having to reboot just to recover
> from IO errors doesn't seem to be very available.
> 
> I don't think shutdown should prevent unmounting.

It doesn't. Something was leaked or not cleaned up properly,
preventing the filesytem from being unmounted. You know, a bug...

> From googling I found some old RHEL bugzilla that such a problem
> was fixed in some RHEL release. Is that a regression? 

RHEL has an upstream first policy, so whatever bug fix you find in
a RHEL kernel is already in the upstream kernels.

> This was on a 5.4.10 kernel.
> 
> I got lots of:
> 
>  XFS (...): metadata I/O error in "xfs_trans_read_buf_map" at daddr
>  0x4a620288 len 8 error 5
> 
> Then some
> 
> XFS (...): writeback error on sector 7372099184
> 
> And finally:
> 
> XFS (...): log I/O error -5
>  XFS (...): xfs_do_force_shutdown(0x2)
> called from line 1250 of file fs/xfs/xfs_log.c. Return address =
> 00000000f7956130
> XFS (...): Log I/O Error Detected.
> Shutting down filesystem
> XFS (...): Please unmount the filesystem
> and rectify the problem(s)
> 
> (very funny XFS!)
> 
> XFS (...): log I/O error -5
> 
> scsi 7:0:0:0: rejecting I/O to dead device

Where is unmount stuck? 'echo w > /proc/sysrq-trigger' output if it
is hung, 'echo l > /proc/sysrq-trigger' if it is spinning, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
