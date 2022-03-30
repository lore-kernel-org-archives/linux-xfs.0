Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E26C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 11:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245083AbiC3L5P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 07:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345946AbiC3LzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 07:55:15 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12945FFF
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 04:53:00 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w4so28866596wrg.12
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 04:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hdJyh7o9pjZtiWcQ3wYEUd3kplJyB42frQ3lanPWwNQ=;
        b=YzMFG+NRbTOKHRjMHm6Riwme40goT/L1w+0kn3bGgQL4yDmgYQu6xghw52X/LHZtXd
         5DYVrFAoY8rMo8CJ7Y34O5QMJJ/YV+laHZwFSZHL7GfcM1GmKGARDc+ZkZngxIJgav0m
         V8CNAG5ew4YXTBmZex0Dh3O7WvHIoUQ7Dau5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hdJyh7o9pjZtiWcQ3wYEUd3kplJyB42frQ3lanPWwNQ=;
        b=WsFIxlKWAbQ4D7uGUTVo1+j5wCk4Yf/7jNuv+HKbYIohd5ecrVLgf1XfEPNrh4/Lbh
         RqAxUoZKWWdMTyenSBiW84/Y8YSEfAOTaBB6w5n8fssh6t2uot5SACOb2uqWhmkbFmF5
         ej/ZoSKkTJFz5phHLxEEa7KPpA/5SJeGNn37HRd9mJttL0XwNBZ8b/qAiyDxVpqDXMgS
         s/NKZqNY/BwNjYV1jIkJ0y+sqNHMJCTkQSfHpU4wLqtOyhLpdANina2QyuXrQ3OJWsrI
         cCHZvt7XBkHoglhFUfPxurkYRvXojssW1I5iBB4FCQiL2bHOxhu/xS+w/NcsprwU14If
         rIVA==
X-Gm-Message-State: AOAM531nlasOUcJf9gBvdb0iRpyRuGuUd2IB/Li+rGm2g51qCjZ09H5x
        ailoNa9nOeEtcpr/A1t3PGy09Q==
X-Google-Smtp-Source: ABdhPJzYWOQwM9s5iwNGBLM1tDx3salLFuYSYDl8bVwPLZOoO5ZFFJIEd9EbHZUiFuHKTKOaHQACoQ==
X-Received: by 2002:adf:bb54:0:b0:203:e244:fbe4 with SMTP id x20-20020adfbb54000000b00203e244fbe4mr35371259wrg.313.1648641179384;
        Wed, 30 Mar 2022 04:52:59 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:5ee4:2aff:fe50:f48d])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d440d000000b00203f2b010b1sm17103388wrq.44.2022.03.30.04.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:52:58 -0700 (PDT)
Date:   Wed, 30 Mar 2022 12:52:58 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Petr Mladek <pmladek@suse.com>, Jonathan Lassoff <jof@thejof.com>,
        linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkREmrfoTcqOYbma@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220330003457.GB1544202@dread.disaster.area>
User-Agent: Mutt/2.2.2 (aa28abe8) (2022-03-25)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Dave Chinner writes:
>I ask, because user/kernel ABIs are usually fixed and we are not
>allowed to change them in a way that might break userspace. What
>happens when one of these format messages gets moved? What if the
>file, function and line of code all change, but the format string
>stays the same? What about duplicate format strings in different
>files/functions?

printk indexing is exposed in debugfs, and we have a long standing 
understanding that debugfs APIs are not stable, and there are no ABI 
guarantees. The statement in the initial patch that the API is "semi-stable" is 
simply wrong.

>Exactly how is this supposed to be used by userspace? Given that you
>are exposing both the file and the line of the file that the format
>string belongs to, does this mean we can no longer actually move
>this format string to any other location in the source code?

>
>IOWs, I cannot find anything that documents the implications of
>directly exposing the *raw source code* to userspace though a sysfs
>file on either developers or userspace applications.  Exposing
>anything through a sysfs file usually comes with constraints and
>guarantees and just because it is in /sys/kernel/debug means we can
>waive ABI constraints: I'll refer you to the canonical example of
>tracepoints vs powertop.
>
>With tracepoints in mind, XFS has an explicit policy that
>tracepoints do not form part of the user ABI because they expose the
>internal implementation directly to userspace. Hence if you use XFS
>tracepoints for any purpose, you get to keep all the broken bits
>when we change/add/remove tracepoints as part of our normal
>development.
>
>However, for information we explicitly expose via files in proc and
>sysfs (and via ioctls, for that matter), we have to provide explicit
>ABI guarantees, and that means we cannot remove or change the format
>or content of those files in ways that would cause userspace parsers
>and applications to break. If we are removing a proc/sysfs file, we
>have an explicit deprecation process that takes years to run so that
>userspace has time to notice that removal will be occurring and be
>updated not to depend on it by the time we remove it.

debugfs has no stability guarantees whatsoever and exists outside of the 
userspace ABI guarantees.[0]

Even if there was some guarantee (which there isn't), the guarantee would be on 
the format of the file, not the data contained within. The point of printk 
indexing is to indicate when things change, not preclude that change. Just as a 
map appearing, changing, or disappearing in /proc/pid/smaps isn't an ABI break, 
this wouldn't be either. It would just be a change in the backing data. For 
example, if a file or line changes, printk indexing helps indicate to a 
userspace tool that the printk may have gone away, or changed location.

Anyone using printk indexing has to accept that both the format and the file 
contents are not stable between kernel releases, and must accommodate for that 
during development. That's the main reason that this was put in debugfs rather 
than (for example) /proc or /sys.

>I see no statement anywhere about what this printk index ABI
>requires in terms of code stablility, format string maintenance and
>modification, etc. I've seen it referred to as "semi-stable" but
>there is no clear, easily accessible definition as to what that
>means for either kernel developers or userspace app developers that
>might want to use this information. There's zero information
>available about how userspace will use this information, too, so at
>this point I can't even guess what the policy for this new ABI
>actually is.

I don't know why Jonathan referred to it as "semi-stable". It is simply not so. 
printk indexing is a completely unstable debugfs API with no guarantees about 
either format or contents to userspace at all over kernel releases.

>If this was discussed and a policy was created, then great. But it
>*hasn't been documented* for the rest of the world to be able to
>read and understand so they know how to deal safely with the
>information this ABI now provides. So, can you please explain what
>the rules are, and then please write some documentation for the
>kernel admin guide defining the user ABI for application writers and
>what guarantees the kernel provides them with about the contents of
>this ABI.

The policy, as with all debugfs APIs by default, is that it's completely 
unstable and there are no API stability guarantees whatsoever. That's why 
there's no extensive documentation for users: because this is a feature for 
kernel developers.

0: https://lwn.net/Articles/309298/

Thanks,

Chris
