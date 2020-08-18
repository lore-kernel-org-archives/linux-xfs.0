Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBE7C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 06:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06F7720829
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 06:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TzrQwHrc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHRG0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 02:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgHRG0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 02:26:08 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A256C061389
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 23:26:08 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id k4so16666211ilr.12
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 23:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wv/n237I4Op9HVt6SUY20QEa5681VZwiD7ulJ+uIwH8=;
        b=TzrQwHrclrfdg5WAjPjSlz2ar4u4rM0Ewki99ty77zVXXieeSouXsRSGUhYpAN+2lH
         +pb7C+ZISJMlM384MGttABIKT6XvwKBm+8REEhsqSjL5+Zr+dyN1WvViBfZL5RRnMnGe
         ZvIpRKiEENLMN57cUIHMCvGjeQRGmwsqVNm3t+nZnjZ/HdaZym/I7Vz1CUDC5PTsUugm
         mvovDC82VEBRxQLyotvgjiy7UX3aVPC7YoD0GV6NIuawJ45ZiGEmva2Y0jLtE8UP0gGw
         pH4pZx7rHRrkumWcC0S2I9nkstEhySptXTZ0dyOwgZafcxyusHpfchaH05wnBTSBNC0U
         elGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wv/n237I4Op9HVt6SUY20QEa5681VZwiD7ulJ+uIwH8=;
        b=Q49EDnYR+9Z+r5+WToa6qHf7hSSscwXAHYd74OoiksufolAG+DhKcdfSSjmiYA38B7
         Pp9VVeaVbl8mV3l29am8wbo4L76JAfZS+OqmqLm+aFtVJhwN9xwTQF3E4M/Hmq5e8qLo
         zgnqM7WygnLfHqhfPgAViUuJKYi04DanZ/13McQ2DKjLLclbhdBOiFwp/ABESlYIRQNx
         LDE60INn/uDoatzDUt4kVSJefGFPTrysIcXBMOBI7JXhvIpp/mLVHQ49oe6vN9WUA/C5
         coQr8Jai/BrI4C6dkCcC/LbZDusDh5dOoUwdlNnzfeCqqkXgScFbBexvTsNMpNJldt9N
         vzeg==
X-Gm-Message-State: AOAM533VZ7QCbfbScSj/7W1sLACxOT6t8x6vahjA/DXMi55dOyfenkHq
        3ftwR7hWeTeGVJzs7Nn83GBCNT3oxLc0E86+Okw=
X-Google-Smtp-Source: ABdhPJzP0otxq16x5duW341G/A3wcdwSyEgAOiY90+11ukN6a151vSyNbRMRA4GmQc1a76syEe9UMHV2ccH4h7+Depk=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr17106755ilf.250.1597731967886;
 Mon, 17 Aug 2020 23:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770501455.3956827.1205192443311495980.stgit@magnolia>
In-Reply-To: <159770501455.3956827.1205192443311495980.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 09:25:56 +0300
Message-ID: <CAOQ4uxhaBd9FP+1LwDwLF-CiO7VozFLC9i2FE3+VHOHRVSTJXg@mail.gmail.com>
Subject: Re: [PATCH 01/11] xfs: explicitly define inode timestamp range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:56 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Formally define the inode timestamp ranges that existing filesystems
> support, and switch the vfs timetamp ranges to use it.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
