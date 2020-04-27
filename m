Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C592C55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 08:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF392080C
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 08:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="X1PoDm3Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgD0IMV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 04:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgD0IMV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 04:12:21 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C142C061A41
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 01:12:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so19412970wma.4
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 01:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=T+YOkTboZKHfrFL4WsSQSPbM8xtl93Z/+lUuYqzhRIE=;
        b=X1PoDm3YEE4mooI1ZsYWfZ1CviWg5VxzY5SeRUbrNAHYIWEHtcRp5L+eU3M5fFBcLS
         MPuQRlDJXKn57d6RVpHHNfU1J+jhq5nGliATjA1H8uNg79xcuqsQCQD55ljjOofx8P1H
         1oWRAqknqWaZ87suLJMGlb/Q6y8RvYvpogRg7UryZHdmdHy5dM4BjniyCOzwxOg/Ol0J
         GnLwI4wEYki6zVyG7biB4/pIXEf1+k6Zld2fAOt8wkJ7dNPEF0EWx6BWEsdgTT2Ek9Pt
         6T2h2AmlRZTymQIIYNBAqlGP6OhUEGJfqBd+oMjIGiVxnhVRHl+p9/OpnPp5V/1KuBf2
         uu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=T+YOkTboZKHfrFL4WsSQSPbM8xtl93Z/+lUuYqzhRIE=;
        b=Mo+52YVAVAv7fFVxqZCx7ktFiket4T9gHGXIpLddVngGAr+dF6WJrPHl+maZ/WcfYp
         jqqZtZWarc0Ve2HI7OPdfAIYaLJ/zzvd+QMi7RPFUsFGuqMU1tBMqFRe28sbiRtETa3s
         EinEN9B6n6Minob8QV9kuQZstxKAVXB18/Sa7GjqYCuyZUaBM2vUnxs3Tgp75DxKv2mx
         J/ApLVqpmMgqOIeywnxq9j7MrimfIQTqQVT2OvtZtC32VsstmyARejfTMRZ6JTC+gEjX
         JZFZavNxnI/bkGGgjj49o1j4ANF4e7iCZZsJBc6GKbEl/MjeSMjZkNcByRy/Qq+mvpzi
         0ntg==
X-Gm-Message-State: AGi0PuYwetQu87I5Ko5cEYrIbvMTvqsCr66DKov9LyYEPSzX2zk23YQY
        hazzkKaNms5ufwFulkK46gJ2xsoC5IOp+xnH
X-Google-Smtp-Source: APiQypIkfjwetEKwWVZwJzkDKcIDkSLdvOjcQpMDTUop02Ywcb2M2mvrTHeqTCc7INdBIZ9tjgAhGA==
X-Received: by 2002:a7b:c118:: with SMTP id w24mr24009648wmi.173.1587975139149;
        Mon, 27 Apr 2020 01:12:19 -0700 (PDT)
Received: from ?IPv6:2001:16b8:4886:8400:6d4b:554:cd7c:6b19? ([2001:16b8:4886:8400:6d4b:554:cd7c:6b19])
        by smtp.gmail.com with ESMTPSA id c25sm13908371wmb.44.2020.04.27.01.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 01:12:18 -0700 (PDT)
Subject: Re: [RFC PATCH 6/9] iomap: use set/clear_fs_page_private
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        david@fromorbit.com, willy@infradead.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200426214925.10970-1-guoqing.jiang@cloud.ionos.com>
 <20200426214925.10970-7-guoqing.jiang@cloud.ionos.com>
 <20200427055727.GA30480@infradead.org>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <c00ffe2d-0340-2598-a697-bc8bf52f3871@cloud.ionos.com>
Date:   Mon, 27 Apr 2020 10:12:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427055727.GA30480@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/27/20 7:57 AM, Christoph Hellwig wrote:
> FYI, you've only Cced the xfs list on this one patch.  Please Cc the
> whole list to everyone, otherwise a person just on the xfs list has
> no idea what your helpers added in patch 1 actually do.

Sorry, I should cc more lists for patch 1, thanks for reminder!

Thanks,
Guoqing
