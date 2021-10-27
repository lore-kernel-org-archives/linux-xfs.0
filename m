Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76915C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 21:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46C6160EBD
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 21:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbhJ0VJe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Oct 2021 17:09:34 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:58284 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbhJ0VJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Oct 2021 17:09:33 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 4Hfh8V5bXgz9vLGt
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 21:07:06 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NLOYmxEtGwXM for <linux-xfs@vger.kernel.org>;
        Wed, 27 Oct 2021 16:07:06 -0500 (CDT)
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 4Hfh8T68Wkz9vLGs
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 16:07:05 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p7.oit.umn.edu 4Hfh8T68Wkz9vLGs
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p7.oit.umn.edu 4Hfh8T68Wkz9vLGs
Received: by mail-lj1-f200.google.com with SMTP id b8-20020a05651c028800b00211cc108922so877391ljo.15
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 14:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=SFuvUAlJiFIDyxNJRmyqiAjt+trhHyN4ffsd25cKQa4=;
        b=Y2Hh5LtJx7SpxMLFDRMsmmJyrgwzF5yUNAlmIqojoRqDgbWusunHOAnbdheErMaE/V
         3xd1HVEwkY8mh7fZgowma8jlzNFrvki9DlmrS0jEZZTaZG9OFFUxvDlHnsOALtp9DrY1
         puKHb5KMzDA+P+NDi5FaMIOpwkOQ6ISn7UXny+ZFCzMT1HoP4M2kSZl5I0RNf1Qpmj1i
         WrBPfyK+HaSrbFWiuITYUAqp28FozNsM01dVgDoNOm+WE1YId2anGLw7Jq1Cjdqfkvvw
         CzDEqqPznCoHAMljMNcX+npA+xmROcTl2za+c011ehBJeUJqK35cIqYQkDtOX5jnNUVS
         h6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SFuvUAlJiFIDyxNJRmyqiAjt+trhHyN4ffsd25cKQa4=;
        b=XD0KQpVbn52HuxYRLAfFTFu2XINPAxOPSqAS4kDYmjdjtlByd9FVtl4NX1jaku+J2T
         Zyt+NQqJMKSRdBAyGSH94bE1cEbnHBh8TFK/1Nc7SgQalLoELMJFqeW9MqJxYlrgbgit
         Roxu9a7WXB7eFefGzetsy6Axi40x5JdC6NHeyFfQMcGwx0tJM+3HLGvp0BbdvdrkD0JV
         ZJaWIX2ICi/zHsuSUrlUL1SXYpkYYE8kmUqo06O8Cxjux6qmNH3CJZuvHrc6afVzHmUr
         BxlWzipq7ZMMQ3HAYnvKGMqD4KEfnXsLkj4z9sKUILILXHYDnPjRCUySe/geDbPg/AR5
         yr/g==
X-Gm-Message-State: AOAM533QSgheZhH7HZYi+Eq2k7V3d7pk1X6WD/LMXn6FO1l0ikQbKi+n
        +HLDCNqJG2p1tMQsvLmOyzr2gzLlvBPd7Mbmiod7Ei1xLFrTRz1MGk4Zf3zXbfsTlZD/sAimxOf
        rL3c0S+Mv3WebdbLBJA2ynbpZeufjdmAiAUWNepmn
X-Received: by 2002:a2e:b004:: with SMTP id y4mr284957ljk.298.1635368823703;
        Wed, 27 Oct 2021 14:07:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeLlWVRl+qTfPy39e8RdFMyp2WxSe0OrIes5+TBlm2zhBZDULwndDTisgRQinzmzFqDgnJQiH31mMkIMED8hw=
X-Received: by 2002:a2e:b004:: with SMTP id y4mr284871ljk.298.1635368822810;
 Wed, 27 Oct 2021 14:07:02 -0700 (PDT)
MIME-Version: 1.0
From:   Gabe Al-Ghalith <algh0022@umn.edu>
Date:   Wed, 27 Oct 2021 17:06:37 -0400
Message-ID: <CAPqFctLu3L=qxf+Agwks5F+wTCxgRKgHqrQqokRPi62744KLHQ@mail.gmail.com>
Subject: Segmentation fault on 28tb usb3 volume with xfs_repair
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm running a 28TB volume on USB3 with xfs. I have many other volumes
with NTFS formatting that haven't had issues, but both xfs volumes
have had trouble. When I run xfs_repair on a drive that hangs and
crashes, I get a segfault.

I'm running Fedora 33 with Linux 5.14.11-100.fc33.x86_64. My machine
has 1.5TB of RAM. I seem to reach the segmentation fault on what looks
like recursive reconstruction of ".." directory inodes:

I'm including the run log as of Phase 6 (which is where the failure
happens) inline below:

Thanks,
Gabe

LOG:
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 128 (no data entry): rebuilding
rebuilding directory inode 128
bad hash table for directory inode 132 (no data entry): rebuilding
rebuilding directory inode 132
entry ".." in directory inode 19327353221 points to non-existent inode
9608134910
rebuilding directory inode 19327353221
entry ".." in directory inode 19327395629 points to non-existent inode
21474921552
bad hash table for directory inode 19327395629 (no data entry): rebuilding
rebuilding directory inode 19327395629
entry ".." in directory inode 19327395631 points to non-existent inode
21474921552
bad hash table for directory inode 19327395631 (no data entry): rebuilding
rebuilding directory inode 19327395631
entry ".." in directory inode 19327398016 points to non-existent inode
21474923217
rebuilding directory inode 19327398016
entry ".." in directory inode 19338804161 points to non-existent inode
16996261485
bad hash table for directory inode 19338804161 (no data entry): rebuilding
rebuilding directory inode 19338804161
entry ".." in directory inode 19338804165 points to non-existent inode
17628034011
bad hash table for directory inode 19338804165 (no data entry): rebuilding
rebuilding directory inode 19338804165
entry ".." in directory inode 19338804295 points to non-existent inode
13019907584
bad hash table for directory inode 19338804295 (no data entry): rebuilding
rebuilding directory inode 19338804295
entry ".." in directory inode 19338804374 points to non-existent inode
17233597888
bad hash table for directory inode 19338804374 (no data entry): rebuilding
rebuilding directory inode 19338804374
entry ".." in directory inode 19338804434 points to non-existent inode
38446506497
bad hash table for directory inode 19338804434 (no data entry): rebuilding
rebuilding directory inode 19338804434
entry ".." in directory inode 19338804459 points to non-existent inode
38446506497
bad hash table for directory inode 19338804459 (no data entry): rebuilding
rebuilding directory inode 19338804459
entry ".." in directory inode 19338804507 points to non-existent inode
49498873213
bad hash table for directory inode 19338804507 (no data entry): rebuilding
rebuilding directory inode 19338804507
entry ".." in directory inode 19338804578 points to non-existent inode
17642869487
bad hash table for directory inode 19338804578 (no data entry): rebuilding
rebuilding directory inode 19338804578
entry ".." in directory inode 19338804639 points to non-existent inode
9668533373
bad hash table for directory inode 19338804639 (no data entry): rebuilding
rebuilding directory inode 19338804639
entry ".." in directory inode 19338806167 points to non-existent inode 198300824
rebuilding directory inode 19338806167
entry ".." in directory inode 19338811726 points to non-existent inode
6574684212
bad hash table for directory inode 19338811726 (no data entry): rebuilding
rebuilding directory inode 19338811726
entry ".." in directory inode 19338811752 points to non-existent inode
6574684212
bad hash table for directory inode 19338811752 (no data entry): rebuilding
rebuilding directory inode 19338811752
entry ".." in directory inode 19338811760 points to non-existent inode
6574684212
bad hash table for directory inode 19338811760 (no data entry): rebuilding
rebuilding directory inode 19338811760
entry ".." in directory inode 19338811766 points to non-existent inode
6574684212
bad hash table for directory inode 19338811766 (no data entry): rebuilding
rebuilding directory inode 19338811766
entry ".." in directory inode 19338811767 points to non-existent inode
6574684212
bad hash table for directory inode 19338811767 (no data entry): rebuilding
rebuilding directory inode 19338811767
entry ".." in directory inode 19338811769 points to non-existent inode
6574684212
bad hash table for directory inode 19338811769 (no data entry): rebuilding
rebuilding directory inode 19338811769
entry ".." in directory inode 19338811786 points to non-existent inode
6574684212
bad hash table for directory inode 19338811786 (no data entry): rebuilding
rebuilding directory inode 19338811786
entry ".." in directory inode 19338811787 points to non-existent inode
6574684212
bad hash table for directory inode 19338811787 (no data entry): rebuilding
rebuilding directory inode 19338811787
entry ".." in directory inode 19338811789 points to non-existent inode
6574684212
bad hash table for directory inode 19338811789 (no data entry): rebuilding
rebuilding directory inode 19338811789
entry ".." in directory inode 19338811803 points to non-existent inode
6574684212
bad hash table for directory inode 19338811803 (no data entry): rebuilding
rebuilding directory inode 19338811803
entry ".." in directory inode 19338811805 points to non-existent inode
6574684212
bad hash table for directory inode 19338811805 (no data entry): rebuilding
rebuilding directory inode 19338811805
entry ".." in directory inode 19338811857 points to non-existent inode
6574684212
bad hash table for directory inode 19338811857 (no data entry): rebuilding
rebuilding directory inode 19338811857
entry ".." in directory inode 19338811901 points to non-existent inode
6574684212
bad hash table for directory inode 19338811901 (no data entry): rebuilding
rebuilding directory inode 19338811901
entry ".." in directory inode 19338814388 points to non-existent inode
49545992393
bad hash table for directory inode 19338814388 (no data entry): rebuilding
rebuilding directory inode 19338814388
entry ".." in directory inode 19338814393 points to non-existent inode
49545992393
bad hash table for directory inode 19338814393 (no data entry): rebuilding
rebuilding directory inode 19338814393
entry ".." in directory inode 19338814395 points to non-existent inode
49545992393
bad hash table for directory inode 19338814395 (no data entry): rebuilding
rebuilding directory inode 19338814395
entry ".." in directory inode 19338814396 points to non-existent inode
49545992393
bad hash table for directory inode 19338814396 (no data entry): rebuilding
rebuilding directory inode 19338814396
entry ".." in directory inode 19338814402 points to non-existent inode
49545992393
bad hash table for directory inode 19338814402 (no data entry): rebuilding
rebuilding directory inode 19338814402
entry ".." in directory inode 19338814412 points to non-existent inode
49545992393
bad hash table for directory inode 19338814412 (no data entry): rebuilding
rebuilding directory inode 19338814412
entry ".." in directory inode 19338814424 points to non-existent inode
49545992393
bad hash table for directory inode 19338814424 (no data entry): rebuilding
rebuilding directory inode 19338814424
entry ".." in directory inode 19338814430 points to non-existent inode
49545992393
bad hash table for directory inode 19338814430 (no data entry): rebuilding
rebuilding directory inode 19338814430
entry ".." in directory inode 19338814432 points to non-existent inode
49545992393
bad hash table for directory inode 19338814432 (no data entry): rebuilding
rebuilding directory inode 19338814432
entry ".." in directory inode 19338814434 points to non-existent inode
49545992393
bad hash table for directory inode 19338814434 (no data entry): rebuilding
rebuilding directory inode 19338814434
entry ".." in directory inode 19338814516 points to non-existent inode
49545992393
bad hash table for directory inode 19338814516 (no data entry): rebuilding
rebuilding directory inode 19338814516
entry ".." in directory inode 19338814562 points to non-existent inode
49545992393
bad hash table for directory inode 19338814562 (no data entry): rebuilding
rebuilding directory inode 19338814562
entry ".." in directory inode 19338814571 points to non-existent inode
49545992393
bad hash table for directory inode 19338814571 (no data entry): rebuilding
rebuilding directory inode 19338814571
entry ".." in directory inode 19338814583 points to non-existent inode
49545992393
bad hash table for directory inode 19338814583 (no data entry): rebuilding
rebuilding directory inode 19338814583
entry ".." in directory inode 19338814644 points to non-existent inode
49545992393
bad hash table for directory inode 19338814644 (no data entry): rebuilding
rebuilding directory inode 19338814644
entry ".." in directory inode 19338814651 points to non-existent inode
49545992393
bad hash table for directory inode 19338814651 (no data entry): rebuilding
rebuilding directory inode 19338814651
entry ".." in directory inode 19338814658 points to non-existent inode
49545992393
bad hash table for directory inode 19338814658 (no data entry): rebuilding
rebuilding directory inode 19338814658
entry ".." in directory inode 19338814720 points to non-existent inode
49545992393
bad hash table for directory inode 19338814720 (no data entry): rebuilding
rebuilding directory inode 19338814720
entry ".." in directory inode 19338814737 points to non-existent inode
49545992393
bad hash table for directory inode 19338814737 (no data entry): rebuilding
rebuilding directory inode 19338814737
entry ".." in directory inode 19338816421 points to non-existent inode
28017346160
rebuilding directory inode 19338816421
rebuilding directory inode 19338821502
entry ".." in directory inode 19338846901 points to non-existent inode
36494532848
bad hash table for directory inode 19338846901 (no data entry): rebuilding
rebuilding directory inode 19338846901
entry ".." in directory inode 19338846905 points to non-existent inode
36494532848
bad hash table for directory inode 19338846905 (no data entry): rebuilding
rebuilding directory inode 19338846905
entry ".." in directory inode 19338846909 points to non-existent inode
36494532848
bad hash table for directory inode 19338846909 (no data entry): rebuilding
rebuilding directory inode 19338846909
entry ".." in directory inode 19338846910 points to non-existent inode
36494532848
bad hash table for directory inode 19338846910 (no data entry): rebuilding
rebuilding directory inode 19338846910
entry ".." in directory inode 19338846916 points to non-existent inode
36494532848
bad hash table for directory inode 19338846916 (no data entry): rebuilding
rebuilding directory inode 19338846916
entry ".." in directory inode 19338846961 points to non-existent inode
36494532848
bad hash table for directory inode 19338846961 (no data entry): rebuilding
rebuilding directory inode 19338846961
entry ".." in directory inode 19338846998 points to non-existent inode
36494532848
bad hash table for directory inode 19338846998 (no data entry): rebuilding
rebuilding directory inode 19338846998
entry ".." in directory inode 19338847101 points to non-existent inode
36494532848
bad hash table for directory inode 19338847101 (no data entry): rebuilding
rebuilding directory inode 19338847101
entry ".." in directory inode 19338847116 points to non-existent inode
36494532848
bad hash table for directory inode 19338847116 (no data entry): rebuilding
rebuilding directory inode 19338847116
entry ".." in directory inode 19338847121 points to non-existent inode
36494532848
bad hash table for directory inode 19338847121 (no data entry): rebuilding
rebuilding directory inode 19338847121
entry ".." in directory inode 19338847125 points to non-existent inode
36494532848
bad hash table for directory inode 19338847125 (no data entry): rebuilding
rebuilding directory inode 19338847125
entry ".." in directory inode 19338847130 points to non-existent inode
36494532848
bad hash table for directory inode 19338847130 (no data entry): rebuilding
rebuilding directory inode 19338847130
entry ".." in directory inode 19338847352 points to non-existent inode
36494532848
bad hash table for directory inode 19338847352 (no data entry): rebuilding
rebuilding directory inode 19338847352
entry ".." in directory inode 19338847550 points to non-existent inode
36494532848
bad hash table for directory inode 19338847550 (no data entry): rebuilding
rebuilding directory inode 19338847550
entry ".." in directory inode 19338847597 points to non-existent inode
36494532848
bad hash table for directory inode 19338847597 (no data entry): rebuilding
rebuilding directory inode 19338847597
entry ".." in directory inode 19338847700 points to non-existent inode
36494532848
bad hash table for directory inode 19338847700 (no data entry): rebuilding
rebuilding directory inode 19338847700
entry ".." in directory inode 19338847884 points to non-existent inode
36494532848
bad hash table for directory inode 19338847884 (no data entry): rebuilding
rebuilding directory inode 19338847884
entry ".." in directory inode 19338847911 points to non-existent inode
36494532848
bad hash table for directory inode 19338847911 (no data entry): rebuilding
rebuilding directory inode 19338847911
entry ".." in directory inode 19338847925 points to non-existent inode
36494532848
bad hash table for directory inode 19338847925 (no data entry): rebuilding
rebuilding directory inode 19338847925
entry ".." in directory inode 19338847941 points to non-existent inode
36494532848
bad hash table for directory inode 19338847941 (no data entry): rebuilding
rebuilding directory inode 19338847941
entry ".." in directory inode 19338848075 points to non-existent inode
36494532848
bad hash table for directory inode 19338848075 (no data entry): rebuilding
rebuilding directory inode 19338848075
entry ".." in directory inode 19338848274 points to non-existent inode
36494532848
bad hash table for directory inode 19338848274 (no data entry): rebuilding
rebuilding directory inode 19338848274
entry ".." in directory inode 19338848302 points to non-existent inode
36494532848
bad hash table for directory inode 19338848302 (no data entry): rebuilding
rebuilding directory inode 19338848302
entry ".." in directory inode 19338848310 points to non-existent inode
36494532848
bad hash table for directory inode 19338848310 (no data entry): rebuilding
rebuilding directory inode 19338848310
entry ".." in directory inode 19338848353 points to non-existent inode
36494532848
bad hash table for directory inode 19338848353 (no data entry): rebuilding
rebuilding directory inode 19338848353
entry ".." in directory inode 19338848513 points to non-existent inode
36494532848
bad hash table for directory inode 19338848513 (no data entry): rebuilding
rebuilding directory inode 19338848513
entry ".." in directory inode 19338848530 points to non-existent inode
36494532848
bad hash table for directory inode 19338848530 (no data entry): rebuilding
rebuilding directory inode 19338848530
entry ".." in directory inode 19338848553 points to non-existent inode
36494532848
bad hash table for directory inode 19338848553 (no data entry): rebuilding
rebuilding directory inode 19338848553
entry ".." in directory inode 19338848594 points to non-existent inode
36494532848
bad hash table for directory inode 19338848594 (no data entry): rebuilding
rebuilding directory inode 19338848594
entry ".." in directory inode 19338848613 points to non-existent inode
36494532848
bad hash table for directory inode 19338848613 (no data entry): rebuilding
rebuilding directory inode 19338848613
entry ".." in directory inode 19338848829 points to non-existent inode
36494532848
bad hash table for directory inode 19338848829 (no data entry): rebuilding
rebuilding directory inode 19338848829
entry ".." in directory inode 19338848861 points to non-existent inode
36494532848
bad hash table for directory inode 19338848861 (no data entry): rebuilding
rebuilding directory inode 19338848861
entry ".." in directory inode 19338848872 points to non-existent inode
36494532848
bad hash table for directory inode 19338848872 (no data entry): rebuilding
rebuilding directory inode 19338848872
entry ".." in directory inode 19338848982 points to non-existent inode
36494532848
bad hash table for directory inode 19338848982 (no data entry): rebuilding
rebuilding directory inode 19338848982
entry ".." in directory inode 19338848986 points to non-existent inode
36494532848
bad hash table for directory inode 19338848986 (no data entry): rebuilding
rebuilding directory inode 19338848986
entry ".." in directory inode 19338848991 points to non-existent inode
36494532848
bad hash table for directory inode 19338848991 (no data entry): rebuilding
rebuilding directory inode 19338848991
entry ".." in directory inode 19338849156 points to non-existent inode
36494532848
bad hash table for directory inode 19338849156 (no data entry): rebuilding
rebuilding directory inode 19338849156
entry ".." in directory inode 19338849173 points to non-existent inode
36494532848
bad hash table for directory inode 19338849173 (no data entry): rebuilding
rebuilding directory inode 19338849173
entry ".." in directory inode 19338849176 points to non-existent inode
36494532848
bad hash table for directory inode 19338849176 (no data entry): rebuilding
rebuilding directory inode 19338849176
entry ".." in directory inode 19338849290 points to non-existent inode
36494532848
bad hash table for directory inode 19338849290 (no data entry): rebuilding
rebuilding directory inode 19338849290
entry ".." in directory inode 19338849300 points to non-existent inode
36494532848
bad hash table for directory inode 19338849300 (no data entry): rebuilding
rebuilding directory inode 19338849300
entry ".." in directory inode 19338849325 points to non-existent inode
36494532848
bad hash table for directory inode 19338849325 (no data entry): rebuilding
rebuilding directory inode 19338849325
entry ".." in directory inode 19338849495 points to non-existent inode
36494532848
bad hash table for directory inode 19338849495 (no data entry): rebuilding
rebuilding directory inode 19338849495
entry ".." in directory inode 19338849569 points to non-existent inode
36494532848
bad hash table for directory inode 19338849569 (no data entry): rebuilding
rebuilding directory inode 19338849569
entry ".." in directory inode 19338849729 points to non-existent inode
36494532848
bad hash table for directory inode 19338849729 (no data entry): rebuilding
rebuilding directory inode 19338849729
entry ".." in directory inode 19338849731 points to non-existent inode
36494532848
bad hash table for directory inode 19338849731 (no data entry): rebuilding
rebuilding directory inode 19338849731
entry ".." in directory inode 19338849779 points to non-existent inode
36494532848
bad hash table for directory inode 19338849779 (no data entry): rebuilding
rebuilding directory inode 19338849779
entry ".." in directory inode 19338849903 points to non-existent inode
36494532848
bad hash table for directory inode 19338849903 (no data entry): rebuilding
rebuilding directory inode 19338849903
entry ".." in directory inode 19338849922 points to non-existent inode
36494532848
bad hash table for directory inode 19338849922 (no data entry): rebuilding
rebuilding directory inode 19338849922
entry ".." in directory inode 19338850163 points to non-existent inode
36494532848
bad hash table for directory inode 19338850163 (no data entry): rebuilding
rebuilding directory inode 19338850163
entry ".." in directory inode 19338850281 points to non-existent inode
36494532848
bad hash table for directory inode 19338850281 (no data entry): rebuilding
rebuilding directory inode 19338850281
entry ".." in directory inode 19338850286 points to non-existent inode
36494532848
bad hash table for directory inode 19338850286 (no data entry): rebuilding
rebuilding directory inode 19338850286
entry ".." in directory inode 19338850295 points to non-existent inode
36494532848
bad hash table for directory inode 19338850295 (no data entry): rebuilding
rebuilding directory inode 19338850295
entry ".." in directory inode 19338850333 points to non-existent inode
36494532848
bad hash table for directory inode 19338850333 (no data entry): rebuilding
rebuilding directory inode 19338850333
entry ".." in directory inode 19338850437 points to non-existent inode
36494532848
bad hash table for directory inode 19338850437 (no data entry): rebuilding
rebuilding directory inode 19338850437
entry ".." in directory inode 19338850441 points to non-existent inode
36494532848
bad hash table for directory inode 19338850441 (no data entry): rebuilding
rebuilding directory inode 19338850441
entry ".." in directory inode 19338850471 points to non-existent inode
36494532848
bad hash table for directory inode 19338850471 (no data entry): rebuilding
rebuilding directory inode 19338850471
entry ".." in directory inode 19338850517 points to non-existent inode
36494532848
bad hash table for directory inode 19338850517 (no data entry): rebuilding
rebuilding directory inode 19338850517
entry ".." in directory inode 19338850727 points to non-existent inode
36494532848
bad hash table for directory inode 19338850727 (no data entry): rebuilding
rebuilding directory inode 19338850727
entry ".." in directory inode 19338850752 points to non-existent inode
36494532848
bad hash table for directory inode 19338850752 (no data entry): rebuilding
rebuilding directory inode 19338850752
entry ".." in directory inode 19338850824 points to non-existent inode
36494532848
bad hash table for directory inode 19338850824 (no data entry): rebuilding
rebuilding directory inode 19338850824
entry ".." in directory inode 19338850884 points to non-existent inode
36494532848
bad hash table for directory inode 19338850884 (no data entry): rebuilding
rebuilding directory inode 19338850884
entry ".." in directory inode 19338851000 points to non-existent inode
36494532848
bad hash table for directory inode 19338851000 (no data entry): rebuilding
rebuilding directory inode 19338851000
entry ".." in directory inode 19338851085 points to non-existent inode
36494532848
bad hash table for directory inode 19338851085 (no data entry): rebuilding
rebuilding directory inode 19338851085
entry ".." in directory inode 19338851101 points to non-existent inode
36494532848
bad hash table for directory inode 19338851101 (no data entry): rebuilding
rebuilding directory inode 19338851101
entry ".." in directory inode 19338851131 points to non-existent inode
36494532848
bad hash table for directory inode 19338851131 (no data entry): rebuilding
rebuilding directory inode 19338851131
entry ".." in directory inode 19338851247 points to non-existent inode
36494532848
bad hash table for directory inode 19338851247 (no data entry): rebuilding
rebuilding directory inode 19338851247
entry ".." in directory inode 19338851427 points to non-existent inode
36494532848
bad hash table for directory inode 19338851427 (no data entry): rebuilding
rebuilding directory inode 19338851427
entry ".." in directory inode 19338851444 points to non-existent inode
36494532848
bad hash table for directory inode 19338851444 (no data entry): rebuilding
rebuilding directory inode 19338851444
entry ".." in directory inode 19338851769 points to non-existent inode
36494532848
bad hash table for directory inode 19338851769 (no data entry): rebuilding
rebuilding directory inode 19338851769
entry ".." in directory inode 19338851795 points to non-existent inode
36494532848
bad hash table for directory inode 19338851795 (no data entry): rebuilding
rebuilding directory inode 19338851795
entry ".." in directory inode 19338851952 points to non-existent inode
36494532848
bad hash table for directory inode 19338851952 (no data entry): rebuilding
rebuilding directory inode 19338851952
entry ".." in directory inode 19338851976 points to non-existent inode
36494532848
bad hash table for directory inode 19338851976 (no data entry): rebuilding
rebuilding directory inode 19338851976
entry ".." in directory inode 19338851982 points to non-existent inode
36494532848
bad hash table for directory inode 19338851982 (no data entry): rebuilding
rebuilding directory inode 19338851982
entry ".." in directory inode 19338851987 points to non-existent inode
36494532848
bad hash table for directory inode 19338851987 (no data entry): rebuilding
rebuilding directory inode 19338851987
entry ".." in directory inode 19338851988 points to non-existent inode
36494532848
bad hash table for directory inode 19338851988 (no data entry): rebuilding
rebuilding directory inode 19338851988
entry ".." in directory inode 19338852154 points to non-existent inode
36494532848
bad hash table for directory inode 19338852154 (no data entry): rebuilding
rebuilding directory inode 19338852154
entry ".." in directory inode 19338852155 points to non-existent inode
36494532848
bad hash table for directory inode 19338852155 (no data entry): rebuilding
rebuilding directory inode 19338852155
entry ".." in directory inode 19338852156 points to non-existent inode
36494532848
bad hash table for directory inode 19338852156 (no data entry): rebuilding
rebuilding directory inode 19338852156
entry ".." in directory inode 19338852175 points to non-existent inode
36494532848
bad hash table for directory inode 19338852175 (no data entry): rebuilding
rebuilding directory inode 19338852175
entry ".." in directory inode 19338852215 points to non-existent inode
36494532848
bad hash table for directory inode 19338852215 (no data entry): rebuilding
rebuilding directory inode 19338852215
entry ".." in directory inode 19338852222 points to non-existent inode
36494532848
bad hash table for directory inode 19338852222 (no data entry): rebuilding
rebuilding directory inode 19338852222
entry ".." in directory inode 19338852435 points to non-existent inode
36494532848
bad hash table for directory inode 19338852435 (no data entry): rebuilding
rebuilding directory inode 19338852435
entry ".." in directory inode 19338852539 points to non-existent inode
36494532848
bad hash table for directory inode 19338852539 (no data entry): rebuilding
rebuilding directory inode 19338852539
entry ".." in directory inode 19338852740 points to non-existent inode
36494532848
bad hash table for directory inode 19338852740 (no data entry): rebuilding
rebuilding directory inode 19338852740
entry ".." in directory inode 19338852768 points to non-existent inode
36494532848
bad hash table for directory inode 19338852768 (no data entry): rebuilding
rebuilding directory inode 19338852768
entry ".." in directory inode 19338852778 points to non-existent inode
36494532848
bad hash table for directory inode 19338852778 (no data entry): rebuilding
rebuilding directory inode 19338852778
entry ".." in directory inode 19338852896 points to non-existent inode
36494532848
bad hash table for directory inode 19338852896 (no data entry): rebuilding
rebuilding directory inode 19338852896
entry ".." in directory inode 19338852992 points to non-existent inode
36494532848
bad hash table for directory inode 19338852992 (no data entry): rebuilding
rebuilding directory inode 19338852992
entry ".." in directory inode 19338853048 points to non-existent inode
36494532848
bad hash table for directory inode 19338853048 (no data entry): rebuilding
rebuilding directory inode 19338853048
entry ".." in directory inode 19338853071 points to non-existent inode
36494532848
bad hash table for directory inode 19338853071 (no data entry): rebuilding
rebuilding directory inode 19338853071
entry ".." in directory inode 19338853083 points to non-existent inode
36494532848
bad hash table for directory inode 19338853083 (no data entry): rebuilding
rebuilding directory inode 19338853083
entry ".." in directory inode 19338853085 points to non-existent inode
36494532848
bad hash table for directory inode 19338853085 (no data entry): rebuilding
rebuilding directory inode 19338853085
entry ".." in directory inode 19338853192 points to non-existent inode
36494532848
bad hash table for directory inode 19338853192 (no data entry): rebuilding
rebuilding directory inode 19338853192
entry ".." in directory inode 19338853225 points to non-existent inode
36494532848
bad hash table for directory inode 19338853225 (no data entry): rebuilding
rebuilding directory inode 19338853225
entry ".." in directory inode 19338853306 points to non-existent inode
36494532848
bad hash table for directory inode 19338853306 (no data entry): rebuilding
rebuilding directory inode 19338853306
entry ".." in directory inode 19338853312 points to non-existent inode
36494532848
bad hash table for directory inode 19338853312 (no data entry): rebuilding
rebuilding directory inode 19338853312
entry ".." in directory inode 19338853319 points to non-existent inode
36494532848
bad hash table for directory inode 19338853319 (no data entry): rebuilding
rebuilding directory inode 19338853319
entry ".." in directory inode 19338853528 points to non-existent inode
36494532848
bad hash table for directory inode 19338853528 (no data entry): rebuilding
rebuilding directory inode 19338853528
entry ".." in directory inode 19338853533 points to non-existent inode
36494532848
bad hash table for directory inode 19338853533 (no data entry): rebuilding
rebuilding directory inode 19338853533
entry ".." in directory inode 19338853576 points to non-existent inode
36494532848
bad hash table for directory inode 19338853576 (no data entry): rebuilding
rebuilding directory inode 19338853576
entry ".." in directory inode 19338853582 points to non-existent inode
36494532848
bad hash table for directory inode 19338853582 (no data entry): rebuilding
rebuilding directory inode 19338853582
entry ".." in directory inode 19338853608 points to non-existent inode
36494532848
bad hash table for directory inode 19338853608 (no data entry): rebuilding
rebuilding directory inode 19338853608
entry ".." in directory inode 19338853652 points to non-existent inode
36494532848
bad hash table for directory inode 19338853652 (no data entry): rebuilding
rebuilding directory inode 19338853652
entry ".." in directory inode 19338853703 points to non-existent inode
36494532848
bad hash table for directory inode 19338853703 (no data entry): rebuilding
rebuilding directory inode 19338853703
entry ".." in directory inode 19338853712 points to non-existent inode
36494532848
bad hash table for directory inode 19338853712 (no data entry): rebuilding
rebuilding directory inode 19338853712
entry ".." in directory inode 19338853729 points to non-existent inode
36494532848
bad hash table for directory inode 19338853729 (no data entry): rebuilding
rebuilding directory inode 19338853729
entry ".." in directory inode 19338853785 points to non-existent inode
36494532848
bad hash table for directory inode 19338853785 (no data entry): rebuilding
rebuilding directory inode 19338853785
entry ".." in directory inode 19338853835 points to non-existent inode
36494532848
bad hash table for directory inode 19338853835 (no data entry): rebuilding
rebuilding directory inode 19338853835
entry ".." in directory inode 19338853872 points to non-existent inode
36494532848
bad hash table for directory inode 19338853872 (no data entry): rebuilding
rebuilding directory inode 19338853872
entry ".." in directory inode 19338853875 points to non-existent inode
36494532848
bad hash table for directory inode 19338853875 (no data entry): rebuilding
rebuilding directory inode 19338853875
entry ".." in directory inode 19338854011 points to non-existent inode
36494532848
bad hash table for directory inode 19338854011 (no data entry): rebuilding
rebuilding directory inode 19338854011
entry ".." in directory inode 19338854033 points to non-existent inode
36494532848
bad hash table for directory inode 19338854033 (no data entry): rebuilding
rebuilding directory inode 19338854033
entry ".." in directory inode 19338854066 points to non-existent inode
36494532848
bad hash table for directory inode 19338854066 (no data entry): rebuilding
rebuilding directory inode 19338854066
entry ".." in directory inode 19338854192 points to non-existent inode
36494532848
bad hash table for directory inode 19338854192 (no data entry): rebuilding
rebuilding directory inode 19338854192
entry ".." in directory inode 19338854222 points to non-existent inode
36494532848
bad hash table for directory inode 19338854222 (no data entry): rebuilding
rebuilding directory inode 19338854222
entry ".." in directory inode 19338854231 points to non-existent inode
36494532848
bad hash table for directory inode 19338854231 (no data entry): rebuilding
rebuilding directory inode 19338854231
entry ".." in directory inode 19338854475 points to non-existent inode
36494532848
bad hash table for directory inode 19338854475 (no data entry): rebuilding
rebuilding directory inode 19338854475
entry ".." in directory inode 19338854558 points to non-existent inode
36494532848
bad hash table for directory inode 19338854558 (no data entry): rebuilding
rebuilding directory inode 19338854558
entry ".." in directory inode 19338854583 points to non-existent inode
36494532848
bad hash table for directory inode 19338854583 (no data entry): rebuilding
rebuilding directory inode 19338854583
entry ".." in directory inode 19338854640 points to non-existent inode
36494532848
bad hash table for directory inode 19338854640 (no data entry): rebuilding
rebuilding directory inode 19338854640
entry ".." in directory inode 19338854655 points to non-existent inode
36494532848
bad hash table for directory inode 19338854655 (no data entry): rebuilding
rebuilding directory inode 19338854655
entry ".." in directory inode 19338854677 points to non-existent inode
36494532848
bad hash table for directory inode 19338854677 (no data entry): rebuilding
rebuilding directory inode 19338854677
entry ".." in directory inode 19338854876 points to non-existent inode
36494532848
bad hash table for directory inode 19338854876 (no data entry): rebuilding
rebuilding directory inode 19338854876
entry ".." in directory inode 19338854884 points to non-existent inode
36494532848
bad hash table for directory inode 19338854884 (no data entry): rebuilding
rebuilding directory inode 19338854884
entry ".." in directory inode 19338854908 points to non-existent inode
36494532848
bad hash table for directory inode 19338854908 (no data entry): rebuilding
rebuilding directory inode 19338854908
entry ".." in directory inode 19338854993 points to non-existent inode
36494532848
bad hash table for directory inode 19338854993 (no data entry): rebuilding
rebuilding directory inode 19338854993
entry ".." in directory inode 19338855004 points to non-existent inode
36494532848
bad hash table for directory inode 19338855004 (no data entry): rebuilding
rebuilding directory inode 19338855004
entry ".." in directory inode 19338855021 points to non-existent inode
36494532848
bad hash table for directory inode 19338855021 (no data entry): rebuilding
rebuilding directory inode 19338855021
entry ".." in directory inode 19338855156 points to non-existent inode
36494532848
bad hash table for directory inode 19338855156 (no data entry): rebuilding
rebuilding directory inode 19338855156
entry ".." in directory inode 19338855174 points to non-existent inode
36494532848
bad hash table for directory inode 19338855174 (no data entry): rebuilding
rebuilding directory inode 19338855174
entry ".." in directory inode 19338855199 points to non-existent inode
36494532848
bad hash table for directory inode 19338855199 (no data entry): rebuilding
rebuilding directory inode 19338855199
entry ".." in directory inode 19338855367 points to non-existent inode
36494532848
bad hash table for directory inode 19338855367 (no data entry): rebuilding
rebuilding directory inode 19338855367
entry ".." in directory inode 19338855371 points to non-existent inode
36494532848
bad hash table for directory inode 19338855371 (no data entry): rebuilding
rebuilding directory inode 19338855371
entry ".." in directory inode 19338855386 points to non-existent inode
36494532848
bad hash table for directory inode 19338855386 (no data entry): rebuilding
rebuilding directory inode 19338855386
entry ".." in directory inode 19338855510 points to non-existent inode
36494532848
bad hash table for directory inode 19338855510 (no data entry): rebuilding
rebuilding directory inode 19338855510
entry ".." in directory inode 19338855599 points to non-existent inode
36494532848
bad hash table for directory inode 19338855599 (no data entry): rebuilding
rebuilding directory inode 19338855599
entry ".." in directory inode 19338855626 points to non-existent inode
36494532848
bad hash table for directory inode 19338855626 (no data entry): rebuilding
rebuilding directory inode 19338855626
entry ".." in directory inode 19338855637 points to non-existent inode
36494532848
bad hash table for directory inode 19338855637 (no data entry): rebuilding
rebuilding directory inode 19338855637
entry ".." in directory inode 19338855749 points to non-existent inode
36494532848
bad hash table for directory inode 19338855749 (no data entry): rebuilding
rebuilding directory inode 19338855749
entry ".." in directory inode 19338855757 points to non-existent inode
36494532848
bad hash table for directory inode 19338855757 (no data entry): rebuilding
rebuilding directory inode 19338855757
entry ".." in directory inode 19338855763 points to non-existent inode
36494532848
bad hash table for directory inode 19338855763 (no data entry): rebuilding
rebuilding directory inode 19338855763
entry ".." in directory inode 19338855777 points to non-existent inode
36494532848
bad hash table for directory inode 19338855777 (no data entry): rebuilding
rebuilding directory inode 19338855777
entry ".." in directory inode 19338855799 points to non-existent inode
36494532848
bad hash table for directory inode 19338855799 (no data entry): rebuilding
rebuilding directory inode 19338855799
entry ".." in directory inode 19338855939 points to non-existent inode
36494532848
bad hash table for directory inode 19338855939 (no data entry): rebuilding
rebuilding directory inode 19338855939
entry ".." in directory inode 19338855948 points to non-existent inode
36494532848
bad hash table for directory inode 19338855948 (no data entry): rebuilding
rebuilding directory inode 19338855948
entry ".." in directory inode 19338855990 points to non-existent inode
36494532848
bad hash table for directory inode 19338855990 (no data entry): rebuilding
rebuilding directory inode 19338855990
entry ".." in directory inode 19338856007 points to non-existent inode
36494532848
bad hash table for directory inode 19338856007 (no data entry): rebuilding
rebuilding directory inode 19338856007
entry ".." in directory inode 19338856016 points to non-existent inode
36494532848
bad hash table for directory inode 19338856016 (no data entry): rebuilding
rebuilding directory inode 19338856016
entry ".." in directory inode 19338856024 points to non-existent inode
36494532848
bad hash table for directory inode 19338856024 (no data entry): rebuilding
rebuilding directory inode 19338856024
entry ".." in directory inode 19338856032 points to non-existent inode
36494532848
bad hash table for directory inode 19338856032 (no data entry): rebuilding
rebuilding directory inode 19338856032
entry ".." in directory inode 19338856168 points to non-existent inode
36494532848
bad hash table for directory inode 19338856168 (no data entry): rebuilding
rebuilding directory inode 19338856168
entry ".." in directory inode 19338856180 points to non-existent inode
36494532848
bad hash table for directory inode 19338856180 (no data entry): rebuilding
rebuilding directory inode 19338856180
entry ".." in directory inode 19338856272 points to non-existent inode
36494532848
bad hash table for directory inode 19338856272 (no data entry): rebuilding
rebuilding directory inode 19338856272
entry ".." in directory inode 19338856376 points to non-existent inode
36494532848
bad hash table for directory inode 19338856376 (no data entry): rebuilding
rebuilding directory inode 19338856376
entry ".." in directory inode 19338856393 points to non-existent inode
36494532848
bad hash table for directory inode 19338856393 (no data entry): rebuilding
rebuilding directory inode 19338856393
entry ".." in directory inode 19338856412 points to non-existent inode
36494532848
bad hash table for directory inode 19338856412 (no data entry): rebuilding
rebuilding directory inode 19338856412
entry ".." in directory inode 19338856528 points to non-existent inode
36494532848
bad hash table for directory inode 19338856528 (no data entry): rebuilding
rebuilding directory inode 19338856528
entry ".." in directory inode 19338856549 points to non-existent inode
36494532848
bad hash table for directory inode 19338856549 (no data entry): rebuilding
rebuilding directory inode 19338856549
entry ".." in directory inode 19338856677 points to non-existent inode
36494532848
bad hash table for directory inode 19338856677 (no data entry): rebuilding
rebuilding directory inode 19338856677
entry ".." in directory inode 19338856683 points to non-existent inode
36494532848
bad hash table for directory inode 19338856683 (no data entry): rebuilding
rebuilding directory inode 19338856683
entry ".." in directory inode 19338856686 points to non-existent inode
36494532848
bad hash table for directory inode 19338856686 (no data entry): rebuilding
rebuilding directory inode 19338856686
entry ".." in directory inode 19338856709 points to non-existent inode
36494532848
bad hash table for directory inode 19338856709 (no data entry): rebuilding
rebuilding directory inode 19338856709
entry ".." in directory inode 19338856790 points to non-existent inode
36494532848
bad hash table for directory inode 19338856790 (no data entry): rebuilding
rebuilding directory inode 19338856790
entry ".." in directory inode 19338856808 points to non-existent inode
36494532848
bad hash table for directory inode 19338856808 (no data entry): rebuilding
rebuilding directory inode 19338856808
entry ".." in directory inode 19338856813 points to non-existent inode
36494532848
bad hash table for directory inode 19338856813 (no data entry): rebuilding
rebuilding directory inode 19338856813
entry ".." in directory inode 19338856841 points to non-existent inode
36494532848
bad hash table for directory inode 19338856841 (no data entry): rebuilding
rebuilding directory inode 19338856841
entry ".." in directory inode 19338856870 points to non-existent inode
36494532848
bad hash table for directory inode 19338856870 (no data entry): rebuilding
rebuilding directory inode 19338856870
entry ".." in directory inode 19338856997 points to non-existent inode
36494532848
bad hash table for directory inode 19338856997 (no data entry): rebuilding
rebuilding directory inode 19338856997
entry ".." in directory inode 19338857003 points to non-existent inode
36494532848
bad hash table for directory inode 19338857003 (no data entry): rebuilding
rebuilding directory inode 19338857003
entry ".." in directory inode 19338857157 points to non-existent inode
36494532848
bad hash table for directory inode 19338857157 (no data entry): rebuilding
rebuilding directory inode 19338857157
entry ".." in directory inode 19338857176 points to non-existent inode
36494532848
bad hash table for directory inode 19338857176 (no data entry): rebuilding
rebuilding directory inode 19338857176
entry ".." in directory inode 19338857179 points to non-existent inode
36494532848
bad hash table for directory inode 19338857179 (no data entry): rebuilding
rebuilding directory inode 19338857179
entry ".." in directory inode 19338857267 points to non-existent inode
36494532848
bad hash table for directory inode 19338857267 (no data entry): rebuilding
rebuilding directory inode 19338857267
entry ".." in directory inode 19338857299 points to non-existent inode
36494532848
bad hash table for directory inode 19338857299 (no data entry): rebuilding
rebuilding directory inode 19338857299
entry ".." in directory inode 19338857305 points to non-existent inode
36494532848
bad hash table for directory inode 19338857305 (no data entry): rebuilding
rebuilding directory inode 19338857305
entry ".." in directory inode 19338857373 points to non-existent inode
36494532848
bad hash table for directory inode 19338857373 (no data entry): rebuilding
rebuilding directory inode 19338857373
entry ".." in directory inode 19338857376 points to non-existent inode
36494532848
bad hash table for directory inode 19338857376 (no data entry): rebuilding
rebuilding directory inode 19338857376
entry ".." in directory inode 19338857416 points to non-existent inode
36494532848
bad hash table for directory inode 19338857416 (no data entry): rebuilding
rebuilding directory inode 19338857416
entry ".." in directory inode 19338857549 points to non-existent inode
36494532848
bad hash table for directory inode 19338857549 (no data entry): rebuilding
rebuilding directory inode 19338857549
entry ".." in directory inode 19338857578 points to non-existent inode
36494532848
bad hash table for directory inode 19338857578 (no data entry): rebuilding
rebuilding directory inode 19338857578
entry ".." in directory inode 19338857579 points to non-existent inode
36494532848
bad hash table for directory inode 19338857579 (no data entry): rebuilding
rebuilding directory inode 19338857579
entry ".." in directory inode 19338857766 points to non-existent inode
36494532848
bad hash table for directory inode 19338857766 (no data entry): rebuilding
rebuilding directory inode 19338857766
entry ".." in directory inode 19338857920 points to non-existent inode
36494532848
bad hash table for directory inode 19338857920 (no data entry): rebuilding
rebuilding directory inode 19338857920
entry ".." in directory inode 19338857928 points to non-existent inode
36494532848
bad hash table for directory inode 19338857928 (no data entry): rebuilding
rebuilding directory inode 19338857928
entry ".." in directory inode 19338858004 points to non-existent inode
36494532848
bad hash table for directory inode 19338858004 (no data entry): rebuilding
rebuilding directory inode 19338858004
entry ".." in directory inode 19338858010 points to non-existent inode
36494532848
bad hash table for directory inode 19338858010 (no data entry): rebuilding
rebuilding directory inode 19338858010
entry ".." in directory inode 19338858033 points to non-existent inode
36494532848
bad hash table for directory inode 19338858033 (no data entry): rebuilding
rebuilding directory inode 19338858033
entry ".." in directory inode 19338858153 points to non-existent inode
36494532848
bad hash table for directory inode 19338858153 (no data entry): rebuilding
rebuilding directory inode 19338858153
entry ".." in directory inode 19338858159 points to non-existent inode
36494532848
bad hash table for directory inode 19338858159 (no data entry): rebuilding
rebuilding directory inode 19338858159
entry ".." in directory inode 19338858168 points to non-existent inode
36494532848
bad hash table for directory inode 19338858168 (no data entry): rebuilding
rebuilding directory inode 19338858168
entry ".." in directory inode 19338858354 points to non-existent inode
36494532848
bad hash table for directory inode 19338858354 (no data entry): rebuilding
rebuilding directory inode 19338858354
entry ".." in directory inode 19338858376 points to non-existent inode
36494532848
bad hash table for directory inode 19338858376 (no data entry): rebuilding
rebuilding directory inode 19338858376
entry ".." in directory inode 19338858385 points to non-existent inode
36494532848
bad hash table for directory inode 19338858385 (no data entry): rebuilding
rebuilding directory inode 19338858385
entry ".." in directory inode 19338858410 points to non-existent inode
36494532848
bad hash table for directory inode 19338858410 (no data entry): rebuilding
rebuilding directory inode 19338858410
entry ".." in directory inode 19338858597 points to non-existent inode
36494532848
bad hash table for directory inode 19338858597 (no data entry): rebuilding
rebuilding directory inode 19338858597
entry ".." in directory inode 19338858624 points to non-existent inode
36494532848
bad hash table for directory inode 19338858624 (no data entry): rebuilding
rebuilding directory inode 19338858624
entry ".." in directory inode 19338858744 points to non-existent inode
36494532848
bad hash table for directory inode 19338858744 (no data entry): rebuilding
rebuilding directory inode 19338858744
entry ".." in directory inode 19338858747 points to non-existent inode
36494532848
bad hash table for directory inode 19338858747 (no data entry): rebuilding
rebuilding directory inode 19338858747
entry ".." in directory inode 19338858755 points to non-existent inode
36494532848
bad hash table for directory inode 19338858755 (no data entry): rebuilding
rebuilding directory inode 19338858755
entry ".." in directory inode 19338858802 points to non-existent inode
36494532848
bad hash table for directory inode 19338858802 (no data entry): rebuilding
rebuilding directory inode 19338858802
entry ".." in directory inode 19338858930 points to non-existent inode
36494532848
bad hash table for directory inode 19338858930 (no data entry): rebuilding
rebuilding directory inode 19338858930
entry ".." in directory inode 19338859084 points to non-existent inode
36494532848
bad hash table for directory inode 19338859084 (no data entry): rebuilding
rebuilding directory inode 19338859084
entry ".." in directory inode 19338859117 points to non-existent inode
36494532848
bad hash table for directory inode 19338859117 (no data entry): rebuilding
rebuilding directory inode 19338859117
entry ".." in directory inode 19338859264 points to non-existent inode
36494532848
bad hash table for directory inode 19338859264 (no data entry): rebuilding
rebuilding directory inode 19338859264
entry ".." in directory inode 19338859287 points to non-existent inode
36494532848
bad hash table for directory inode 19338859287 (no data entry): rebuilding
rebuilding directory inode 19338859287
entry ".." in directory inode 19338859315 points to non-existent inode
36494532848
bad hash table for directory inode 19338859315 (no data entry): rebuilding
rebuilding directory inode 19338859315
entry ".." in directory inode 19338859362 points to non-existent inode
36494532848
bad hash table for directory inode 19338859362 (no data entry): rebuilding
rebuilding directory inode 19338859362
entry ".." in directory inode 19338859544 points to non-existent inode
36494532848
bad hash table for directory inode 19338859544 (no data entry): rebuilding
rebuilding directory inode 19338859544
entry ".." in directory inode 19338859557 points to non-existent inode
36494532848
bad hash table for directory inode 19338859557 (no data entry): rebuilding
rebuilding directory inode 19338859557
entry ".." in directory inode 19338859570 points to non-existent inode
36494532848
bad hash table for directory inode 19338859570 (no data entry): rebuilding
rebuilding directory inode 19338859570
entry ".." in directory inode 19338859663 points to non-existent inode
36494532848
bad hash table for directory inode 19338859663 (no data entry): rebuilding
rebuilding directory inode 19338859663
Metadata CRC error detected at 0x5579eeec2a13, xfs_dir3_block block
0x6a7c0bd58/0x1000
corrupt block 0 in directory inode 19338859680: junking block
Segmentation fault
