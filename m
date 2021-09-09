Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F94C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 21:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3BF5610C8
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 21:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhIIVLE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:11:04 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39988 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231572AbhIIVLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 17:11:04 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 3E65D108620;
        Fri, 10 Sep 2021 07:09:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mORIt-00AcXM-1N; Fri, 10 Sep 2021 07:09:51 +1000
Date:   Fri, 10 Sep 2021 07:09:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     brian <a001@yakkadesign.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Repair Metadata corruption detected at xfs_inode_buf_verify on
 CentOS 7 virtual machine
Message-ID: <20210909210951.GD2361455@dread.disaster.area>
References: <055dbf6e-a9b5-08a1-43bc-59f93e77f67d@yakkadesign.com>
 <20210908213924.GB2361455@dread.disaster.area>
 <987fa28b-4928-8557-0f09-73839790e910@yakkadesign.com>
 <20210909025445.GC2361455@dread.disaster.area>
 <8a959313-b7ab-5434-7c8f-1cf8990ecb4d@yakkadesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a959313-b7ab-5434-7c8f-1cf8990ecb4d@yakkadesign.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=8nJEP1OIZ-IA:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=RnIsvGkOEIbKFtKIhoYA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 09, 2021 at 03:11:45PM -0400, brian wrote:
> I switched over to ubuntu and got the error "Device or resource busy".  How
> do I get around this error?
> 
> Here is what I did:
> ---------------------------------------------------------
> sudo apt-get install qemu
> sudo apt install qemu-utils
> sudo apt-get install xfsprogs
> 
> sudo modprobe nbd max_part=8
> 
> sudo qemu-nbd --connect=/dev/nbd0
> /media/sf_virtual_machine_share/centoOS7Python3p9_tmp-disk1.vdi
> 
> sudo xfs_repair /dev/nbd0p2
> ---------------------------------------------------------
> 
> I got the error:
> ---------------------------------------------------------
> xfs_repair: cannot open /dev/nbd0p2: Device or resource busy
> ---------------------------------------------------------

Because /dev/nbd0p2 is not the device the filesystem is on. The
filesystem is on a lvm volume:

> brian@brian-VirtualBox:~/Desktop$ sudo lvmdiskscan
>   /dev/loop0  [     219.00 MiB]
>   /dev/loop1  [     <55.44 MiB]
>   /dev/sda1   [     512.00 MiB]
>   /dev/nbd0p1 [       1.00 GiB]
>   /dev/loop2  [     <65.10 MiB]
>   /dev/nbd0p2 [    <101.71 GiB] LVM physical volume

As noted here.

> cmd:
> ---------------------------------------------------------
> sudo lvscan
> ---------------------------------------------------------
> 
> Result:
> ---------------------------------------------------------
>   ACTIVE            '/dev/centos/swap' [2.00 GiB] inherit
>   ACTIVE            '/dev/centos/home' [<49.70 GiB] inherit
>   ACTIVE            '/dev/centos/root' [50.00 GiB] inherit
> ---------------------------------------------------------

And these are the devices inside the LVM volume that contain
filesystems/data.

Likely the one you are having trouble with is /dev/centos/root,
but there may be issues with /dev/centos/home, too.

And to answer your other question, "<dev>" is just shorthand for
"<insert whatever device your filesystem is on here>". i.e.
/dev/centos/root in this case...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
