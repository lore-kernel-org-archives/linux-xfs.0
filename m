Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D88C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 07:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC54560F91
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 07:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhG1Him (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 03:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbhG1Hij (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 03:38:39 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791B8C061757
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 00:38:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c16so1638646plh.7
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 00:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=aGHq+DeqWO431LBG5Fpsqg47NkqJQtczZggG0Rk7NNI=;
        b=KJ3sjA8bC2BycsRfqyAZg4Qi0VfzK2wKHzCpZjCPdKznyFpEScEUgjUwIGbhunokVu
         Y2Z2i77BUmDEeuLMuDMsKRmf4TL/bf6DKV7EzMsw1r76XMSfm04sDlDdLXe16rL3/AQe
         duqauOWoe+jXq1VBbptXthUYX8fXr4fz/JIcKywyIphs+tLfPn/AwFXWvFc7XFD46L7y
         GfJgbkDUwx2WEpk5FVlROkurseod5ulAsJnZOrlEdJBkvaTlAZ4USRc8u0t/y+F/Zpvl
         MI4f9Fykau4QEkqWLZfuQUe4QUVvmp4PvRkk4opKzOKCfMfsmfmiwRcVNsiPngVVBvQA
         pllA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=aGHq+DeqWO431LBG5Fpsqg47NkqJQtczZggG0Rk7NNI=;
        b=irdwffnJ7NVrotscJab1PtrJYvI7/Ejttij2AtSpKWcMTz+b1RgIOV6Vxldx7Ij3U+
         Ev5eFISkkzlbJaDFrEzK+EQP1ZPp84YOyuSWH2o0z2EwbG5KMtzQHeCtQ48hyMQBcQjD
         zzToX8KETojsoMQ5GPAFh67KBV+z9xhXC8Fq/EYtIrsILTUjvBSmu+fgXkQtl3PMemQk
         frjaTpBHyz5QCVI0GRUcO8kM2BHRMZFAjwFgy3HviairBRijgC6Oc1AilXVNtGZLg9Bl
         LKbQVReMNtCEN2vG9DWSH2jhpYWZl8OYZ9Rl/IGAhdn2Gw9sBCjPIzhHOrG+4Qm1B5BD
         Dr6w==
X-Gm-Message-State: AOAM5333K4M//dBwQ6J5uIDgGlLxIiBN3+bWfC40d1U+TZjGXvLt6gvX
        TSVM55+1HX79txurTx2TW8RY6zUJ50TIoA==
X-Google-Smtp-Source: ABdhPJwiDA4cz6GzuWgAmiJfTbzzs31ZolUd23DyhwXQuvJrIYiXKgYr7VJ2hu+KqhftW0mHBn40NQ==
X-Received: by 2002:a62:5307:0:b029:3a3:9460:2ed2 with SMTP id h7-20020a6253070000b02903a394602ed2mr3915220pfb.5.1627457917963;
        Wed, 28 Jul 2021 00:38:37 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id k20sm5110343pji.3.2021.07.28.00.38.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Jul 2021 00:38:37 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210726114541.24898-13-chandanrlinux@gmail.com> <20210727231055.GV559212@magnolia> <8735ryx5o9.fsf@garuda>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 12/12] xfs: Error tag to test if v5 bulkstat skips inodes with large extent count
In-reply-to: <8735ryx5o9.fsf@garuda>
Date:   Wed, 28 Jul 2021 13:08:35 +0530
Message-ID: <87zgu6vqf8.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 12:53, Chandan Babu R wrote:
> On 28 Jul 2021 at 04:40, Darrick J. Wong wrote:
>> On Mon, Jul 26, 2021 at 05:15:41PM +0530, Chandan Babu R wrote:
>>> This commit adds a new error tag to allow user space tests to check if V5
>>> bulkstat ioctl skips reporting inodes with large extent count.
>>>
>>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>>
>> Keep in mind that each of these injection knobs costs us 4 bytes per
>> mount.  No particular objections, but I don't know how urgently we need
>> to do that to test a corner case...
>>
>
> How about using the existing error tag XFS_RANDOM_REDUCE_MAX_IEXTENTS instead
> of creating a new one? XFS_RANDOM_REDUCE_MAX_IEXTENTS conveys the meaning that
> we use a pseudo max data/attr fork extent count. IMHO this fits into the
> bulkstat testing use case where we use a pseudo max data fork extent count.

Sorry, I actually meant to refer to XFS_ERRTAG_REDUCE_MAX_IEXTENTS instead of
XFS_RANDOM_REDUCE_MAX_IEXTENTS.

-- 
chandan
