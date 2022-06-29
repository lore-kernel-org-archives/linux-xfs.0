Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D187C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 21:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiF2VxL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiF2VxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:53:11 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758CB21AA
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:53:09 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id 189so5603554vsh.2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0G9aG1APDvArWbsJuwxE7Kw7uouTOf7w5sDcFcqUEhc=;
        b=DR1VQQR0C7qrJQpiATJE0rey6Ke06BHXJOCeDp0wXEvzSVoIv3O1YDwXicnLRUN5lT
         vSgRPIgyO3Pw9/KZtrQ1kHIBULAXNRIi9vKbQtOn3JHzFas24kmc0GZRlVEeNdi8ty5D
         InC58oSuPBSk05KKl/wmEBqmtXuUUX0ZdjGPbr4HL+Mm/0fuOipVzKxrAX/fwV1usibk
         n2B63QO5v3GVKBZC9gunFDYgzG+kzixdoQwMyUcC+ZfMC04c3jDM0l+Y18a9RKC2zdf/
         miOSqsGklCOTtTs7nATC+tmZzjmZG+8yLK1W8OUiX9akK0PqbvCKHG+PAkrm/eVfiv/K
         Sxrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0G9aG1APDvArWbsJuwxE7Kw7uouTOf7w5sDcFcqUEhc=;
        b=zFzmUBxa5nWSO9bWlxiF5W6VcpWYfg7V9UngnHSesoYuFPuS9au032nBAidWmUlDVO
         WgzPWrBnNYLkUiD6i3oHR2/eWdIqIwFguVwYAYdnOFNflFD6jLoE0Ub5Mm+s3n7SEb9G
         12W7FGpXC6DTvTMpqndNm/3TcBjBIpUG4uSrZJSawipD9lFf9KjB3cvKH2MGc4KpubQw
         ATJB5i/hEewhBb9F5hDsM0TLUmCRvQDSdmosFqqERvsHE/YgfwYPGZRoCb9vibfFFSp8
         77No7Q3FmKJB6/iClWBX9sU24yuAV/9STbh9IhXYjYdf7X824Ab/bAqcYF9IdC0yxwTQ
         CbKw==
X-Gm-Message-State: AJIora/Al4zctAHyYa8PmmLD7dNFmfIxUWXU8M1DO721BACvwrA3jTEj
        aicDmUpeSutKhRK5OPYOPR7GBPLUiir6bDtBlpk=
X-Google-Smtp-Source: AGRyM1sl8Mxk6P5/vxbExbPw2iXG62QB6O2lCx7WN4NI6etZs2WIL/Bv3spsRDXlUyClFgYRbPbfccAZMhCg2AVKF7U=
X-Received: by 2002:a05:6102:38c7:b0:356:4e2f:ae5b with SMTP id
 k7-20020a05610238c700b003564e2fae5bmr6310713vst.71.1656539588624; Wed, 29 Jun
 2022 14:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220629213236.495647-1-amir73il@gmail.com> <YrzHuqVgvSgj8gP6@magnolia>
In-Reply-To: <YrzHuqVgvSgj8gP6@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 30 Jun 2022 00:52:57 +0300
Message-ID: <CAOQ4uxgjmqB3YGr+tD0G2f-+4aqVoqYBE4sxkbCE3FYTO21nyw@mail.gmail.com>
Subject: Re: [PATCH 5.10] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Theodore Tso <tytso@mit.edu>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 12:44 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Thu, Jun 30, 2022 at 12:32:36AM +0300, Amir Goldstein wrote:
> > This is an attempt to direct the bots and human that are testing
> > LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.
> >
> > This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
> > have their own LTS xfs maintainer entries.
> >
> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/T/#t
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 7c118b507912..574151230386 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -19247,6 +19247,7 @@ F:    drivers/xen/*swiotlb*
> >
> >  XFS FILESYSTEM
> >  M:   Darrick J. Wong <darrick.wong@oracle.com>
> > +M:   Amir Goldstein <amir73il@gmail.com>
>
> Sounds good to me, though you might want to move your name to be first
> in line. :)

Haha ok I can also add a typo in your email if you like :D
I'll send it along with the 5.13 backports.

Thanks,
Amir.
