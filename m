Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:40027 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbeCOSXK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 14:23:10 -0400
Received: by mail-wr0-f194.google.com with SMTP id s12so6745821wre.7
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 11:23:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180315181120.GA4865@magnolia>
References: <20180315174745.34308-1-jtulak@redhat.com> <20180315175026.34779-1-jtulak@redhat.com>
 <20180315181120.GA4865@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 15 Mar 2018 19:22:48 +0100
Message-ID: <CACj3i71KAB0NdoNPhhXbn_tOzwW1uWpFTVzQH3vdpobNFa8a_w@mail.gmail.com>
Subject: Re: [PATCH 2/2] fsck.xfs: allow forced repairs using xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 15, 2018 at 7:11 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>> +
>> +if $FORCE; then
>> +     if [ -f /sbin/xfs_repair ]; then
>> +             BIN="/sbin/xfs_repair"
>> +     elif [ -f /usr/sbin/xfs_repair ]; then
>> +             BIN="/usr/sbin/xfs_repair"
>
> Can we just run xfs_repair and assume it's in the PATH?

Because not every distro has bundled xfs_repair into initramfs, I
would rather expect that they can forget to add it after this patch
than have an unexpected failure.

Other points are ok, I'm sending the patches...

Thanks,
Jan
