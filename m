Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58B4C43334
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jun 2022 11:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242939AbiFGLcZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 07:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242928AbiFGLcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 07:32:24 -0400
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jun 2022 04:32:23 PDT
Received: from libero.it (smtp-17-i2.italiaonline.it [213.209.12.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519AF1AF34
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 04:32:23 -0700 (PDT)
Received: from oxapps-10-060.iol.local ([10.101.8.70])
        by smtp-17.iol.local with ESMTPA
        id yXQencnghikHEyXQentrvQ; Tue, 07 Jun 2022 13:31:20 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1654601480; bh=lfrlmvKDG9zQUc79GcjYebHi9bAlFvvEmXrbldp7rjY=;
        h=From;
        b=JvTifrWdMmPYJhtJYNfc5KYSiIvzqvA8v62KcKsKyvibey0yw1LGPOwD5PFrehNdJ
         qQ2brFklEkqz/3o0574syaLUYpKzlVL4bdu1XssBbTwVCQFhVJrBgkcs1G3xqK2LyR
         3hzx8ugENe5yNXJx2ZJIq1wYo85WweMCQ/s2PSYOMe5o1RZJvDGS5sfd63dmh8ehUk
         70eDUgh0aby8ThEZPdCIU5CeaP0MA71UQ/QPqFY0GL0KH1RiXlLVz+6lenwimZFcB6
         wXZQ0GGAW9JgsmGEwsZManm/g23/wu8PwvKjQhQK7YaZyN5T/Q7SkHnVLFH14GK+b/
         F0oQY4KPvlPQw==
X-CNFS-Analysis: v=2.4 cv=Y7A9DjSN c=1 sm=1 tr=0 ts=629f3708 cx=a_exe
 a=N6tDZBjKOqonna1m1e4Nkw==:117 a=bxMsQdpLyWUA:10 a=IkcTkHD0fZMA:10
 a=lHmnQpCou4cA:10 a=7p3LcMUiKyzAc3Ul390A:9 a=QEXdDO2ut3YA:10
Date:   Tue, 7 Jun 2022 13:31:20 +0200 (CEST)
From:   Marco Berizzi <pupilla@libero.it>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <1234293069.1387822.1654601480847@mail1.libero.it>
Subject: lilo booting problem
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev43
X-Originating-IP: 194.4.230.203
X-Originating-Client: open-xchange-appsuite
x-libjamsun: DjRaZfjjaSbwdosrxIMA5bW/30t6u2rW
x-libjamv: QuX34rCgKzI=
X-CMAE-Envelope: MS4xfAJ9HQCdke09fNVFUo5VwnunboYaFqfPudoYlojMCmrsL+ul+VJyNjsNZgCo3/Fqjpgpwqr4Rj50rhhqKcLvoe5NIwXBnlpiGHu4NOuM+PHvd9KLoDL1
 b01EfvrzPUASVl66QkI+1NvNr9D/aE70hrPX5DBf/AwhwX0ObXqnwHy0VboOnjh7LukvK9/2/8EFdVUVHFCgX/2wHO+xAnITGw4=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello everyone,

I have recently installed Slackware Linux 15 distribution
with xfs file system. I noticed that the system could not
start booting. The loader is Lilo and is installed on the
MBR: I am aware that this software is no longer maintained.

I tested vanilla kernels 5.17.13 and 5.18.1 (64 bit).

I re-created the filesystem with the reflink=0 option and
now, the system performs the boot successfully.

I kindly wanted to know if this behavior is the expected
one.

Thanks,
Marco
