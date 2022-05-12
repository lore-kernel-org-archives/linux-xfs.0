Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7E9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 19:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350008AbiELTCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 15:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238231AbiELTCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 15:02:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0118BA3097
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 12:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652382159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZHsTZgTmK7JFIpyGKwEv5yCZmArm57l9na8sgDhuPc=;
        b=Zw4B+4UIOqsVAwBJD16AewgGjsjj4aLl1B6FwcaChMBgdk5nBJy3uwn8TTiru8VlVam0Xm
        1nUzrnOflawmQxy1tgyXYN5sQq60V09pzhWXCb2uI5bMgRJR4Tb0OUpai1VmJ38vYTzWiL
        Hp7SF6XZHuKw9XBBRlArV9jYQRMRnHk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-6HkVsFfyPrqUXnSt1iZxVQ-1; Thu, 12 May 2022 15:02:37 -0400
X-MC-Unique: 6HkVsFfyPrqUXnSt1iZxVQ-1
Received: by mail-il1-f199.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so3823794ilu.14
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 12:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aZHsTZgTmK7JFIpyGKwEv5yCZmArm57l9na8sgDhuPc=;
        b=yutvZ5SGrcISAURRP4Vfh8HWq3jdloo6yG6Jd/7u37OkPHkAPMKgs1+LnnxNt7tvjr
         T4L4ykJRoQYrPXPt15CPDcaWVSER8r8fCS5HfxZq0EsG5kI31vjTsUJX36xPKonibxsr
         lZLK0iwoC5IGEuiT5ux5oWKm7eh0u3298+EH/o2o+8Dl4M6jN2HzwjH30Jn//HCPa5kA
         y9EYbkR4w6zpCCwz1AwkA6I1hRhZcqW1oZGocKQtEHzAip4t3kavPUZN3tbLa5yU+/XU
         0k3e8bCreP+ekAL38C9Z9JQy5fbqNFhrtB6EgmZvndS3pBlZqktXghW1JikStxzQz9nA
         W/HA==
X-Gm-Message-State: AOAM533l0cWHoJ3ly4bqSZSLUV0xFb0eI9zjE9+j+pZccDWRIe8k3geM
        Kk7b2N/qiM+ISLzvqTWI47vd4v8QssiCtaHuDvXROom1XnC+Q4qZhcXgoPxLNIW5QqH7C8khnmN
        drLWKMEQF1BCZuTxkRxIl
X-Received: by 2002:a92:de0d:0:b0:2cd:6d7b:e12f with SMTP id x13-20020a92de0d000000b002cd6d7be12fmr722114ilm.179.1652382155199;
        Thu, 12 May 2022 12:02:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8Yj67pbH8GbRiguozeHKoXDQx8A3VzL/zqQKke7fyYFEnTBjt8Z69LTuu+SI7DmXhfSKRCg==
X-Received: by 2002:a92:de0d:0:b0:2cd:6d7b:e12f with SMTP id x13-20020a92de0d000000b002cd6d7be12fmr722106ilm.179.1652382154915;
        Thu, 12 May 2022 12:02:34 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id cx4-20020a056638490400b0032b3a781759sm96184jab.29.2022.05.12.12.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 12:02:34 -0700 (PDT)
Message-ID: <57914c5f-c39a-e3de-14cf-6565ee82f834@redhat.com>
Date:   Thu, 12 May 2022 14:02:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 1/3] xfs_repair: detect v5 featureset mismatches in
 secondary supers
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <165176674590.248791.17672675617466150793.stgit@magnolia>
 <165176675148.248791.14783205262181556770.stgit@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <165176675148.248791.14783205262181556770.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:05 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we detect and correct mismatches between the V5 features
> described in the primary and the secondary superblocks.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---


> +	if ((mp->m_sb.sb_features_incompat ^ sb->sb_features_incompat) &
> +			~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR) {

I'd like to add a comment about why XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR is special.
(Why is XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR special? Just because userspace doesn't
bother to set it on all superblocks in the upgrade paths, right?)

-Eric

