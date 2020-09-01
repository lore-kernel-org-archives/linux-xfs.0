Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DD1C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 13:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF99207BC
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 13:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MwdzzmLF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgIANAa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 09:00:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727051AbgIANAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 09:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598965201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6RdzeKs0WLb+HvEMTVay7AQ7Ox4Alb+u2f+jmXPq3A4=;
        b=MwdzzmLFZkWPEYAabigBcEZVEFOH1EaDsQzXVduM/HsoX4xfcVF30tAFQ0Vb64mGNZ8sie
        okGbfgWfIwztxMz0ELSRNZvAOOBLT033J/ZmYTCr8QxSJ8dguTMwptX6qUxQAwAEjTpZHl
        VS3VtvIEw1h0E8hIKSD8Xewr5wtSoGk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-x-DVEq-yMkaEGD5A1MoF1w-1; Tue, 01 Sep 2020 09:00:00 -0400
X-MC-Unique: x-DVEq-yMkaEGD5A1MoF1w-1
Received: by mail-wm1-f72.google.com with SMTP id b14so371751wmj.3
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 06:00:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6RdzeKs0WLb+HvEMTVay7AQ7Ox4Alb+u2f+jmXPq3A4=;
        b=ZkcqKrB3Zj9j2toLWmjF2YxChZMJy+eqO7Cx2zSIqySD7ZEO+NNEIAcD4O7ZvxpwMT
         pcOTkANhc/1oZO8Zbfyce+1IZKhbnlU4Sd80zGpy/rtE0P2E0Zt5qFUeJITUmoi8O6Go
         0B5z4+QI2i/Dcqp2MNFFuQueQbVrML1Um68ux+MZieHdjAhlXEyIc2TVva2SHKy/MB2l
         coNRKYuAzRsZ2gEZ2keHFpJVSboUbpoW9/R5FQxoW2gJMGkZAxcoRnXE9UYH7f03vK7P
         HkDXDDW6yXgg6tXgPCgJyAaOB/ldnQmi8CNLRu2rbRlms3raBPVCHjhrHS2/n1sjF6pR
         GwnA==
X-Gm-Message-State: AOAM530PTgqL5yPtMwXQX4aQA4IDcKKsMHFI0GZay7+3rUIbyB0IbyNe
        7b5GLlv0y32lEY2EfJSahVrIPV9lF4TCYiSrLiLHYscrO0NV1x00j2CEb+hpmNgP1czULrLzZPE
        tOzeYufXkkoGYJleCnekj
X-Received: by 2002:a1c:b143:: with SMTP id a64mr1630485wmf.43.1598965198931;
        Tue, 01 Sep 2020 05:59:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPTJBfknR+aJyUOmUJD34v2V+kmw9+HTzyeGpfgVDa1C64SWid/X49wJuv7I8TSGLBwBXKdw==
X-Received: by 2002:a1c:b143:: with SMTP id a64mr1630478wmf.43.1598965198796;
        Tue, 01 Sep 2020 05:59:58 -0700 (PDT)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id s11sm2105916wrt.43.2020.09.01.05.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 05:59:58 -0700 (PDT)
Subject: Re: [PATCH V2] xfs: fix boundary test in xfs_attr_shortform_verify
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
 <20200826164420.GP6096@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <b8c1482a-4efb-0208-d750-f00dd3c68003@redhat.com>
Date:   Tue, 1 Sep 2020 14:59:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164420.GP6096@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> From whom should I be expecting a test case?
Hi,

I took the task, I hope it will be done soon - I'll do my best.

Pavel

