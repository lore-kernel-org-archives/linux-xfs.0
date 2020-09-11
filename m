Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B84C2BC11
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 04:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1342F2080A
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 04:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgIKEON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 00:14:13 -0400
Received: from dedicated-afm47.rev.nazwa.pl ([77.55.142.47]:34817 "EHLO
        dedicated-afm47.rev.nazwa.pl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgIKEOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 00:14:11 -0400
X-Virus-Scanned: by amavisd-new using ClamAV (19)
Received: from poczta.sysgroup.pl (dedicated-aib150.rev.nazwa.pl [77.55.209.150])
        by server192927.nazwa.pl (Postfix) with ESMTP id 1CCAB1C6051;
        Fri, 11 Sep 2020 06:14:09 +0200 (CEST)
MIME-Version: 1.0
Date:   Fri, 11 Sep 2020 06:14:09 +0200
From:   "LinuxAdmin.pl - administracja serwerami Linux" <info@linuxadmin.pl>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs_info: no info about XFS version?
Reply-To: info@linuxadmin.pl
In-Reply-To: <55432d32-83ed-fccd-52ff-70b36a75fd07@sandeen.net>
References: <01aa416f70d0d780b337fb77756a88a8@linuxadmin.pl>
 <55432d32-83ed-fccd-52ff-70b36a75fd07@sandeen.net>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <57839a674d8b54baafa40d2b002e19b5@linuxadmin.pl>
X-Sender: info@linuxadmin.pl
Organization: LinuxAdmin.pl - administracja serwerami Linux
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

W dniu 2020-09-10 22:44, Eric Sandeen napisał(a):
> On 9/10/20 3:26 PM, LinuxAdmin.pl - administracja serwerami Linux 
> wrote:
>> 
>> Hello,
>> 
>> why there is no info about XFS version on xfs_info?
> 
> Yeah, this is confusing.
> 
> TBH I think "V4" vs "V5" is a secret developer handshake.  Admins know
> this as "not-crc-enabled" vs "crc-enabled"
> 
> Below is a V4 filesystem, due to crc=0

That's the point! How you will be determining the version number in V7? 
crc=3 xyz=0 abc=1?
I know that is V4 (migration to V5 already planned!) but thinking the 
human way - it will be nice to have a simple info of used version :)

> -Eric
> 
>> # LANG=en_US.UTF-8 xfs_info /dev/sdb1
>> meta-data=/dev/sdb1              isize=256    agcount=4, 
>> agsize=6553408 blks
>>          =                       sectsz=512   attr=2, projid32bit=0
>>          =                       crc=0        finobt=0, sparse=0, 
>> rmapbt=0
>>          =                       reflink=0
>> data     =                       bsize=4096   blocks=26213632, 
>> imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=0
>> log      =internal log           bsize=4096   blocks=12799, version=2
>>          =                       sectsz=512   sunit=0 blks, 
>> lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> 

-- 
LinuxAdmin.pl - administracja serwerami Linux
Wojciech Błaszkowski
+48 600 197 207
