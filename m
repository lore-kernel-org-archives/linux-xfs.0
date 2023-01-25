Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1E3C54E94
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Jan 2023 00:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjAYACg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 19:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjAYACf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2023 19:02:35 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F52F47403
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 16:02:34 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso2758327pju.0
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 16:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hi8m5esQc2XU8ak0IXpB/fty7rcJ30felRWwotnUs8g=;
        b=OwZWCuGCV7jqlRnjbWuh5cdIuODdXd9wb7ThROlcP9aNOIDGLc9Xsl7nNOgWi6Hf6C
         yiN0bNNToPob7BZkL4b9YLIERHy5o/ZU9IPywyqRSKW8un0zQOX+2FSWms12FJm7hh0p
         z6gD6W8kwfmjattcX5CZlNNqWfsJVXOonLP/ksH4Ql3qoD2zAb0OKgqpxnEmYnkrmeEU
         d0M94MrgA0OVrQ+K7jxZzKBdun146rtUiYtIcBGkTd05uyHggG/FrAtBt/GXJSF3WlgD
         +NLlO9N32q6+CafSlujhx0ec8Zu01fmeYkUvP05uNivY2I0L+DWDegd6G4/JwYpQ1aQT
         kR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hi8m5esQc2XU8ak0IXpB/fty7rcJ30felRWwotnUs8g=;
        b=bdui/0HIZSMy5XfEQ4c6XEcTa9gOBQx/VXljNz3ZH3071oLeaQCYdIHuKuxFPdqsh+
         dWRZLXd+LwUlwV21eD41oapkIlEMik//Zh1Yk/oHpSo4eBiagXaO+BGE0JEZBh6oHuoO
         ri8laZQSGCt2z6CZo9VPfVgzDaoC0F52Cg+wN2JATDNZZ2m7SUF0Knq5nb82lpcJAOiJ
         1dWeULmvwkGGLUXmgFss3E0IGWjIcwVR41Bt4HSexjlMgvSbZhisFO+ZjSB7l9bj6H6A
         cYv/dpmuwaYRwxpK+evyRbEcvxIkyIkCYuX8jZm0KzmfQDKN9o0zPm8f9ZmE2THB8l/6
         80kQ==
X-Gm-Message-State: AO0yUKXYCQmhFKKkESymMjo41+xBF9BGF77B/1CyViK0cOgIphBvxAPD
        opfna8zj8kC8c/cuUsiiEJsZUg==
X-Google-Smtp-Source: AK7set+oLzvxKVz2I+I+y6l4Ih2jLF35X4sOcJhacVFUxBLzG/8R1d/WJzUwnT4ID10FRegWh+8bwQ==
X-Received: by 2002:a17:902:d4c3:b0:196:1787:9c01 with SMTP id o3-20020a170902d4c300b0019617879c01mr4023293plg.51.1674604953967;
        Tue, 24 Jan 2023 16:02:33 -0800 (PST)
Received: from dread.disaster.area (pa49-186-60-71.pa.vic.optusnet.com.au. [49.186.60.71])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902d70a00b0017f73caf588sm2226471ply.218.2023.01.24.16.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:02:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pKTFD-0076rs-Sd; Wed, 25 Jan 2023 11:02:27 +1100
Date:   Wed, 25 Jan 2023 11:02:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: replacement i_version counter for xfs
Message-ID: <20230125000227.GM360264@dread.disaster.area>
References: <57c413ed362c0beab06b5d83b7fc4b930c7662c4.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c413ed362c0beab06b5d83b7fc4b930c7662c4.camel@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 24, 2023 at 07:56:09AM -0500, Jeff Layton wrote:
> A few months ago, I posted a patch to make xfs not bump its i_version
> counter on atime updates. Dave Chinner NAK'ed that patch, mentioning
> that xfs would need to replace it with an entirely new field as the
> existing counter is used for other purposes and its semantics are set in
> stone.
> 
> Has anything been done toward that end?

No, because we don't have official specification of the behaviour
the nfsd subsystem requires merged into the kernel yet.

> Should I file a bug report or something?

There's nothing we can really do until the new specification is set
in stone. Filing a bug report won't change anything material.

As it is, I'm guessing that you desire the behaviour to be as you
described in the iversion patchset you just posted. That is
effectively:

  * The change attribute (i_version) is mandated by NFSv4 and is mostly for
  * knfsd, but is also used for other purposes (e.g. IMA). The i_version must
- * appear different to observers if there was a change to the inode's data or
- * metadata since it was last queried.
+ * appear larger to observers if there was an explicit change to the inode's
+ * data or metadata since it was last queried.

i.e. the definition is changing from *any* metadata or data change
to *explicit* metadata/data changes, right? i.e. it should only
change when ctime changes?

IIUC the rest of the justification for i_version is that ctime might
lack the timestamp granularity to disambiguate sub-timestamp
granularity changes, so i_version is needed to bridge that gap.

Given that XFS has nanosecond timestamp resolution in the on-disk
format, both i_version and ctime changes are journalled, and
ctime/i_version will always change at exactly the same time in the
same transactions, there are no inherent sub-timestamp granularity
problems with ctime within XFS. Any deficiency in ctime resolution
comes solely from the granularity of the VFS inode timestamp
functions.

And so if current_time() was to provide fine-grained nanosecond
timestamp resolution for exported XFS filesystems (i.e. use
ktime_get_real_ts64() conditionally), then it seems to me that the
nfsd i_version function becomes completely redundant.

i.e. we are pretty much guaranteed that ctime on exported
filesystems will always be different for explicit modifications to
the same inode, and hence we can just use ctime as the version
change identifier without needing any on-disk format changes at all.

And we can optimise away that overhead when the filesystem is not
exported by just using the coarse timestamps because there is no
need for sub-timer-tick disambiguation of single file
modifications....

Hence it appears to me that with the new i_version specification
that there's an avenue out of this problem entirely that is "nfsd
needs to use ctime, not i_version". This solution seems generic
enough that filesystems with existing on-disk nanosecond timestamp
granularity would no longer need explicit on-disk support for the
nfsd i_version functionality, yes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
