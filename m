Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075A3C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4C9022BEF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qwa3KLxa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgHROlj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgHROlh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:41:37 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC8FC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:41:36 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z6so21391666iow.6
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tFMz6GjuXPpMhflPNjwaILx9NjtHdBGFN3e3amKkV1s=;
        b=Qwa3KLxaUl2xyhb7O6S6PlYE+k49m2jdGf3CoZTeAHdtXAf4/2OoHVFwWanUZTm6xm
         fot8Mq+BfbpNdPTsaae6nZoeKN2xIjAePCh/OYPMboMlH0UC7l2R3wotFMHV5jga84q6
         +Q6Hb/6ryZ6qe5rWX1Cg5TWFLHrmDELEezMhQqfA1P7lr0U49qrtcW6K0TsdxEXvEXy3
         aFD8X9dVXlp6q5bQORRW+YFw7Z/veQoRhxkJ6HGxi5E4Mbhl7U4izFqoM8e/xyTUcuud
         8j1e3qegoq6o8x1azl/e9lfn9Jno0P2BHbD6UIhwB5tdcIKl70dqd+OnmHQMak18SdW4
         XEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tFMz6GjuXPpMhflPNjwaILx9NjtHdBGFN3e3amKkV1s=;
        b=NJt3wrguck8IJjV9zYkQQ0R3pRxOYC5DxzsMGCcRmPO5uuhLQdUNShFrvU/3N/5gZ5
         a1uKn7XjQq16vWGCqmodXSvC0U8SZL0iBLz5lTbXxxnJZPc0LJW6Ld7h6pncgUP1R+JF
         E9ZfBSrpwhSHrXXjIGoIiFAZJhdc7Ky2CTOuNR3jN4JfL3Pz+Fl4QOR04q4pW94thYet
         OSpja0ZAtGfrTDGgtAhxnGg8+6dXquImQ0+zhf58Agx+LCG9FMNTWDrJx4qig9Vwe8Bc
         jdIUoD1qK4WjoRPZLqCalkWFdsJmu86boy9YejFv77DSgGyeNMpnfWcCPQo5aRIV4LnB
         mAPg==
X-Gm-Message-State: AOAM530/xj3mEfaJHwm+abQvK33DZALmYNv6GTqyHDovuU2Jn8KtvvlU
        zKFFE8z9FFEJ6wYusPW4ZjxkLYx7vwoYQjkUdYs=
X-Google-Smtp-Source: ABdhPJxeCunBV0GhQVAIJW4oYf6Ediu9fK7ct9mcGUxcczPqS10CG3+iCX5fRAuQwXFpL/SzgUXNkXVniyExawyitIE=
X-Received: by 2002:a02:cb89:: with SMTP id u9mr20108529jap.120.1597761696278;
 Tue, 18 Aug 2020 07:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770520255.3958786.18344458914688900638.stgit@magnolia>
In-Reply-To: <159770520255.3958786.18344458914688900638.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:41:25 +0300
Message-ID: <CAOQ4uxgr=D78Eu61kucNLqzub9FsdMBwi76TdQ-NDmJ4+q9_-g@mail.gmail.com>
Subject: Re: [PATCH 11/18] xfs: refactor quota timestamp coding
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:25 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Refactor quota timestamp encoding and decoding into helper functions so
> that we can add extra behavior in the next patch.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

fine.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
