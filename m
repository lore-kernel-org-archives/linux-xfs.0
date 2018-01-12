Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:36271 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932283AbeALCQq (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:0:0>);
        Thu, 11 Jan 2018 21:16:46 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <5A55AFE7.3080500@youngman.org.uk> <20180111021441.GT16421@dastard>
From: Guoqing Jiang <gqjiang@suse.com>
Message-ID: <93590c11-a8f1-e4cd-acfa-ef5fb10403bb@suse.com>
Date: Fri, 12 Jan 2018 10:16:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180111021441.GT16421@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

Hi Dave,

On 01/11/2018 10:14 AM, Dave Chinner wrote:
>
>> Are you telling me that xfs is aware of the internal structure of an
>> md-raid array?
> It's aware of the /alignment/ characteristics of block devices, and
> these alignment characteristics are exported by MD. e.g.  These are
> exported in /sys/block/<dev>/queue in
>
> 	minimum_io_size
> 		- typically the stripe chunk size
> 	optimal_io_size
> 		- typically the stripe width
>
> We get this stuff from DM and MD devices, hardware raid (via scsi
> code pages), thinp devices (i.e. to tell us the allocation
> granularity so we can align/size IO to match it) and any other block
> device that wants to tell us about optimal IO geometry. libblkid
> provides us with this information, and it's not just mkfs.xfs that
> uses it. e.g. mkfs.ext4 also uses it for the exact same purpose as
> XFS....

I see xfs can detect the geometry with "sunit" and "swidth", ext4 and gfs2
can do similar things as well.

I have one question about xfs on top of raid5. Is it possible that multiple
write operations happen in the same stripe at the same time? Or with the
existence of those parameters, xfs would aggregate them, then it ensures
no conflict happens to the parity of the stripe. Thanks in advance!

Regards,
Guoqing

