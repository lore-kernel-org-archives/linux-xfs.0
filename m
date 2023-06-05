Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEB6C7EE23
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 17:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbjFERTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 13:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbjFERTT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 13:19:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B99299
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 10:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685985511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCmu3c9nvPihhl79Cibc1wBqka7ysS8foFrhO0nbbrw=;
        b=IKnFsDUcLk0LFfnlxlmmJdVQojCNumVEqGRIDR0NSZxJRf9EzJYr/Ej/R/NYkqZh5Fzaca
        qgOADk6+GGWDYeUUg7b4hQSaF5qlPHxwNg7oQsUebBDVUihEXzBiVv0pNykgq2OFGAlHlA
        i2u989Ts0nlME34K0kZd1xzc/A/rsCI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-9KvASUpvM0eGOeKOYztKcQ-1; Mon, 05 Jun 2023 13:18:30 -0400
X-MC-Unique: 9KvASUpvM0eGOeKOYztKcQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-626253ba086so48637596d6.2
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jun 2023 10:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685985209; x=1688577209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCmu3c9nvPihhl79Cibc1wBqka7ysS8foFrhO0nbbrw=;
        b=XY1PR/xqfqBW6siSG3Z60ScIvXHqB7Lr0MnQ1crgql/fYhvLG3ocWcNenBnfFcsS+V
         JMugNbE4NfojLugEsYyTH4+vvwyIMQyZ2yKY47ra2N4wBMszmZVrEbcpd0KYl6SFojbG
         UlZYEWVD70YjOuZy6dXGca8+LGzL7UpWIhCbj6ZxGUtFlc/r7sqcATN4wZjROLASZp3s
         JtztZmKu2fGkx7xZCjyfONMQdWuVem4tlEz5FGgLJ6Tj1tem06w6XvlLEBxK5RitMJz3
         3HGpfGlVzDZTOu4WP3AdWRgCvPeErmQ2n0g8Sevvl33hGnNwP4pKVhkIgKMd76qnbBr5
         KYig==
X-Gm-Message-State: AC+VfDxmy1Rwa6DhddcLWvxy1lAlxFIsxPiDCOet9F80No4wuG6o4366
        34LAuOH2TpO/SFNsiS00nfVXgI1r2v1B4UuaaEe4zihjrT7fsAjJkkvINUhK8ZPH68I3e+p9OPh
        l/F0oroROm7DM0BsFCh+8
X-Received: by 2002:ad4:5cae:0:b0:623:9ac1:a4be with SMTP id q14-20020ad45cae000000b006239ac1a4bemr9423756qvh.12.1685985208822;
        Mon, 05 Jun 2023 10:13:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5XhMMHfXUecB4aGCXCYVVT8Thijrh41hVTM98wt4U+K1L2A+DS96jjlSp4QU3qYIU1U43F+g==
X-Received: by 2002:ad4:5cae:0:b0:623:9ac1:a4be with SMTP id q14-20020ad45cae000000b006239ac1a4bemr9423743qvh.12.1685985208590;
        Mon, 05 Jun 2023 10:13:28 -0700 (PDT)
Received: from [192.168.1.103] (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a0cf6c7000000b0062884fd5fbfsm4675243qvo.21.2023.06.05.10.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 10:13:28 -0700 (PDT)
Message-ID: <6a91031c-8dd1-7479-679a-98897ebfd54c@redhat.com>
Date:   Mon, 5 Jun 2023 19:13:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/2] xfs_repair: don't add junked entries to the rebuilt
 directory
To:     "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
 <168597944454.1226372.3979295005270810427.stgit@frogsfrogsfrogs>
Content-Language: en-US
From:   Pavel Reichl <preichl@redhat.com>
In-Reply-To: <168597944454.1226372.3979295005270810427.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

LGTM & Builds

Reviewed-by: Pavel Reichl <preichl@redhat.com>


I'm just wondering why junkit is defined as a short and not a boolean?

