Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDFEC25B47
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 22:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjJ0WmG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 18:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjJ0WmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 18:42:06 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AE9AF
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 15:42:04 -0700 (PDT)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwVWl-004AbG-43; Fri, 27 Oct 2023 22:42:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1054644: xfsprogs-udeb: causes D-I to fail, reporting errors about missing partition devices
Reply-To: Bastian Germann <bage@debian.org>, 1054644@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1054644
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: 
References: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <871qdgccs5.fsf@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <20231027154505.GL3195650@frogsfrogsfrogs> <ZTvjFZPn7KH6euyT@technoir> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <87v8arbt0s.fsf@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1054644-submit@bugs.debian.org id=B1054644.1698446291992022
          (code B ref 1054644); Fri, 27 Oct 2023 22:42:02 +0000
Received: (at 1054644) by bugs.debian.org; 27 Oct 2023 22:38:11 +0000
Received: from stravinsky.debian.org ([2001:41b8:202:deb::311:108]:34292)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=stravinsky.debian.org,EMAIL=hostmaster@stravinsky.debian.org (verified)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1qwVT1-004A4A-7k
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 22:38:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Reply-To
        :Cc:Content-ID:Content-Description;
        bh=xAzWcjwi1b/FodsCEc+MGFBAb1DnPSh7W7sSwgmJJbk=; b=hdP4kMZLQvN+KlO4jCfQDGlTGV
        cuSLro/8qdgAmtRCtEDbcTOJdLnZiRIER4YaAFDQ/gHIl5MmZVKu6pQgLP6HMNdXKLo1/jI7pUbLa
        KkhSuFq/JRe31B3CcyGDlfTx6L8eF7nfI14gCcj091qx+y4I/fje/d62v7MtIEU/QlMwlo/jJV7+7
        R2nkRwyjo/6zRgoJUI7XRhNdu+k6iOZKvfVMdKZYxNYoASSeOBu2S3wM/nbLYDbK12P5s7qjmHqYr
        GXBg3ks02+L69BWxfrS/9k2Ng+ypYX6k/fbmGc0w/UOJ/YuxmtMgIxJ0ZZ6QvnU+FQ7YDaDUv1trE
        1AJ8+ARA==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1qwVSz-000bzR-4l
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 22:38:09 +0000
Message-ID: <08691503-1a3a-4149-82b8-749e0606159b@debian.org>
Date:   Sat, 28 Oct 2023 00:38:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-DE
To:     1054644@bugs.debian.org
From:   Bastian Germann <bage@debian.org>
In-Reply-To: <87v8arbt0s.fsf@nimble.hk.hands.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Debian-User: bage
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Control: reassign -1 grub2

Please consider applying the identified patch so that debian installer does not break installing on XFS.
