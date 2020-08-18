Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950D5C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6208220786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SnWkgXKo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgHRO3O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgHRO3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:29:11 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB72C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:29:11 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p18so13940029ilm.7
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ICWkQngbJ8WdZFN90E568sM549hYN6gLEzILD8B+Qys=;
        b=SnWkgXKodqI/g4qdlnuf1dmEPqPAbjT28eJr02R3+fNwAhEfHjETCqjBHhmqw4xEVc
         ZK+vihJltUe50eg/yMK8mh26TnnCUbZNqTnrBFJMRnWpQwQPm/nVkuf6f56J5hM5W8Mx
         ZLCxHEwjIlYg591I84W0Fqa3X1AOCC8cIh8bqZMQYPoy8NAaXywTWH0lgzZl3qhILqo0
         7aBIXjBIqObZkh7TJLPCXydeE5Xha0aNrpw+e6UtWLTa6zIJK+gwZlLVtrq/hnAnYxvH
         rzObKO8BVC3vEg/OQymk8aHXmX6ewCa7lyTQKt9iRxdQySVFQ5oaynXlDx8ZNVhZK5KN
         WDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ICWkQngbJ8WdZFN90E568sM549hYN6gLEzILD8B+Qys=;
        b=oRD7Qjj7qY3E8pLl/ONYbnViz8fIMdjjTAUdQHjDjTbKtig/+HPN8DPSPqnXHPNE3f
         fBkPQONB1iFcZVQbjjnXy9i9Bbz80cRDOLAnOI8QOgcgFUCN+au94a5jAN781U7wrc4X
         R5YKHUbsFEETjaHUqCeMJ5U2wNU4bR4aesJ0AhMlbWUS0Vs46i8iwWWVUyQb1zmQAY9r
         8LjguMh9E1oyrKwR+AqjcOTfCzZXnM4UBE5C8OvmP3w4OADrXXJn9qn+ACDac36A5pIi
         SmJWT0EZsMC1/g1m0bZlvxXeltyZUTulCMfUafJXh8+PqMgkWO7Ky7K2YUfQCnhV7AcT
         eVbw==
X-Gm-Message-State: AOAM532HcNiU09F48eiZpHcv+JIQjq/MZRAFZlA5ijXQZB+gqXZE8H1p
        X1hAYG2xG0PIhH14s3aNgBePqZ+/ry3PbLnKjgk=
X-Google-Smtp-Source: ABdhPJyllY5Klg+mCAW3FIdd50BY+1AkxNumuDAlKqRsowLfp469I5bwbYgy+Sfg2S3BdFQOfXNuBh2BMvuG6Yy75sg=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr18732457ilj.137.1597760950625;
 Tue, 18 Aug 2020 07:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770517786.3958786.15888272976594846679.stgit@magnolia>
In-Reply-To: <159770517786.3958786.15888272976594846679.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:28:59 +0300
Message-ID: <CAOQ4uxhPxYXhqA=C1v8fEFjJZ5LC0yq3hHA3ZfPtYrGB5uPdGg@mail.gmail.com>
Subject: Re: [PATCH 07/18] xfs: refactor inode timestamp coding
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Refactor inode timestamp encoding and decoding into helper functions so
> that we can add extra behaviors in subsequent patches.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

ok.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
