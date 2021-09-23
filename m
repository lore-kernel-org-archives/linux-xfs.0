Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF21EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 02:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976B1610A0
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 02:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbhIWCoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 22:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238859AbhIWCoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Sep 2021 22:44:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708A5C061574
        for <linux-xfs@vger.kernel.org>; Wed, 22 Sep 2021 19:43:24 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c4so3055309pls.6
        for <linux-xfs@vger.kernel.org>; Wed, 22 Sep 2021 19:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elN7awc6gWmeMUdqtQ/rOVdFGCBOg/t2NxL8J2A2fnc=;
        b=MeywCDsvxZlpwY7GdUX7AQluv4nBgEmHJQEfWEvIPHf5oIJoxez8Ut3IXkFVu7poO1
         Vjy/pa3z77mj//RwNhEj5GGMb7mtq/x2f+lZbTluMqMcUMCehnmUXvi1F54HrEOx61P1
         mhSL9dJJ0fK4xc9QYVAlb6GGW4sBA+UksN6VoQTpuvoJMiZtWgOjg0x7NBT5J9jFgnJy
         plVbaDvzOALDswA3FX6SeJxselmM6niGD1KJgejEajgRaiwyf/gfB+hBgjDrhc07zG8Z
         ivyQ49a+AyDK55jnN+W9NC4i4awiwBdjeJ9bMd4lwFh0pU7JBvWgKgnq+BILAjEtne98
         wuvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=elN7awc6gWmeMUdqtQ/rOVdFGCBOg/t2NxL8J2A2fnc=;
        b=fP3U7QWEFbOWtwwexuidkNaDnC79AZMi04yC/lVP8BNuKIr/PguKTubSs3BMDQR/iD
         rLGEc6xn+k+1AK6jHUPEoUSYppBxQtCe+GfnP99mb4Fynj2nHy8stY1eR8b5QEV2JK7m
         4sycPGqpVuP7q0jlr+YhwJQD2b0NBGTICIcFy6cyUelri5eelw3mkJSWZ96ZNEITJSSQ
         NXQGjgjRA7ppic4MHMFE6bJMy7GNsEW9ci7Bbf0e4waM5VApSHFcuAaLp/OlyQ553vhh
         dN561Nk2t0tKKj83a9vxCSlN7FArMRLxiyITq8yo23oMx0npJxnXmZRWuVuHvW02hgjd
         0b/w==
X-Gm-Message-State: AOAM533Boum5p+v84VSHF9y8LAmssKNR3PA9gEiSADauQjGAJHoVNSdO
        bE2/9Ln507vuxklcLhONPHNySWE6jYB1LtO3SvVrGg==
X-Google-Smtp-Source: ABdhPJxmIiqliK3I+UWfcTYO5YNeMCxkNf3jXnwWu2XLmzw4mJJIeliFlYjsg31pHnrVSxYkpv3VVHxxNquz3oBPQZA=
X-Received: by 2002:a17:902:bd8d:b0:13a:8c8:a2b2 with SMTP id
 q13-20020a170902bd8d00b0013a08c8a2b2mr2072459pls.89.1632365003823; Wed, 22
 Sep 2021 19:43:23 -0700 (PDT)
MIME-Version: 1.0
References: <163192866125.417973.7293598039998376121.stgit@magnolia>
 <20210921004431.GO1756565@dread.disaster.area> <YUmYbxW70Ub2ytOc@infradead.org>
 <CAPcyv4jF1UNW5rdXX3q2hfDcvzGLSnk=1a0C0i7_UjdivuG+pQ@mail.gmail.com>
 <20210922023801.GD570615@magnolia> <20210922035907.GR1756565@dread.disaster.area>
 <20210922041354.GE570615@magnolia> <20210922054931.GT1756565@dread.disaster.area>
 <20210922212725.GN570615@magnolia> <20210923000255.GO570615@magnolia> <20210923014209.GW1756565@dread.disaster.area>
In-Reply-To: <20210923014209.GW1756565@dread.disaster.area>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 22 Sep 2021 19:43:12 -0700
Message-ID: <CAPcyv4j77cWASW1Qp=J8poVRi8+kDQbBsLZb0HY+dzeNa=ozNg@mail.gmail.com>
Subject: Re: [PATCH 3/5] vfs: add a zero-initialization mode to fallocate
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 22, 2021 at 6:42 PM Dave Chinner <david@fromorbit.com> wrote:
[..]
> Hence this discussion leads me to conclude that fallocate() simply
> isn't the right interface to clear storage hardware poison state and
> it's much simpler for everyone - kernel and userspace - to provide a
> pwritev2(RWF_CLEAR_HWERROR) flag to directly instruct the IO path to
> clear hardware error state before issuing this user write to the
> hardware.

That flag would slot in nicely in dax_iomap_iter() as the gate for
whether dax_direct_access() should allow mapping over error ranges,
and then as a flag to dax_copy_from_iter() to indicate that it should
compare the incoming write to known poison and clear it before
proceeding.

I like the distinction, because there's a chance the application did
not know that the page had experienced data loss and might want the
error behavior. The other service the driver could offer with this
flag is to do a precise check of the incoming write to make sure it
overlaps known poison and then repair the entire page. Repairing whole
pages makes for a cleaner implementation of the code that tries to
keep poison out of the CPU speculation path, {set,clear}_mce_nospec().
