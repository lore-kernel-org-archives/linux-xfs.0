Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FFCCDB482
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 21:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjJRVb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjJRVb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 17:31:57 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D32D111
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 14:31:55 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-53dfc28a2afso12373115a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 14:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1697664713; x=1698269513; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ECKpgvAUzJR9x6tmoRvOJm7k5hgaq6eXpehPithmdco=;
        b=Ac9dz8zswGFxsmltVOx8gzHtiaMUBO2y25lQgNRnhHQxZNz88kigBzIwC13DQTLzHT
         xfFpACNmpnF2YyEJZNGpquoNzaHQxKFs91OUX1T8x3+tBYvYMC/jK7z8UODjHrnvkNxL
         KIh5wQhJaXAaAxEH/tEG9R63nF/zDglOleTHs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697664713; x=1698269513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ECKpgvAUzJR9x6tmoRvOJm7k5hgaq6eXpehPithmdco=;
        b=oKZzkpR7RF9zxX0mNTRYGXu2QqT9QYQ3MrMc1koXtxsz+ohsp4q8nNUVJhgvK0mHjD
         BQ3gGSAh0mW4ZVrsVfnxK5meZyYbVWh92zHX/AdEEwm0aQN2mbemCbZn/FADbCQCkn2y
         JFV5M0cnAhciwKbUu7/F8JdvLe8ogpEbdOfyOJmEwkpSJ2KpVoXWT1kJ4QzYrtreSrTs
         zak5dHYXw/0u9W6nWFsqghL/CmUW75UeUTSa35+uC24zt5qIJgYY1fx8cyjgAp4WAPbn
         3fXSF9HnmxISEXEVXdE19TNX/2cg4r0aoeIKpJbPNziTaZk6UFhVg+1khBXIqIEBpY1y
         339Q==
X-Gm-Message-State: AOJu0Yy7IoWbdQJbgQsGsvPDho9RG18uWdLpDyZg4dyLpUA5JGEGMgTw
        Q1mlnMHKVAkCDtjAcqc1fS7a/yfJul58rm5y01xxwLtq
X-Google-Smtp-Source: AGHT+IFl7ux945vkwNWJYFQZm7aok4LfK2QDE0SU33Q2ZrrnjPCjN3jMS6f53+gri5EYJ6tWc/jFVA==
X-Received: by 2002:a05:6402:26d4:b0:53d:e1d9:a11 with SMTP id x20-20020a05640226d400b0053de1d90a11mr158265edd.35.1697664713598;
        Wed, 18 Oct 2023 14:31:53 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id t27-20020a508d5b000000b0053d9a862e2csm3462548edt.56.2023.10.18.14.31.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 14:31:53 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-99357737980so1204467866b.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 14:31:53 -0700 (PDT)
X-Received: by 2002:a17:907:c0d:b0:9be:7b67:1674 with SMTP id
 ga13-20020a1709070c0d00b009be7b671674mr409722ejc.3.1697664692747; Wed, 18 Oct
 2023 14:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20231018-mgtime-v1-0-4a7a97b1f482@kernel.org> <20231018-mgtime-v1-2-4a7a97b1f482@kernel.org>
 <CAHk-=wixObEhBXM22JDopRdt7Z=tGGuizq66g4RnUmG9toA2DA@mail.gmail.com> <d6162230b83359d3ed1ee706cc1cb6eacfb12a4f.camel@kernel.org>
In-Reply-To: <d6162230b83359d3ed1ee706cc1cb6eacfb12a4f.camel@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 18 Oct 2023 14:31:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiKJgOg_3z21Sy9bu+3i_34S86r8fd6ngvJpZDwa-ww8Q@mail.gmail.com>
Message-ID: <CAHk-=wiKJgOg_3z21Sy9bu+3i_34S86r8fd6ngvJpZDwa-ww8Q@mail.gmail.com>
Subject: Re: [PATCH RFC 2/9] timekeeping: new interfaces for multigrain
 timestamp handing
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        John Stultz <jstultz@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.de>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 18 Oct 2023 at 13:47, Jeff Layton <jlayton@kernel.org> wrote:
>
> >         old_ctime_nsec &= ~I_CTIME_QUERIED;
> >         if (ts64.tv_nsec > old_ctime_nsec + inode->i_sb->s_time_gran)
> >                 return ts64;
> >
>
> Does that really do what you expect here? current_time will return a
> value that has already been through timestamp_truncate.

Yeah, you're right.

I think you can actually remove the s_time_gran addition. Both the
old_ctime_nsec and the current ts64,tv_nsec are already rounded, so
just doing

        if (ts64.tv_nsec > old_ctime_nsec)
                return ts64;

would already guarantee that it's different enough.

> current_mgtime is calling ktime_get_real_ts64, which is an existing
> interface that does not take the global spinlock and won't advance the
> global offset. That call should be quite cheap.

Ahh, I did indeed mis-read that as the new one with the lock.

I did react to the fact that is_mgtime(inode) itself is horribly
expensive if it's not cached (following three quite possibly cold
pointers), which was part of that whole "look at I_CTIME_QUERIED
instead".

I see the pointer chasing as a huge VFS timesink in all my profiles,
although usually it's the disgusting security pointer (because selinux
creates separate security nodes for each inode, even when the contents
are often identical). So I'm a bit sensitive to "follow several
pointers from 'struct inode'" patterns from looking at too many
instruction profiles.

          Linus
