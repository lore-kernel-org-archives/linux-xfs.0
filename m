Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD349C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 18:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiKQSkq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiKQSkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 13:40:45 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27EB7DEC7
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 10:40:44 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id x13so1797651qvn.6
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 10:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouYfmnNioAXyJxLSFfW+3/GI+6hSZMTNjvbhCt5hldU=;
        b=WegoYRoBIunsL+clIJAr6MgJ8Hqra0tci3UJWHWu1Z2wAtXxZ6SgWsoOrQekiRBnRV
         tqcRW9uYOJ+MR/bs4IUERNP8k18Joe8iUBRuG49po9e1HGQ45UVf+ikVoyT246jD3Hw1
         2/ejbmEqVe8YkQ52FOwjQyxfbtq3u7oaTLaQUgcFuLKXzh9opFCdslarl9uIDRmp9MjU
         zCeGIIQ401VpvS08uF5zmPxpiNQZTd3c0fGROCozUQIaGegTVqv/AAwfl+FQMkktUP7T
         15igGUYctVpqFmAq1FqKfwU6K0bI7DJQVVdFYzrKdQc/AeMRgtzy+U/OyjO9Twylcy8H
         tqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ouYfmnNioAXyJxLSFfW+3/GI+6hSZMTNjvbhCt5hldU=;
        b=U38N+O0XQknmu+nWxpitzKX32g2Fe5jINsL722KFH04gBEIgjn2nZWc4NnXiQprrsq
         JBU9zPeYZrH3ZjOspkxii0DYa9sTFWyKTB1j/ADrgekx6vQpSQIThzbLFKBh3S/V9dU1
         3gcBd+6RMIZvFrzfgfkjQ/uwjsB6h+3toyMeEkfm+sj4lDgIg7B9RKVrJQTW6I6Wv/iO
         6DEIMwxwIm/WSCrQphfd+a2Tq6k2WndFxNZJhq5WOCxuXbYBhZ77NT0wj7wu+C/QOX2t
         o8YpJxAwYB5b+4dsveHJyeTm5Dh28tCS053yZq5J23piDKwkstmlWwTxOkoNJYNqsVwR
         gmug==
X-Gm-Message-State: ANoB5pmsfLm6tl6eyTfVTF+RincpOy0Drr8GXDo+SkKZazUGX4mT0GPF
        mtMtXsUlASuD/ZkNdumEygpVAypIrW/iPQ==
X-Google-Smtp-Source: AA0mqf6ZKKwcir6bZGqbxvvToSl62fBIWOUyX0uLa7IMaLEdt8ue1i6abM1SdSCGTnYokEp0EbU+ug==
X-Received: by 2002:a05:6214:1767:b0:4bd:e8ec:263c with SMTP id et7-20020a056214176700b004bde8ec263cmr3558847qvb.104.1668710443657;
        Thu, 17 Nov 2022 10:40:43 -0800 (PST)
Received: from [192.168.0.200] (cpe-24-194-110-152.nycap.res.rr.com. [24.194.110.152])
        by smtp.gmail.com with ESMTPSA id fv11-20020a05622a4a0b00b003a526675c07sm767244qtb.52.2022.11.17.10.40.43
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 10:40:43 -0800 (PST)
Message-ID: <f7f94312-ad1b-36e4-94bf-1b7f47070c1e@gmail.com>
Date:   Thu, 17 Nov 2022 13:40:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     linux-xfs@vger.kernel.org
From:   iamdooser <iamdooser@gmail.com>
Subject: xfs_repair hangs at "process newly discovered inodes..."
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I'm not sure this is the correct forum; if not I'd appreciate guidance.

I have a Unraid machine that experienced an unmountable file system on 
an array disc. Running:

xfs_repair -nv /dev/md3

works, however when running

xfs_repair -v /dev/md3

it stops at "process newly discovered inodes..." and doesn't seem to be 
doing anything.

I've asked in the unraid forum and they've directed me to the xfs 
mailing list.

Appreciate any help.
