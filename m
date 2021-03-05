Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0E2C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 10:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B46764F5B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 10:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCEKWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 05:22:20 -0500
Received: from corp-mailer.zoner.com ([217.198.120.77]:37186 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEKWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 05:22:07 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2021 05:22:07 EST
Received: from [10.1.0.142] (gw-sady.zoner.com [217.198.112.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by corp-mailer.zoner.com (Postfix) with ESMTPSA id 1ABE41F265;
        Fri,  5 Mar 2021 11:14:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zoner.cz;
        s=zcdkim1-3eaw24144jam11p; t=1614939273;
        bh=Wa1aBz0Ih4eAOpst56m+OrGQ//lLgOm4tXPaM5v1qqg=;
        h=From:Subject:To:Cc:Date:From;
        b=p28pfIxKd9I418Wced5yAxF2UFkPdA6Nrm6Uu4T9HX/CnV/iyLpf9sXscYpZOOucq
         xaF+Ps02bTFENaLc6rzBnwQ06iP6i6ojTdcmMikIwMNpgM2jgm4HKITnjb8T3MwNsR
         QtZPzQkCNdlYDm7JOM5EONJO9GfwZf+P16PRMYToPu7sIMX+gyCvIgRiXjxElLlbDs
         xdB8wF+uywlI3mUGxSI7lD43YNfkKZar3RfH5jUp7vHMuErcblVcTMNd4F9uZkx52V
         0uxVgIZF0ifsMJRHz2bFU8kENXIQsrx3XSD2QRFW2D/l/N9L4M366JHBaUY1W3acHy
         ROztGvFvCFBHA==
From:   Martin Svec <martin.svec@zoner.cz>
Subject: Incorrect user quota handling in fallocate
To:     linux-xfs@vger.kernel.org
Cc:     Martin Svec <martin.svec@zoner.cz>
Message-ID: <c0e98a3b-35e3-ecfe-2393-c0325d70e62f@zoner.cz>
Date:   Fri, 5 Mar 2021 11:14:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Content-Language: cs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've found a bug in XFS user quota handling in two subsequent fallocate() calls. This bug can be
easily reproduced by the following script:

# assume empty XFS mounted on /mnt/testxfs with -o usrquota, grpquota

FILE="/mnt/testxfs/test.file"
USER="testuser"

setquota -u $USER $QUOTA $QUOTA 0 0 -a
touch $FILE
chown $USER:users $FILE
fallocate --keep-size -o 0 -l $FILESIZE $FILE
fallocate -o 0 -l $FILESIZE $FILE

That is, we create an empty file, preallocate requested size while keeping zero file size and then
call fallocate again to set the file size. Assume that there's enaugh free quota to fit the
requested file size. In this case, both fallocate calls should succeed because the second one just
increases the file size but does not change the allocated space. However, I observed that the second
fallocate fails with EDQUOT if the free quota is less than _two times_ of the requested file size. I
guess that the second fallocate ignores the fact that the space was already preallocated and
accounts the requested size for the second time. For example, if QUOTA=2GiB, file size FILESIZE=800
MiB succeeds but FILESIZE=1600 MiB triggers EDQUOT in second fallocate. The same test performed on
EXT4 always succeeds.

I've found this issue while investigating why Samba (ver. 4.9.5) returns disk full error although
there's still enaugh room for the copied file. Indeed, when Samba's "strict allocate" options is
turned on Samba uses the above described sequence of two fallocate() syscalls to create a new file.

We noticed this behavior on Debian Buster 4.19 kernel and confirmed on stable 5.10.15 vanilla kernel.

Best regards,

Martin

