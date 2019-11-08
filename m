Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC1BC5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E4F02178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n/kApIx0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfKHHgf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:36:35 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:44352 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfKHHge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:36:34 -0500
Received: by mail-lj1-f171.google.com with SMTP id g3so5098564ljl.11
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 23:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vuESmawkElakhHr8A9Mww3n2t4uzuCAz2n0H48lVWZ4=;
        b=n/kApIx0Bb1DILv6tgW7ROPEKEB6vbLvJjWy5djPM5boahlPjN8i0p7xJ6nL+BDZQM
         g+hLVaGd3h2PMvoKYYyPSaU1gUmPzXbFCa3/yKCkLEBuEYKHcuRwpUthIdY2/FyM6X1X
         /MUybu5YDwpywg2cZuOqv4NTNr6Neb8AhArGeoSoefrpGd7MwFbtmBPqBWuZok9G86NZ
         ELbfLsxGQoGNF4MeQZJjBD2RIBLNXCQjzHaXYZeNr36Pwep8YHTCmJoURVOI5Ao+S/xT
         Ooc19TRmrthNnCdv4UDKXY6h99Y5Dj4KTrk1GwXfBKL9qzpQ9Drs3nkhtx8a8OWeAGs8
         wtgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vuESmawkElakhHr8A9Mww3n2t4uzuCAz2n0H48lVWZ4=;
        b=Tp4LXi6D+o5suAq/JXHCPof+m9SLcMFs5aIwACBSY7D2iyh+1teltXonE0Jqpb93Gr
         KxEwo/6T9V3GDw8jpu1fi4Impy2VPWgiZslNKDPVPq7ISpWjdjKHxT5gumW/z7nqQr5Y
         Oyj2tSvsi3sQaiZvci0NZvihoNAYg52nysE3sOG8kk8u/DhMF/dZC8q7Ao76Zz15nYSW
         QvGYXnotitYPTllt71P+KCxRfsOYjD9CnfoGA5gUs96CFb5jw61KtpBFJevchu3wGXBK
         aNp6gcsYNZs5ZAMhtpr6kbzAK+kPcB2jh+ZBRMb4qDLQJ8OVLp2eZoYSQzeGOyD4oD7F
         0YCg==
X-Gm-Message-State: APjAAAUg66XXpP5tDSktseSVkQDG+IbCHtJXiM4TXuF+e+mQIMLicxbP
        /4/9UK/JoNeyMuQfkOdES0Ay00+G
X-Google-Smtp-Source: APXvYqwJPJALV1CfCmpmpPyPHeIOJu2HOlAW+muDJZC51S7q9TkBLGuCcLXHJDRxO9dmcabtzmWJ3g==
X-Received: by 2002:a2e:9695:: with SMTP id q21mr2592298lji.206.1573198592315;
        Thu, 07 Nov 2019 23:36:32 -0800 (PST)
Received: from amb.local (out244.support.agnat.pl. [91.234.176.244])
        by smtp.gmail.com with ESMTPSA id g7sm2189574lfb.4.2019.11.07.23.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 23:36:31 -0800 (PST)
Subject: Re: WARNING: CPU: 5 PID: 25802 at fs/xfs/libxfs/xfs_bmap.c:4530
 xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
 <20191108065627.GA6260@infradead.org>
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Message-ID: <c52e2515-272f-476e-7cfa-a2ef23c66b56@gmail.com>
Date:   Fri, 8 Nov 2019 08:36:31 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191108065627.GA6260@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08/11/2019 07:56, Christoph Hellwig wrote:
> On Fri, Nov 08, 2019 at 07:01:15AM +0100, Arkadiusz Miśkiewicz wrote:
>>
>> Hello.
>>
>> I have two servers:
>>
>> backup4 - one with Adaptec ASR8885Q (that's the one which breaks so
>> often but this time adaptes works)
>>
>> backup3 - other with software raid only
>>
>> Both are now running 5.3.8 kernels and both end up like this log below.
>> It takes ~ up to day to reproduce.
> 
> The WARN_ON means that conversion of delalloc blocks failed to find
> free space.  Something that should not be possible due to the delalloc
> reservations.  What as the last kernel where you did not see something
> like this?
> 

4.20.13 looks ok
5.1.15 bad (that warn_on triggered)

on both machines according to my old logs

-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
