Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.gn.apc.org ([37.220.108.136]:35623 "EHLO mail.gn.apc.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbeEVIzv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 04:55:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.gn.apc.org (Postfix) with ESMTP id D221B20391E3
        for <linux-xfs@vger.kernel.org>; Tue, 22 May 2018 09:46:31 +0100 (BST)
Received: from mail.gn.apc.org ([127.0.0.1])
        by localhost (mail.gn.apc.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8hjsVSH-6a1a for <linux-xfs@vger.kernel.org>;
        Tue, 22 May 2018 09:46:29 +0100 (BST)
Received: from anonymous ([10.254.254.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: ianmac)
        by mail.gn.apc.org (Postfix) with ESMTPSA id 5A78920391DA
        for <linux-xfs@vger.kernel.org>; Tue, 22 May 2018 09:46:29 +0100 (BST)
From: Ian Macdonald <imac@gn.apc.org>
Subject: Deleting a project from XFS quotas
Message-ID: <d30e573b-9c2a-cf97-7608-ad10a7b1b21c@gn.apc.org>
Date: Tue, 22 May 2018 10:46:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

We have been using XFS project quotas to track disk usage for various
websites that we have on a server. The machine was running Debian jessie
and this is what the quota report looked like:
# xfs_quota -xc "report -h" /var

Project quota on /var (/dev/xvda3)
                        Blocks
Project ID   Used   Soft   Hard Warn/Grace
---------- ---------------------------------
web01       74.3G    80G    81G  00 [------]
web02       72.5G    75G    76G  00 [------]
web03       18.5G    20G    21G  00 [------]
web04       33.3G    40G    42G  00 [------]
web05       10.3G    20G    21G  00 [------]
web06        2.9G    20G    21G  00 [------]

However, after upgrading the server to Debian stretch, that same report
now looks like this:

Project quota on /var (/dev/xvda3)
                        Blocks
Project ID   Used   Soft   Hard Warn/Grace
---------- ---------------------------------
#0          14.3G      0      0  00 [------]
#15             0    20G    21G  00 [------]
#32             0    20G    21G  00 [------]
#33             0    20G    21G  00 [------]
#34             0    20G    21G  00 [------]
#35             0    20G    21G  00 [------]
#36             0    20G    21G  00 [------]
web01       86.5G    95G    96G  00 [------]
web02       73.2G    75G    76G  00 [------]
web03       19.5G    20G    21G  00 [------]
web04       33.3G    40G    42G  00 [------]
web05       10.3G    20G    21G  00 [------]
web06        3.1G    20G    21G  00 [------]

I only have the 'web01' to 'web06' projects listed in my /etc/projects
and /etc/projid files, for the particular directories whose disk usage I
want to manage via XFS quotas.

Does anyone have any idea why I'm seeing these extra projects listed
after the upgrade to stretch? What can I do to remove them so that I'm
only setting quotas and doing file accounting for the six web
directories that I've configured?

Thanks in advance for any help you are able to give me.

Best wishes,
-Ian Macdonald

-- 
Ian Macdonald
GPG/PGP: 0778 889F EE5D DFB4 D195 97A7 779B D6BF A305 DEFC

GreenNet Ltd, 56-64 Leonard Street, London EC2A 4LT
UK Tel:      0330 355 4011
Intl:        +44 20 7065 0935
Twitter:     @GreenNetISP
Registered in England & Wales, Company No. 02070438
