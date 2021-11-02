Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32BCC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 14:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A05B61053
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 14:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhKBO13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:27:29 -0400
Received: from sandeen.net ([63.231.237.45]:35620 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhKBO12 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Nov 2021 10:27:28 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B93147BBE;
        Tue,  2 Nov 2021 09:23:16 -0500 (CDT)
Message-ID: <837070cd-82bf-547e-4d60-cd8dcf55aedb@sandeen.net>
Date:   Tue, 2 Nov 2021 09:24:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: xfsrestore'ing from file backups don't restore...why not?
Content-Language: en-US
To:     L A Walsh <xfs@tlinx.org>, Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <617721E0.5000009@tlinx.org>
 <20211026004814.GA5111@dread.disaster.area> <617F0A6D.6060506@tlinx.org>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <617F0A6D.6060506@tlinx.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 10/31/21 4:28 PM, L A Walsh wrote:
> When looking at a dump of /home (but not on other partitions that I've noticed, I see (stopping listing on problem line)
> 
> XFSDUMP_OPTIONS=-J #(set externally , not usually)
> 
>> ./dump1fs#160(Xfsdump)> xfsdump -b 268435456 -l 8 -L home -J - /home
> xfsdump: using file dump (drive_simple) strategy
> xfsdump: version 3.1.8 (dump format 3.0)
> xfsdump: level 8 incremental dump of Ishtar:/home based on level 6 dump begun Fri Oct 29 04:30:13 2021
> xfsdump: dump date: Sun Oct 31 14:20:37 2021
> xfsdump: session id: 249233a0-a642-42a0-ae02-ed53012f3fa4
> xfsdump: session label: "home"
> xfsdump: NOTE: root ino 192 differs from mount dir ino 256, bind mount?


Linda, if I gave you a build of xfsdump with a workaround for this problem,
would you be willing to test it?

Thanks,
-Eric

> Of note, most things were placed in orphanage under
> 256.0
> 
> df shows:
> df /home
> Filesystem        Size  Used Avail Use% Mounted on
> /dev/Space/Home2  2.0T  1.5T  570G  73% /home
> 
> (Became months ago as I made new partition of 2T to replace
> old partition of 1.5T, after which I did another level-0 backup.
> 
> 
> 
