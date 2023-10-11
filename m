Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A683CD6E5A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 11:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjJKLJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 07:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjJKLJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 07:09:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E571FD5
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697022403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U5ykf39aqWNOUh8hPUCI/eBpTU0D+3eGNJ/G++fJXuk=;
        b=dbFBEO+RD/SA0KSLU9DE0z8PzRpmcqynKz1ysGemRAV2cTmOm0mzrU9MpchVQ7dRe+k1+Y
        KNhoRLhMRofFWjH3ZnTSLgH49mmmL+3MPIUaeTrDHNaLh1c9ZmuUaYrSROokrqGWCAJSbt
        bB2VF1Hb44p1BDlZA70LqJxtrNgqNSA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44--qrtzSYbOSCrsDrZ1w6YNQ-1; Wed, 11 Oct 2023 07:06:42 -0400
X-MC-Unique: -qrtzSYbOSCrsDrZ1w6YNQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-537ec211f15so5396679a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697022401; x=1697627201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5ykf39aqWNOUh8hPUCI/eBpTU0D+3eGNJ/G++fJXuk=;
        b=CdunP2hiK0wIyo5DoPZX5jel5mGsXblgLvQtt3dusEMaAnFzhlVo6jPZX7NS3TXlPA
         dGrgCuRQntGwmxBQcUqM4JvsZE9oEDWW9QfDY3EGK8vK2BAC7vhygynJlytaTm/0u1Ya
         OmSj3vsQMcP6OePWbZ8fJr8osSb0OeGz1msnh3I0Pl3QRhJGk2IhyD8NHgwTSv9FnqNb
         3vcote0JI5WBZCVKFq6nFPkLhOLgcGqNWWEjy6/r3Hmk4XE5iuf4cERQKm7qXydLK3uK
         ywx0TceleK7GtSa6YajwYv5CkhiRIOjyiHAitPztfHJAM0z3nYEUP68rNWezUx0flxl6
         LzDw==
X-Gm-Message-State: AOJu0Ywlkqr1l3zpGAD7Gn/lJBdGoMWQmgg/PejJVVXQz1WHlYiYzyl2
        lWn5jamvk3XFbqAuA+J/j4tjTtVajdJMbt+Mm9Y4LMBuAw0Bzq3qVWwbM7W6nSJWgv+Tcg7bUgB
        0mKmJzH2ds8gA75uDIio=
X-Received: by 2002:a50:ee0a:0:b0:530:4967:df1a with SMTP id g10-20020a50ee0a000000b005304967df1amr16923181eds.17.1697022401082;
        Wed, 11 Oct 2023 04:06:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSGYnkltW7whS6Jj12+S7pY5s2T9PH4UQibdHpglYLF1SUbXTX1V2fcfwWWQglY7dJbEAyjA==
X-Received: by 2002:a50:ee0a:0:b0:530:4967:df1a with SMTP id g10-20020a50ee0a000000b005304967df1amr16923158eds.17.1697022400685;
        Wed, 11 Oct 2023 04:06:40 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7c44e000000b005361fadef32sm8628821edr.23.2023.10.11.04.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 04:06:40 -0700 (PDT)
Date:   Wed, 11 Oct 2023 13:06:39 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 05/28] fs: add FS_XFLAG_VERITY for fs-verity sealed
 inodes
Message-ID: <bwwok7q2mf6loildyudbuwazvojz5e4aiqhnn4ptgmno4w2wym@xrvlvhk3u2hy>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-6-aalbersh@redhat.com>
 <20231011040544.GF1185@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011040544.GF1185@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-10 21:05:44, Eric Biggers wrote:
> There's currently nowhere in the documentation or code that uses the phrase
> "fs-verity sealed file".  It's instead called a verity file, or a file that has
> fs-verity enabled.  I suggest we try to avoid inconsistent terminology.
> 
> Also, it should be mentioned which kernel versions this works on.
> 
> See for example what the statx section of the documentation says just above the
> new section that you're adding:
> 
>     Since Linux v5.5, the statx() system call sets STATX_ATTR_VERITY if
>     the file has fs-verity enabled.

Sure, will change terminology. Would it be fine to add kernel
version in additional patch when patchset is merged?

> 
> Also, is FS_XFLAG_VERITY going to work on all filesystems?  The existing ways to
> query the verity flag work on all filesystems.  Hopefully any new API will too.
> 

Yes, if FS_VERITY_FL is set on the verity file. I will probably move
hunks in fs/ioctl.c from [1] to this patch so it makes more sense.

> Also, "Extended file attributes" is easily confused with, well, extended file
> attributes (xattrs).  It should be made clear that this is talking about the
> FS_IOC_FSGETXATTR ioctl, not real xattrs.
> 
> Also, it should be made clear that FS_XFLAG_VERITY cannot be set using
> FS_IOC_FSSETXATTR.  See e.g. how the existing documentation says that
> FS_IOC_GETFLAGS can get FS_VERITY_FL but FS_IOC_SETFLAGS cannot set it.

Thanks, will add it.

[1]: https://lore.kernel.org/all/20231011013940.GJ21298@frogsfrogsfrogs/T/#m75e77f585b9b7437556d108c325126865c1f6ce7

-- 
- Andrey

