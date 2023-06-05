Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B86C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 17:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbjFERSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 13:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbjFERSs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 13:18:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6131FDC
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 10:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685985481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s2ntfZB6Bcjr7tb+bvJXpvJIfDXnT62QcpLJNvqX35M=;
        b=Kti3GsgeI/O9FMqldI5ILKhzfvv2ROGwUSHzmWLGLW3Qdjk5/nUfIReZVeOCjMx4P5MXQp
        JZNFMUWn0D6g+efCV9l4eRFaHURzUvpbzgBbTp/WR/0BsX7959YURNM4aNBMUzxqRPDCyU
        0hfXOmNm3Bk3KdVgqWJyyrVjuKZ4T1I=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-uav53hl3N9y20HPjp31S0w-1; Mon, 05 Jun 2023 13:18:00 -0400
X-MC-Unique: uav53hl3N9y20HPjp31S0w-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-460a63d4923so763018e0c.0
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jun 2023 10:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685985479; x=1688577479;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s2ntfZB6Bcjr7tb+bvJXpvJIfDXnT62QcpLJNvqX35M=;
        b=l/fB9e/Ipk8hDopxANwD84upaJRzrw7SogKlZk3beXOHSInfk2NNzAMaMdW8OudYuG
         ibHMHHrx1iMgVL6kicm249PQOjoZ5SZx0tgbx7mYIBCq7EaF2TIceOW9I8PP17dF+NtA
         K4nW7XuIOiEI1AGYqtnEGX2L2mm+5/gR9LScJdWTZLBEANwjCVUQPHQ3801ldwrqtgI1
         WMTlrZIPnzLzADgvsrNKZMap7m3tVA/xON6gsJ9wBb1Zw8RPzxbNL8PiSsjNuWsOyc1A
         W5Hmi9HvmdHejtXmLH5jDssNhaxHXOoWhxzfsFLtXvzlICt0LpVU6PxAM/RdlYlGwdZp
         t6jg==
X-Gm-Message-State: AC+VfDwKVuAviK/a1W2Ay29M6czGelf/JWLngN/IWtizZLaAMMuszZG0
        cvcGTTolHYLXihwaYahQOa7bV5T5H5tEOEYkdNRvElotyDICKBTbDNiTcvyHcV5JRJ+AaKu5geN
        12wVJPRxSqjZMOTv7jgNH
X-Received: by 2002:a67:ee56:0:b0:43b:2f7d:f1f3 with SMTP id g22-20020a67ee56000000b0043b2f7df1f3mr401538vsp.26.1685985479652;
        Mon, 05 Jun 2023 10:17:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5gQ6ps+baUxETM0bA8dFWAKpns5pFTrJnZ6uTbKNL9fjtjxzl9RPZUIima2bv0CUPURj8ung==
X-Received: by 2002:a67:ee56:0:b0:43b:2f7d:f1f3 with SMTP id g22-20020a67ee56000000b0043b2f7df1f3mr401526vsp.26.1685985479411;
        Mon, 05 Jun 2023 10:17:59 -0700 (PDT)
Received: from [192.168.1.103] (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id s17-20020a05620a031100b00754b7ee6922sm4347859qkm.9.2023.06.05.10.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 10:17:58 -0700 (PDT)
Message-ID: <098a2385-a012-bada-1cbf-db9401def3da@redhat.com>
Date:   Mon, 5 Jun 2023 19:17:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/2] xfs_repair: always perform extended xattr checks on
 uncertain inodes
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
 <168597945009.1226372.4924137788610504146.stgit@frogsfrogsfrogs>
From:   Pavel Reichl <preichl@redhat.com>
In-Reply-To: <168597945009.1226372.4924137788610504146.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

LGTM & Builds

Reviewed-by: Pavel Reichl <preichl@redhat.com>

