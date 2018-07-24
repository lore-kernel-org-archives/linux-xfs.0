Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0110.outbound.protection.outlook.com ([104.47.41.110]:34112
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388786AbeGYAIv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 20:08:51 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Re: Query about the handling of a bug reported before
Date: Tue, 24 Jul 2018 23:00:05 +0000
Message-ID: <244F6DFE-80B8-4CC4-8BD4-5943AF974656@gatech.edu>
References: <21AA8603-85D9-429A-A713-8B86F341FFC4@gatech.edu>
 <20180723123239.GA46987@bfoster>
 <0845407C-6013-44BB-95D0-F1CC66B0ECB6@gatech.edu>
 <20180724224727.GA2234@dastard>
In-Reply-To: <20180724224727.GA2234@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38515F602B715741B7CEF968805F9B80@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

Got it, thanks.

> On Jul 24, 2018, at 6:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Mon, Jul 23, 2018 at 02:27:02PM +0000, Xu, Wen wrote:
>> Hi Brian,
>> 
>> Yeah I tested it which is fixed in latest kernel. I just wonder if there is a specific patch
>> for this.
> 
> The code was fixed as a result of committing the huge patch series
> that removed bufferheads from the XFS IO path.  i.e. the bug went
> away because of other changes that addressed the root cause, not
> because we committed a change that specifically fixed the bug. Most
> likely it was this commit in the middle of the series to remove
> bufferhead dependencies in xfs_aops_discard_page() that solved the
> problem.
> 
> e2ac836307e3 ("xfs: simplify xfs_bmap_punch_delalloc_range")
> 
> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com

