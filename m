Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCAA6C47078
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 16:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBCC660C3E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 16:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbhEUQMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 12:12:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhEUQMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 12:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621613483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jtcR+YpQ8JxELRRaAfsGYkpbF4f+wpH8sTxAvYqummw=;
        b=ACO2C1RHeddiscaoMmtxAPcCTqmtegfswYSPxib9BF6Ah6ZLY7P4Q440WHE1gIQ5p1tT4A
        myqogLwq5ruMbphbsWSnM3UzshHqHMSTqQC1nTQIWGyqh0BkpB7Y3NgLGH/KmvqRM+IJmb
        ayFb4aGOS9c55D4zPl+JmoherlAkQRw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-gKDfwc3RPY2RK_JFQHR0kg-1; Fri, 21 May 2021 12:11:20 -0400
X-MC-Unique: gKDfwc3RPY2RK_JFQHR0kg-1
Received: by mail-il1-f200.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so20997102ilc.6
        for <linux-xfs@vger.kernel.org>; Fri, 21 May 2021 09:11:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jtcR+YpQ8JxELRRaAfsGYkpbF4f+wpH8sTxAvYqummw=;
        b=COfmafT4VEuosTpRC2Sv3rrpdTGoVnODmFSK6JghLeuJWsRAgLPOntVxPuTnOMU5aS
         0l8IA1m3kYM8Uonfw3Hggw30s+bDzNf2/sGzBoKLM2MdaHwKWtLtyNaJfL+jp/Olc8kq
         qrRM1x7V7stl9bP4TSiSPmpXzwN2Mtaq+ovNlbbH4zbO7WsmuIMHwRWyGwiYsO0+saEO
         e/XLpIaeaDdRfyoXmtvx9Q8oqIIKy3hydU6hAjKJDhdp4jr7RypyXpn1yWwR9uZjurSY
         DunoED4He/uLk5LEZFkX5XjPD2rHA7tDPfOtR8aKkKVm7RXnZuy6SYMmLSNTxoMUg76t
         N7WA==
X-Gm-Message-State: AOAM533a/zQPcO1JvuhpaZLK9KjN6qLpx+WhfEOyS9QO3YIsoY2JN7sF
        AVAmdV67Pu8loFiRX8pflymqeNWUuAh/N4rvQw7xB5UY4tpYWLQ6UswVF06LcgfnYzjTAerUWEr
        83hkFLY445dBGzbL/a2ysGj9gcLTP0C/rJ1CGWIoNc2Ckg4Ge733LO+MOh3qfM1a/Wqicqhfy
X-Received: by 2002:a6b:3119:: with SMTP id j25mr11344942ioa.64.1621613479976;
        Fri, 21 May 2021 09:11:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQhhnO8ZEWEBJrjzOWuYkRzRKjYxx7mOT64RLecIhI4kwF4WSTJTjdakcKYJux+U0me0WBlA==
X-Received: by 2002:a6b:3119:: with SMTP id j25mr11344921ioa.64.1621613479718;
        Fri, 21 May 2021 09:11:19 -0700 (PDT)
Received: from liberator.sandeen.net (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id p25sm6720640ioh.39.2021.05.21.09.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 09:11:19 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC v2] xfs: Print XFS UUID on mount and umount events.
To:     "Darrick J. Wong" <djwong@kernel.org>, lukas@herbolt.com
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
References: <20210519152247.1853357-1-lukas@herbolt.com>
 <20210520152323.GW9675@magnolia>
 <1c29341ea9b5e362cd3252887ad01879@herbolt.com>
 <20210521160619.GF2207430@magnolia>
Message-ID: <d18919f5-43e5-9423-0541-3efc827f559d@redhat.com>
Date:   Fri, 21 May 2021 11:11:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210521160619.GF2207430@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/21/21 11:06 AM, Darrick J. Wong wrote:
> On Fri, May 21, 2021 at 11:03:11AM +0200, lukas@herbolt.com wrote:
>>> Are you going to wire up fs uuid logging for the other filesystems that
>>> support them?
>> Well, I wasn't planning to but I can take a look on other FS as well
>> Ext4 and Btrfs for start.
>>
>>> What happens w.r.t. uuid disambiguation if someone uses a nouuid mount
>>> to mount a filesystem with the same uuid as an already-mounted xfs?
>>
>> I a not sure I understand the "nouuid mount". I don't think there can
>> be XFS with empty uuid value in SB. And printing the message is independent
>> on the mount method (mount UUID="" ...; mount /dev/sdX ...;).
> 
> I meant specifically:
> 
> mount /dev/mapper/fubar /mnt
> <snapshot fubar to fubar.bak>
> 
> Oh no, I deleted something in fubar, let's retrieve it from fubar.bak!
> 
> mount /dev/mapper/fubar.bak /opt	# fails because same uuid as fubar
> mount /dev/mapper/fubar.bak /opt -o nouuid

While it is possible to end up with 2 mounted devices with the same UUID,
that's still useful information I think; to me, the -o nouuid case doesn't
really argue against this patch.

In fact, it could be /very/ useful information if someone force-mounted
2 paths to the same underlying device by using -o nouuid.

-Eric

