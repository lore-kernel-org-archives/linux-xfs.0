Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from welcomes-you.com ([144.76.218.113]:56502 "EHLO
        smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbdKBIlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 04:41:18 -0400
Subject: Re: Possible to mount this XFS at least temporarily to retrieve
 files?
References: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
 <20171025212955.GZ3666@dastard>
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Message-ID: <013706b1-0ced-8d7c-6a0c-fc12bf918a46@aei.mpg.de>
Date: Thu, 2 Nov 2017 09:41:14 +0100
MIME-Version: 1.0
In-Reply-To: <20171025212955.GZ3666@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave and all others who replied,

I just realized I have not answered on list to thank you all for the
analysis of his failure!

On 10/25/17 23:29, Dave Chinner wrote:
> 
> This is a pretty good indication that the RAID rebuild has
> completely jumbled up the disks and the data on the disks during
> the rebuild.

*sigh*

> It's a hardware raid controller that is having hardware problems
> during a rebuild.  I'd say your filesystem is completely screwed
> because the rebuild went wrong and you have no way of knowing what
> blocks are good and what aren't, nor even whether the RAID has been
> assembled correctly after the failure. Hence even if you could mount
> it, the data in the files is likely to be corrupt/incorrect
> anyway...

We will now replace these controllers with dumb SAS HBA and will try to
keep the "raid" features at a different level (md+xfs and/or zfs) which
hopefully will avoid this failure mode in the future.

Until then, I think we are lucky as we do not have hot spares defined on
these controllers as that would prohibit us to react properly and
eliminate host I/O at a time of our choosing...

Thanks a lot again!

Cheers

Carsten

-- 
Dr. Carsten Aulbert, Max Planck Institute for Gravitational Physics,
Callinstraße 38, 30167 Hannover, Germany
Phone: +49 511 762 17185
