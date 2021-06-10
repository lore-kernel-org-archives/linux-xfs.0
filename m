Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAACC47094
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 12:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92E961184
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 12:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhFJMog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 08:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFJMof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 08:44:35 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720AFC061574
        for <linux-xfs@vger.kernel.org>; Thu, 10 Jun 2021 05:42:23 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id l12so1244067uai.0
        for <linux-xfs@vger.kernel.org>; Thu, 10 Jun 2021 05:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ERGvPKyejnfegUXiUI5TBALLR98HuWU+7/Q+tACPbYI=;
        b=bWmonaOQtQnoMrqggNjQmbBLp/OFsefkhaXRpT3N30oDxasxyxX5+zHqOhyxg8TwQ1
         9WhDWldZuNugQzNq9CRVa79/7odXcgVZfZJpa4jozV3UwwVJh+rViZAq1j+cqvO83+lk
         Ul0lp34cK0STCoHisDcJwkiJqPEl1W1Jca9Ac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERGvPKyejnfegUXiUI5TBALLR98HuWU+7/Q+tACPbYI=;
        b=L8zR778nq2Zs55WwJ3XdgW7lq2yyyGxklOi8T5niVHkBT+vvgHeBGKzaGLFIyxeBgC
         Yp0YvgVh53fIT1RiykCyn8Y+Do6O8gnby5um7pqQ+ds5Y2PvHivWl9OOxDp0NVlbBsbE
         Cmf+rYdHsSG1Z2Rhror3LX/pLXLQPCytkiHwmm75YhH8hr79kBsozOsqCvEyFpYtsp9n
         DkP5RjnAByI9U//jctuI1BMv7q9frHA29eYzGQWTJCa/DzYE+cKCfNrwsvpNsaVg55IF
         7TvvWqa/i9U49V9id3Ge7569llXpnDh3Ucr4bS2qSiht7boXcgTtO7NdQnk4tXsPJlxc
         aNFQ==
X-Gm-Message-State: AOAM531DYPgs2+TVeLq+4VP5G+tRN7jK5h3fvQIwavica2xFNjtLC1Dc
        FMolKp45ansv1dxuG1/k31BD4zG6J4esn+cFxRsHxA==
X-Google-Smtp-Source: ABdhPJzSnBnKZyOmEQg1Mlk1J3k9vxKYbX0hKrYXjQBdDrHZwFo89gBvp5Cl9ryn+jRW8T0jKkHsp9O4DmV9/7gYf0I=
X-Received: by 2002:ab0:2690:: with SMTP id t16mr4105093uao.9.1623328942641;
 Thu, 10 Jun 2021 05:42:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210607144631.8717-1-jack@suse.cz> <20210607145236.31852-12-jack@suse.cz>
In-Reply-To: <20210607145236.31852-12-jack@suse.cz>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 10 Jun 2021 14:42:12 +0200
Message-ID: <CAJfpegtLD6SzSOh0phgNcdU_Xp+pzUCQWZ+CB8HjKFV5nS3SCA@mail.gmail.com>
Subject: Re: [PATCH 12/14] fuse: Convert to using invalidate_lock
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, ceph-devel@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mm <linux-mm@kvack.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Ted Tso <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 7 Jun 2021 at 16:52, Jan Kara <jack@suse.cz> wrote:
>
> Use invalidate_lock instead of fuse's private i_mmap_sem. The intended
> purpose is exactly the same. By this conversion we fix a long standing
> race between hole punching and read(2) / readahead(2) paths that can
> lead to stale page cache contents.
>
> CC: Miklos Szeredi <miklos@szeredi.hu>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
