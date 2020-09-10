Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470FAC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 20:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB2820829
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 20:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgIJUon (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 16:44:43 -0400
Received: from sandeen.net ([63.231.237.45]:53392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIJUom (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Sep 2020 16:44:42 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DD2D1EF1;
        Thu, 10 Sep 2020 15:44:05 -0500 (CDT)
Subject: Re: xfs_info: no info about XFS version?
To:     info@linuxadmin.pl, linux-xfs@vger.kernel.org
References: <01aa416f70d0d780b337fb77756a88a8@linuxadmin.pl>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55432d32-83ed-fccd-52ff-70b36a75fd07@sandeen.net>
Date:   Thu, 10 Sep 2020 15:44:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <01aa416f70d0d780b337fb77756a88a8@linuxadmin.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/10/20 3:26 PM, LinuxAdmin.pl - administracja serwerami Linux wrote:
> 
> Hello,
> 
> why there is no info about XFS version on xfs_info?

Yeah, this is confusing.

TBH I think "V4" vs "V5" is a secret developer handshake.  Admins know
this as "not-crc-enabled" vs "crc-enabled"

Below is a V4 filesystem, due to crc=0

-Eric
 
> # LANG=en_US.UTF-8 xfs_info /dev/sdb1
> meta-data=/dev/sdb1              isize=256    agcount=4, agsize=6553408 blks
>          =                       sectsz=512   attr=2, projid32bit=0
>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=26213632, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=0
> log      =internal log           bsize=4096   blocks=12799, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
