Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FABC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Oct 2021 17:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7696A610C8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Oct 2021 17:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJ1RRh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 13:17:37 -0400
Received: from sandeen.net ([63.231.237.45]:37760 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230174AbhJ1RRh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Oct 2021 13:17:37 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 143314919;
        Thu, 28 Oct 2021 12:13:42 -0500 (CDT)
Message-ID: <6412d9dc-e058-c807-5b2e-524e85333783@sandeen.net>
Date:   Thu, 28 Oct 2021 12:15:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Content-Language: en-US
To:     Gabe Al-Ghalith <algh0022@umn.edu>, linux-xfs@vger.kernel.org
References: <CAPqFctLu3L=qxf+Agwks5F+wTCxgRKgHqrQqokRPi62744KLHQ@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Segmentation fault on 28tb usb3 volume with xfs_repair
In-Reply-To: <CAPqFctLu3L=qxf+Agwks5F+wTCxgRKgHqrQqokRPi62744KLHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/27/21 4:06 PM, Gabe Al-Ghalith wrote:
> I'm running a 28TB volume on USB3 with xfs. I have many other volumes
> with NTFS formatting that haven't had issues, but both xfs volumes
> have had trouble. When I run xfs_repair on a drive that hangs and
> crashes, I get a segfault.
> 
> I'm running Fedora 33 with Linux 5.14.11-100.fc33.x86_64. My machine
> has 1.5TB of RAM. I seem to reach the segmentation fault on what looks
> like recursive reconstruction of ".." directory inodes:
> 
> I'm including the run log as of Phase 6 (which is where the failure
> happens) inline below:
> 
> Thanks,
> Gabe

Can you try creating an xfs_metadump of the filesystem, and see if the
segfault is reproducible?

Then, if you are willing to share it (in private) we could do some
debugging.

To create the xfs_metadump:

# xfs_metadump /dev/$WHATEVER metadump.meta

To see if the image reproduces the problem,

# xfs_mdrestore metadump.meta metadump.img

(Note that both metadump.meta and metadump.img are metadata-only, contain
no file data, and will take FAR less than 28T of disk space.)

If so, and if you're OK with sharing the obfuscated metadump (it contains
no file data, but may contain unobfuscated short file names, xattrs etc),
then compress it and send it my way, offline.

Thanks,
-Eric
