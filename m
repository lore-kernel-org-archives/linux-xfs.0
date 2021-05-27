Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2300DC47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 07:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF4AF613AB
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 07:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhE0HmZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 03:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbhE0HmY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 03:42:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25431C061574
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 00:40:51 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id f22so3027873pfn.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 00:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=gSL0m5GAw7+F24NGrsk6x9ot8AxkfRKtplSdlJafuX8=;
        b=ozWPR2fz/OSn3KlbFOhRr9pP7P8J5gfkBtz5BfncMuWEpGVmg3mSjaPGZ0PqZ+QY9O
         m3XmwDuMuG4MvJ/athw8dL0041hEXoqakq8ZhWxwEb03NL4sA35I7DTj6Xq6u396dgAm
         yWw4KSGPljn9HA67srghz0atJdOP71ls5VdfyqSGV6IYogOumZPVeeUFTGgEdo5HZElf
         0a7yshlPOQinel1qSkLUY//UXeOU3RzQHVwWUcxzokIYn/1Oc8CZfvFpCUtPCkdvn/Il
         5s4XQJWUMTB+c45krLqodVNiYCbyokcRWUAVa1KRvvw5Udm3Ysnh8Gp81UX+92CRPV1x
         kCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=gSL0m5GAw7+F24NGrsk6x9ot8AxkfRKtplSdlJafuX8=;
        b=hliyJEQ0DpDpnYquj2gpHtNpJ+DkV4mv8l2RS9YiJ6V5yw7ZJhJbTfKUOQH3yWKQOz
         hCrFdJWCq1fuWLb6OuefOkEEkNgF3BD6eV/jfOP2kRe55TfTxoxihee+yyvZgvWOBN2J
         AbFsBzRV+k+NVTAoInyzimDs9E3DPeFrighIwWBavkAC2lpaBYtNT/p3gn8DG11fGsy/
         woLBLYqCuP00A/X9wJi9093OOZB5jSejkFX3IRXeO6FrdRlDiBniIWOf2mdtKF49TFE0
         4dCOydmALcajduu75Y5DZmbavN3Nd73SvWrcM2+tfSY2yvS3nuRQxkMhSIGSEbABVeFc
         lFRg==
X-Gm-Message-State: AOAM533F763eXlitlag3M7CgpTqMXMvwO9M6InHJp7y5TkXYR+yLQ7NI
        afgmycsZX0gEGSdYhTWt1i/f6xl0t1iLsA==
X-Google-Smtp-Source: ABdhPJzb80h33J9Bxpe7PFWMpmNKt1OQDFAhO1MyZAhXejwKbp0DQpJHmyMC2HuBH6q45ShIZfOaFw==
X-Received: by 2002:a05:6a00:134b:b029:2bf:2c30:ebbd with SMTP id k11-20020a056a00134bb02902bf2c30ebbdmr2501029pfu.74.1622101250487;
        Thu, 27 May 2021 00:40:50 -0700 (PDT)
Received: from garuda ([122.171.209.190])
        by smtp.gmail.com with ESMTPSA id gn4sm1130640pjb.16.2021.05.27.00.40.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 May 2021 00:40:50 -0700 (PDT)
References: <20210525195504.7332-1-allison.henderson@oracle.com> <20210525195504.7332-14-allison.henderson@oracle.com> <20210525205242.GN202121@locust> <3d603e99-3f19-9138-5aa2-a659fd571057@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v19 13/14] xfs: Remove default ASSERT in xfs_attr_set_iter
In-reply-to: <3d603e99-3f19-9138-5aa2-a659fd571057@oracle.com>
Date:   Thu, 27 May 2021 13:10:47 +0530
Message-ID: <87fsy8oc8w.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 May 2021 at 23:43, Allison Henderson wrote:
> On 5/25/21 1:52 PM, Darrick J. Wong wrote:
>> On Tue, May 25, 2021 at 12:55:03PM -0700, Allison Henderson wrote:
>>> This ASSERT checks for the state value of RM_SHRINK in the set path.
>>> Which would be invalid, and should never happen.  This change is being
>>> set aside from the rest of the set for further discussion
>>>
>>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index 32d451b..7294a2e 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -612,7 +612,6 @@ xfs_attr_set_iter(
>>>   		error = xfs_attr_node_addname_clear_incomplete(dac);
>>>   		break;
>>>   	default:
>>> -		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
>>
>> ASSERT(0); ?
>>
>> AFAICT the switch statement covers all the states mentioned in the state
>> diagram for attr setting, so in theory it should be impossible to land
>> in this state, correct?
> Yes, that's correct, so ASSERT(0); should work too.  I am fine with
> this change if others are.

"ASSERT(0);" looks good to me as well.

-- 
chandan
