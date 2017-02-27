Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58254 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdB0Plf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Feb 2017 10:41:35 -0500
Subject: Re: With respect to XFS Bitmap flush to disk
References: <004e01d2909e$d9ce1580$8d6a4080$@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5b2d2e73-bd7e-e705-bd56-d764b7801492@sandeen.net>
Date: Mon, 27 Feb 2017 09:33:10 -0600
MIME-Version: 1.0
In-Reply-To: <004e01d2909e$d9ce1580$8d6a4080$@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Halsey Pian <halsey.pian@gmail.com>, linux-xfs@vger.kernel.org

On 2/26/17 8:11 PM, Halsey Pian wrote:
> Dear All,
> 
> Recently, I try to read analyze the bitmap of XFS file system, it
> seems that I cannot read the latest bitmap from hard disk involving
> the XFS, and cannot read the accurate info even after a long time.
> For example, i cannot get the relevant bitmap info after I add/delete
> a big file to/from XFS file system.

In general, attempting to read metadata from a mounted block device
isn't going to be reliable.  For one, changes may only be staged
in the log, and not yet in their final disk location.
 
> I tried several solution, and find it out that I must execute
> xfs_freeze for the XFS partition in CentOS7, and it seems that
> xfs_freeze doesn’t work for XFS version included in Redhat6.5, I must
> umount/mount the xfs, then I can get the latest bitmap info related
> to the latest data located in disk.
> 
> What  strategy does XFS use to cache/flush bitmap to hard disk?  How
> can I get the accurate bitmap info especially for Redhat6 series
> Operating System? Could you please give help on it?

The short answer is "you can't."  Directly reading the block device
while mounted isn't a supported use of the filesystem.

What are you trying to do, here?

Thanks,
-Eric

> Thanks in advance! ☺
> 
> 
> 
> 
> Halsey Pian
> 
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-xfs" in the body of a message to majordomo@vger.kernel.org More
> majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
