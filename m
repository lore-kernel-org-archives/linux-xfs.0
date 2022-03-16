Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE64C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 19:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbiCPT3I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 15:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346320AbiCPT3H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 15:29:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F20FE234
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 12:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647458869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6hy7SLMsi8WT8vc1t1DzuANw74BOCRa6umrTk0T6duo=;
        b=Bn/gQ8gkZbci8G6tUq5S8uLAn92F4gDwJ8Rozmj3gLMxud/OI9I3TGhuMVpFatpIQOpZtB
        SAQhhL1pZIJMzGNGatoZDT/5M9su2D/plH0DvHReDC9UeLJIPlHwGAiLeOjjDemBNFafuo
        tKnHz4epIkyFjv2iKoo8lrZEgsFo/cs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-EmTHzAFkNESdynmz1SEL-w-1; Wed, 16 Mar 2022 15:27:47 -0400
X-MC-Unique: EmTHzAFkNESdynmz1SEL-w-1
Received: by mail-il1-f197.google.com with SMTP id 3-20020a056e020ca300b002c2cf74037cso1823713ilg.6
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 12:27:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=6hy7SLMsi8WT8vc1t1DzuANw74BOCRa6umrTk0T6duo=;
        b=pMt98zAGWIcXN/OcxsdxZs9vgI9JS9xJ92rBcDFmGJfQETerc0FnL/H0yRY7h+FnDS
         IodoSEnJGOeuxiq/IaNvmgDIR1CCbOAmqtj8vAFEZuP35FT/MsXj4F1we574pW6E3Avb
         3opzJobgmsBknLldp4Iwv1fP/twfZQ6tyxu3yMURnVctHRFzovb45Qgf764RJLtlduUp
         l4kJpEeWcjgmiPMSsdm786bSKpZXoEOecRISTSIU2Rtp/XOAfCA0T0leNWwQ/2Vxed/R
         r0/Pq5Q+a/hP8eC+pNMjrOrx+R5ND25G3NtcjzFO7/RBpsKDY9w2cavt9ro4bDtBfBM8
         ZsIQ==
X-Gm-Message-State: AOAM531qK8fqKjLhkT8YZ8F0yf5wRtZp3ie5sMfKCdQjz156MKN3ES4J
        yxVmLmhXkzlhyYU4PRn5iqz9uqo+o8fq8C7yf4COyEfSX7fh+iGGxbeuAsf6ieQ3EKy3xfRqJnd
        hB7Z472OeRLGpMlCiI8w1
X-Received: by 2002:a92:c543:0:b0:2c7:de2a:750d with SMTP id a3-20020a92c543000000b002c7de2a750dmr478976ilj.115.1647458867017;
        Wed, 16 Mar 2022 12:27:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSbS6Ra3KVtvxBRn/sqd0EDL0qlbQki5czAPwpo7WE6pR2qYyvP/HxkdFae3JzHSDAdYMDrQ==
X-Received: by 2002:a92:c543:0:b0:2c7:de2a:750d with SMTP id a3-20020a92c543000000b002c7de2a750dmr478970ilj.115.1647458866718;
        Wed, 16 Mar 2022 12:27:46 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id h28-20020a056e021d9c00b002c64c557eaasm1618309ila.12.2022.03.16.12.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 12:27:46 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ec1b7245-3fc3-f565-19bc-01cbccded095@redhat.com>
Date:   Wed, 16 Mar 2022 14:27:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 3/5] mkfs: increase the minimum log size to 64MB when
 possible
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
 <164738661924.3191861.13544747266285023363.stgit@magnolia>
In-Reply-To: <164738661924.3191861.13544747266285023363.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/15/22 6:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Recently, the upstream maintainers have been taking a lot of heat on
> account of writer threads encountering high latency when asking for log
> grant space when the log is small.  The reported use case is a heavily
> threaded indexing product logging trace information to a filesystem
> ranging in size between 20 and 250GB.  The meetings that result from the
> complaints about latency and stall warnings in dmesg both from this use
> case and also a large well known cloud product are now consuming 25% of
> the maintainer's weekly time and have been for months.

And we don't want that!

> For small filesystems, the log is small by default because we have
> defaulted to a ratio of 1:2048 (or even less).  For grown filesystems,
> this is even worse, because big filesystems generate big metadata.
> However, the log size is still insufficient even if it is formatted at
> the larger size.

I have no complaints about raising the log size like this; I think it's prudent,
even if it doesn't solve world hunger and bring global peace.

I do want to give a little more thought to how calculate_log_size() looks now;
it's inherited spaghetti but my eye twitches a little bit when we follow this:

                         * For small filesystems, we want to use the
                         * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
                         * at all possible,

with "haha no actually we should calculate something realistic" ;)

I don't want to hold this up for long but I want to put a little thought into
whether the resulting code can be a bit more understandable, there's so much
pingponging around about clamping the size up, down, bigger, smaller, this
heuristic, that heuristic I'm having trouble keeping it straight in my
old brain.

Thanks,
-Eric

