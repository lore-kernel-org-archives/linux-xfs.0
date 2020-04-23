Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618A1C2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 06:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D82421569
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 06:24:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sCgyIRSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgDWGYE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 02:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWGYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 02:24:04 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CA8C03C1AB
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:24:03 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w20so5219544iob.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BIoovRNBf12RJLUeAx6kjmrpFoJhjBiurX5bEozikr8=;
        b=sCgyIRSg52hDDzME+aw4L950oRL8HMIqSxvSa8cBua0Qo5UUefvJxRQF4gj+peYeKk
         xYeq8FQp4OAum6YdL/aVWQja4dViSoC+V4qmsAqab/4Xso6orCcBGzOY2e4/6Gc7gUuW
         pwMHbax0nDDHH/8lCEzIJ7lwR2hTyDM144tj6thhcamAZ4nM0rx+zreLsqkgPRz2YhF4
         D1h80w7a2Y99xaaSq0Q9H0ffeCf0V5YTLutQ/AqmS8t2rcdI4F1m6qlEa83zry5iTqR4
         5sx2f1BzVPOtp0HFnzJcjJ0yXw7auEUtSPci4cez+VKJVJUr8+xTQERhT50jbMGozIi7
         nUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BIoovRNBf12RJLUeAx6kjmrpFoJhjBiurX5bEozikr8=;
        b=FuiTHO0mk/qaT8aJfP2zZ5IMuVy1BG62GpMARZLDqWnH/BHAiZF707Iur5oLbvzXw7
         oGAauZBZLHZY8gFKqHrvB9yrQzjVNAMQrTQAmIbSYMkzSfoO5jd/zEmWxYeUJOhEGzWX
         iqQCrm76Du71b2W365l3XbFunZk5nxORxSHnGpOdZHQlgs3jpgbg49//lX5cAZclSxeB
         2XSMP8uq56VjsTik+KiWhxBEY35AhsKiaRO3mXBT00hGlw5EBsapDICcLvzOugI/Patl
         zMYxYncJYL53LG95pjI0JdDs/54e8Wv7rIaHm9GBEmBvhQQnrqqiyBt7pK+1EhBO0/Ph
         m5tQ==
X-Gm-Message-State: AGi0Pubp78tbg5t7WBCOeUJuhe2KnyHoxPGY5udIVflFn59gVA/RolRe
        MxdHqkMagYJ1lfeKm8ArgHgZif9SBzp2LG5Uz1E=
X-Google-Smtp-Source: APiQypKBCGki7eWb+CsAXyHlFl6Rwcxb9c0m/obC0h3+QHcrHlroETvK5c2J2GVvj9DcS/9GwY0IX845pvS9TymHAPo=
X-Received: by 2002:a6b:7317:: with SMTP id e23mr2279307ioh.72.1587623043045;
 Wed, 22 Apr 2020 23:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200422230307.GH6742@magnolia>
In-Reply-To: <20200422230307.GH6742@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Apr 2020 09:23:51 +0300
Message-ID: <CAOQ4uxgeVZ8AYB-a7fXhKgh1GfCSfJL761a=Yot0jp4M56z_KA@mail.gmail.com>
Subject: Re: [XFS SUMMIT] 64bit timestamps
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 2:03 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Hi all,
>
> Here's a thread to talk about the remainder of 64-bit timestamp support
> on XFS.  I have a series[1] that redefines the inode timestamps to be
> 64-bit nanosecond counters and decreases the accuracy of the ondisk
> quota timers to 4s so that both will last until 2446.
>
> --D
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime

This looks great.

What's the plan w.r.t. enabling bigtime on existing fs?
In the end, it is just a administrative flag saying "point of no return".
Everyone do realize that fixing y2038 by requiring to reformat
existing filesystems is unacceptable for most of the deployments out there,
right?

Thanks,
Amir.
