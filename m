Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB70CA9EB6
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 09:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22E6121929
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 09:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390165AbfJWJpq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 05:45:46 -0400
Received: from mr014msb.fastweb.it ([85.18.95.103]:39331 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732648AbfJWJpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 05:45:46 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Oct 2019 05:45:44 EDT
Received-SPF: pass (mr014msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr014msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrkeelgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhtefuvfghgfeupdcuqfgfvfenuceurghilhhouhhtmecufedttdenucenucfjughrpefvhffuohfkffgfgggtgfesthejredttdefjeenucfhrhhomhepifhiohhnrghtrghnucffrghnthhiuceoghdruggrnhhtihesrghsshihohhmrgdrihhtqeenucffohhmrghinheprghsshihohhmrgdrihhtpdhkvghrnhgvlhdrohhrghenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr014msb.fastweb.it (5.8.208)
        id 5DA0478900F714F4 for linux-xfs@vger.kernel.org; Wed, 23 Oct 2019 11:40:34 +0200
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id DC43F253481;
        Wed, 23 Oct 2019 11:40:33 +0200 (CEST)
To:     linux-xfs@vger.kernel.org
Cc:     g.danti@assyoma.it
From:   Gionatan Danti <g.danti@assyoma.it>
Subject: Question about logbsize default value
Organization: Assyoma s.r.l.
Message-ID: <00242d70-1d8e-231d-7ba0-1594412714ad@assyoma.it>
Date:   Wed, 23 Oct 2019 11:40:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi list,
on both the mount man page and the doc here [1] I read that when the 
underlying RAID stripe unit is bigger than 256k, the log buffer size 
(logbsize) will be set at 32k by default.

As in my tests (on top of software RAID 10 with 512k chunks) it seems 
that using logbsize=256k helps in metadata-heavy workload, I wonder why 
the default is to set such a small log buffer size.

For example, given the following array:

md126 : active raid10 sda1[3] sdb1[1] sdc1[0] sdd1[2]
       268439552 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 1/3 pages [4KB], 65536KB chunk

running "fs_mark  -n  1000000  -k  -S  0  -D  1000  -N  1000  -s  16384 
-d  /mnt/xfs/" shows the following results:

32k  logbsize (default, due to 512k chunk size): 3027.4 files/sec
256k logbsize (manually specified during mount): 4768.4 files/sec

I would naively think that logbsize=256k would be a better default. Am I 
missing something?

[1] 
https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc#n322

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
