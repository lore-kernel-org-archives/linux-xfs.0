Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEED6C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 17:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349277AbiC3R1c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 13:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349321AbiC3R1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 13:27:16 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AF4F1E94
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 10:25:26 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bq8so28970757ejb.10
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 10:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q6BSRurhLMQkfcWq5OJAf1CntoIc8amS1dBRFgg+9Sg=;
        b=cT2d1lY9Qd9dLaCi0ApDkafMn2V6YBSEqyWDAQ+aSN7Bn6gVYrBnH9/iT4IGj2mfHU
         cVVgvqh83+WEDG5IfPBuABVaguu/3c+GjrdPOmFcx8XJnt32HyjbzZ27Wn80SgdsGN3R
         uuneTZ4Ao+hWmekLtNItUCmWJTaloCYJL9MmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q6BSRurhLMQkfcWq5OJAf1CntoIc8amS1dBRFgg+9Sg=;
        b=4cHuUp1ltZbffH0f3K9NnkY45p0j23wlENsqdTzCRQiyu0zneccPngQploLQ8Pd6wR
         yXPZ586qcHOuzn6j5JI2PBzk76Q+rPpN/cZ8fGJS0cF6N4uaVRQsT/WBbQgzatfiIq0N
         TP2eUlI6lojOZZm72XF2N33IYVRhlnx7zmoIh9VGRto5tVRSPGqsSZNzsPTcm13MKqDI
         qj2wpYYoh0rZeEpxdmHxkRrMyGJ64CbCk9W3Hrny8mGtGq5mxDx+Mc+e3+aM80/TQ67p
         3ediTx9h6FHDNYaC3O7R7kgSHDwxwzNKygKAdP8g68glx2Lzb7gzhQUuZ9bwdAax4ECH
         vJsA==
X-Gm-Message-State: AOAM530zu8sNL56kSTPC8KF6jrOOS/tbX/iLiikKcRVLsGsh+Y8Y03zb
        31Ug73cCfJSw277A1x4uT/W+tNN8nBLZWQ==
X-Google-Smtp-Source: ABdhPJzk88jlHk+5AaIR4P21V3AFeYaCVcZWUqavFbtGyTxI0Wk/4ceP82jUrDT0kE8PpZu/rTOcIg==
X-Received: by 2002:a17:906:5641:b0:6da:8691:3fcc with SMTP id v1-20020a170906564100b006da86913fccmr667783ejr.50.1648661124645;
        Wed, 30 Mar 2022 10:25:24 -0700 (PDT)
Received: from localhost ([2620:10d:c093:400::5:c1bb])
        by smtp.gmail.com with ESMTPSA id gt34-20020a1709072da200b006df6bb3db69sm8516565ejc.158.2022.03.30.10.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:25:24 -0700 (PDT)
Date:   Wed, 30 Mar 2022 18:25:23 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Dave Chinner <david@fromorbit.com>, Petr Mladek <pmladek@suse.com>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkSSg0iiGi5TWjOn@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <YkREmrfoTcqOYbma@chrisdown.name>
 <20220330124739.70edca36@gandalf.local.home>
 <YkSOyC+vEMVSDsdU@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkSOyC+vEMVSDsdU@chrisdown.name>
User-Agent: Mutt/2.2.2 (aa28abe8) (2022-03-25)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Chris Down writes:
>>That article you reference states the opposite of what you said. And I got
>>burnt by it before. Because Linus stated, if it is available for users, it
>>is an ABI.
>
>Hmm, even in 2011 after that article there were discussions about 
>debugfs explicitly being the "wild west"[0], no? I heard the same 
>during LSFMM discussions during recent years as well. Although I 
>confess that I am not frequently in discussions about debugfs so I 
>don't really know where the majority opinion is nowadays.
>
>Either way, as discussed the contents wouldn't be the ABI (as with my 
>/proc/self/smaps allusion), the file format would be, so it wouldn't 
>imply that printk() calls themselves or their locations become an ABI.
>
>0: https://lwn.net/Articles/429321/

(To be clear, that article basically says that debugfs should become less of a 
"wild west", of course. I mostly just am not sure that it's so clear to 
everyone what the ABI status of debugfs currently is, although probably your 
recent experience with Linus is a reasonable thermometer on the whole thing.)
