Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25839C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 23:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiFVXlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFVXlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 19:41:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD1FD427C8
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 16:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655941274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tEFH4AaxArltoCnAIzD7nh9LlgQLuH8IBss7/jEDeKo=;
        b=VM1NIKpnU2cOee+Pe2VWkEwDkd/JKeKubkj+okOlNEz42xCIkNCJATC6BHmlMK2TMBnCi0
        kAO19jLpzdvrI/qV4v++6jyAJVaiBIUt5VKBp2WqOIBgIABxq2pGDnOKUEIs4goVgkcn/R
        ydXA59fLkHVYWa/YNWyDRJOYFWTcwmU=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-G_VKDlbSPyup7dqRqWoJFg-1; Wed, 22 Jun 2022 19:41:13 -0400
X-MC-Unique: G_VKDlbSPyup7dqRqWoJFg-1
Received: by mail-il1-f200.google.com with SMTP id w15-20020a056e021a6f00b002d8eef284f0so9367478ilv.6
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 16:41:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tEFH4AaxArltoCnAIzD7nh9LlgQLuH8IBss7/jEDeKo=;
        b=wqNaEjfxBBReZoguYG2XcGUAi8dmcy/1/y+tiJyXjZ3bVp+QVwom0jdsC2D/AlCmhE
         PuVmzJ0MHkhtz5vVN0J0FEB3/bEF1T9+/py9TTY6fOC3mUpgiTM7YDtVviM+whTU6J/F
         8EeBlVHcWwW28pacS2IWSVRku96W02TKSARl4YgzZEFz1+Yr24ydv8yhA0kIPKGRao98
         uP+OPp2UT8kQIhLKXJpcxRMGuOY2TpiTb7sut1bx6Syz02KStaB9YyKWyo+xdflGUR+/
         YROZqmRA4aZ4GKqC5saw49f/lK2NMWpnqeMwgIp60GzyrheUI37XpoFEJS18VUci4V+S
         QR9Q==
X-Gm-Message-State: AJIora+VFE2JQ6YlFFC3qrwOqnnUD5nXJM9RLDAszWWtVis6m2/pC15v
        LmUMK3z/cEYyDyqH5FA7P9oB4AoJElkB/QIf5uFPNpEaWPZ553Vl+6+ihF3RuPSBSCFpd1gCvcJ
        F4kQzKTe4kGzOzx4Fj7r5
X-Received: by 2002:a05:6e02:1be5:b0:2d9:3419:742a with SMTP id y5-20020a056e021be500b002d93419742amr3486811ilv.289.1655941272440;
        Wed, 22 Jun 2022 16:41:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vSvCJ1lmhxeoiBXzuhidc5+puPLMsAb2Jn93q6VcGalalB9qGf+Pd6h7BdeeHIUFI21LQeAA==
X-Received: by 2002:a05:6e02:1be5:b0:2d9:3419:742a with SMTP id y5-20020a056e021be500b002d93419742amr3486794ilv.289.1655941272063;
        Wed, 22 Jun 2022 16:41:12 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e23-20020a02a517000000b00339c46a5e95sm3112907jam.89.2022.06.22.16.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 16:41:11 -0700 (PDT)
Message-ID: <f01f8d0c-1132-251b-b25d-d9dd72f119b2@redhat.com>
Date:   Wed, 22 Jun 2022 18:41:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH V2] xfs: add selinux labels to whiteout inodes
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
References: <1655765731-21078-1-git-send-email-sandeen@redhat.com>
 <1655775516-8936-1-git-send-email-sandeen@redhat.com>
 <YrOmLRfS0eIrMCDl@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <YrOmLRfS0eIrMCDl@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/22/22 6:30 PM, Darrick J. Wong wrote:
> On Mon, Jun 20, 2022 at 08:38:36PM -0500, Eric Sandeen wrote:
>> We got a report that "renameat2() with flags=RENAME_WHITEOUT doesn't
>> apply an SELinux label on xfs" as it does on other filesystems
>> (for example, ext4 and tmpfs.)  While I'm not quite sure how labels
>> may interact w/ whiteout files, leaving them as unlabeled seems
>> inconsistent at best. Now that xfs_init_security is not static,
>> rename it to xfs_inode_init_security per dchinner's suggestion.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks fine to me.  I wondered slightly if the label creation needs to be
> atomic with the file creation, but quickly realized that /never/
> happens.  Assuming this isn't high priority 5.19 stuff, I'll just roll
> this into 5.20 if that's ok?
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks Darrick. I don't think it's high priority, I got a bug report about
the behavior, but there was no indication that it was actively causing
visible problems.

-Eric

