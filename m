Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2195C43460
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 16:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88AEA61220
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 16:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245415AbhDLQnP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343810AbhDLQgI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 12:36:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98195C06135C
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 09:29:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e7so15793344edu.10
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 09:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ueR+bzUQyBJ6Gmj9fHXIfDenKkhbJd11CuntNjq4ue8=;
        b=Al2PuI8Jtpzy/NwLxwtBoFYmkJnS/LiklYzPs1W31opZKivVBizLwtQrhvdcCOzNgl
         iFR4SpalKqJenVbjbDxeUakPBfXOWawua9ad3aoLoJ6u71vmqNsjc2z07HewEM5RCZnE
         537Yq4lD1OJ7BIDIr0AJhjMl3v314MH/ZEs9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ueR+bzUQyBJ6Gmj9fHXIfDenKkhbJd11CuntNjq4ue8=;
        b=RuM4PAtSr+xx1NjBU/XWpSDmXiwhp1KPio8n/XIe5b2AOdqa+yI9EA9iyUVAWvMs0b
         M5TRROMXuvxQgdD4f1NdomVHObFN4wI5kAEskcPk9tm4OkXqOPITyYnv2PgQKMF7Lwos
         V2QYII0zZ2Agypibc04uVmLODtUZNLN82C8g6S91Rm7rqEhNML4lRf2xBT77nykHfLk5
         AJh4aYIBenKxpjhV/1oBox6tRignhvTUztNU8dM6hlylpEiscNhLXyzGkAQeuKlG+7oj
         v5ytQVKSoGzDkvoS7Fx04FQI9G5aDpuwOwsaellrSgSWBAvNepXkljCDeoOcbvQV6xgb
         bAYg==
X-Gm-Message-State: AOAM533vOJ+/QOVMT1fr08t12TdodyoydDv46YVbQaH7IR/IAvpzzKxV
        b1lZahK6zVEFZT6OjD04IE/+u0jTyr6IzcQ8
X-Google-Smtp-Source: ABdhPJzXFfM5feRy9x2mUcOcSO9uwjKlJsCf5RzAe3qspKDFoartiB82/vhkwQJbaabiOfPM34GtFA==
X-Received: by 2002:aa7:d3da:: with SMTP id o26mr19969837edr.147.1618244958155;
        Mon, 12 Apr 2021 09:29:18 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id df8sm7342616edb.4.2021.04.12.09.29.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 09:29:18 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id sd23so12633882ejb.12
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 09:29:18 -0700 (PDT)
X-Received: by 2002:a05:6512:31c7:: with SMTP id j7mr10731751lfe.41.1618244634563;
 Mon, 12 Apr 2021 09:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <E901E25F-41FA-444D-B3C7-A7A786DDD5D5@tuxera.com>
In-Reply-To: <E901E25F-41FA-444D-B3C7-A7A786DDD5D5@tuxera.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Apr 2021 09:23:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiXqbSgqzv53C98sbaHVqpc+c8NZTpXC7bBMQT3OznE4g@mail.gmail.com>
Message-ID: <CAHk-=wiXqbSgqzv53C98sbaHVqpc+c8NZTpXC7bBMQT3OznE4g@mail.gmail.com>
Subject: Re: [PATCH v6 24/40] fs: make helpers idmap mount aware
To:     Anton Altaparmakov <anton@tuxera.com>
Cc:     "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@hansenpartnership.com>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "alban@kinvolk.io" <alban@kinvolk.io>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "cyphar@cyphar.com" <cyphar@cyphar.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "geofft@ldpreload.com" <geofft@ldpreload.com>,
        "hch@lst.de" <hch@lst.de>,
        "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
        "john.johansen@canonical.com" <john.johansen@canonical.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "lennart@poettering.net" <lennart@poettering.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mpatel@redhat.com" <mpatel@redhat.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "smbarber@chromium.org" <smbarber@chromium.org>,
        "stephen.smalley.work@gmail.com" <stephen.smalley.work@gmail.com>,
        "tkjos@google.com" <tkjos@google.com>,
        "tycho@tycho.ws" <tycho@tycho.ws>, "tytso@mit.edu" <tytso@mit.edu>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 5:05 AM Anton Altaparmakov <anton@tuxera.com> wrote:
>
> Shouldn't that be using mnt_userns instead of &init_user_ns both for the setattr_prepare() and setattr_copy() calls?

It doesn't matter for a filesystem that hasn't marked itself as
supporting idmaps.

If the filesystem doesn't set FS_ALLOW_IDMAP, then mnt_userns is
always going to be &init_user_ns.

That said, I don't think you are wrong - it would probably be a good
idea to pass down the 'mnt_userns' argument just to avoid confusion.
But if you look at the history, you'll see that adding the mount
namespace argument to the helper functions (like setattr_copy())
happened before the actual "switch the filesystem setattr() function
over to get the namespace argument".

So the current situation is partly an artifact of how the incremental
filesystem changes were done.

           Linus
