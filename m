Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9304C4363D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 13:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800D82087D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 13:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kbiz3uzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgIYNjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 09:39:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbgIYNjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 09:39:02 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601041141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAslvdBiUlhy2u+vWZDqXLP0KOhGsjBtsTra7uoRdlw=;
        b=Kbiz3uzVQ+IUUxcnmbVJDYBv5z/UXlu7FjAM0lL+m6jroIi3IUEGLr9miL2z5CQPjELsaG
        gpBU13R1MYqp0eC7MN4VKhs050iUKwdKuAX+tbREuRzhXRLlHu9fGf97+0Y+dHVjKac9Cb
        kRUF/ojigbP5aD0FZafa7JXRzz6/+9I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-VDZmi_78Md-9NCCcjgDXTA-1; Fri, 25 Sep 2020 09:39:00 -0400
X-MC-Unique: VDZmi_78Md-9NCCcjgDXTA-1
Received: by mail-wm1-f71.google.com with SMTP id s24so851744wmh.1
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2020 06:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NAslvdBiUlhy2u+vWZDqXLP0KOhGsjBtsTra7uoRdlw=;
        b=oB50UOZ+4LFICoBk2ofnNdR/R4WSks0StD8oxL25QGdn60iRjEWfYl9xeMr/yMG+iU
         pRt0ZczMnrpYgqdB6bdb8ZceOwaDcaBatTFekFUvxeQGfexX7QaYt0Ab8r+otj4egLjZ
         lCD5lzzVnytz6lXIwmfZFka5UVBwCJxefcqb5j7vV1SB7noh06Tzk7D8oVKozaBRQ55I
         GKR3i6j8zM6eCofND4qUit5UrdosH7WaUfdedKx3X2lPKXRyFLOBTO08FvGficHA+dDa
         tCA6J1EjpLPOnO8HIkadfmlHegKTG4Asf324N5LpVqaNNSR0zD8z9aX4nWHzGlMZpvZT
         Gh9A==
X-Gm-Message-State: AOAM530047HFWSkapiIileRDP11mEszZWAZcevCP5ny4nsjHHyBjgETQ
        9G7nqNEBcSzfBz/pL3klQ4s2CXZxK4S7piLcWzN9yvymfiiH7LhJe/oaY9Ln9TnDt0Z72Qx2thX
        obONe8jVweg5zEdUnafor
X-Received: by 2002:adf:b306:: with SMTP id j6mr4386123wrd.279.1601041138398;
        Fri, 25 Sep 2020 06:38:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMMui3Q86Yx0gtlzb6PkZWb198OJdAzb33q21Gj9YeeD2WQ4vt6W/g27Ep1SJ/0zMeShzxZQ==
X-Received: by 2002:adf:b306:: with SMTP id j6mr4386103wrd.279.1601041138202;
        Fri, 25 Sep 2020 06:38:58 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id b187sm2976704wmb.8.2020.09.25.06.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 06:38:57 -0700 (PDT)
Subject: Re: [PATCH 1/2] xfs: remove deprecated mount options
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
References: <20200924170747.65876-1-preichl@redhat.com>
 <20200924170747.65876-2-preichl@redhat.com> <20200924172600.GG7955@magnolia>
 <be017461-6ce9-1d64-51d6-7e85a3e45055@sandeen.net>
 <20200924174913.GI7955@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <2ff5f20a-88ca-5822-6497-ed3c486d794c@redhat.com>
Date:   Fri, 25 Sep 2020 15:38:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924174913.GI7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


 that handled the !IKEEP behavior.
>>>
>>>> +		return 0;
>>>> +	case Opt_noikeep:
>>>> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>>>> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
>>>> +		return 0;
>>>> +	case Opt_attr2:
>>>> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>>>> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> 
> Side note: shouldn't this clause be clearing XFS_MOUNT_NOATTR2?
> 

I don't know but since nobody complained so far and we are actually starting work to remove it...I think it's safe to ignore that...?

