Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1194DEB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 21:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjF1V6k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 17:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjF1V6j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 17:58:39 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB30107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 14:58:38 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-666ecf9a0ceso14697b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 14:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687989518; x=1690581518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l1MfNYGEQIj/FK/5LPgDAXCj/XTBV2FvJ10MEeMy7nc=;
        b=dbfILMOvtyXsRoyZfU2hYfJ2lCK1O4uz8/zU1bL0aGf8/6lVtw9Rj94VVz0nXoV24s
         0HQkazpTkEQ6ohSCfX6g3nfjNeM9Q++f8MpNnYOPFn06RpWLVm+m/JZZdPYq09lrTdSM
         B/V8e7psjdLuM51zrOgwqDLCjyBN83mCX+DBg0T3cTDXLfK7A1EAPo+pzFhBjeYbZRMk
         Hr6zBxc2cI9yvDK5qwzSjnd9oEmDSjnKJGSrLMshOzIJlRJ0z/8BU7oCBvC6dlO57GS+
         KVzhaGcbWVXIwgqNJi6FRArjDYMV1CMisxqIBz6nSuzcrJhzO2N+Tsvjb5amCcYplBS8
         5hew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687989518; x=1690581518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l1MfNYGEQIj/FK/5LPgDAXCj/XTBV2FvJ10MEeMy7nc=;
        b=eJoyjeS/9X9KrZqHT4Sk7JT2xbNoRDoLWgoP0KHA/01DQ9zwDnkgwTeID0ZUGtJJLZ
         FVm9aI8oOSr6RFbVVwHgY7kmx9a+ZQFdMQOOfnx1ijDaxe3I12HXlNa/EyKnMfgqK93s
         qUEugoKGu+ayuSkEUglFRgNvlINK5zBOj27oeFR0+v6fsKqmrx7WWwNLdd7uDWT6tSMC
         Ew3bRF1VTnxIVnIs0thbX/RkYJ4FeA7QLBPJXuES85umOTHGZJAK6z0fV59/F5uHdNWw
         ik+WW52glZygWI5pws2j1HCTSBQ8GWDVEVuiDDZMrJ6zd0nOIakyPqdFcZyYg0JKCAeG
         5XZw==
X-Gm-Message-State: AC+VfDyjp1UA7Y3L1Y44B02s7QJ0kX86Ik/Igk9A9RMnhUEesuk7II2B
        FbTzGE48nejXh11M1XJPd733azK892XzU5UOBvQ=
X-Google-Smtp-Source: ACHHUZ7/hfqWEDbJbH8mBkm9zIDaicdsBcgbrw5DeR5fujBy2y2jBLxoiOJfzaKbDCFpDbOj70UCqQ==
X-Received: by 2002:a05:6a00:3a10:b0:668:8596:7524 with SMTP id fj16-20020a056a003a1000b0066885967524mr28433379pfb.20.1687989517742;
        Wed, 28 Jun 2023 14:58:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id a25-20020aa78659000000b0067738f65039sm5417596pfo.83.2023.06.28.14.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 14:58:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qEdBJ-00HO2m-1g;
        Thu, 29 Jun 2023 07:58:33 +1000
Date:   Thu, 29 Jun 2023 07:58:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217604] New: Kernel metadata repair facility is not
 available, but kernel has CONFIG_XFS_ONLINE_REPAIR=y
Message-ID: <ZJytCV1TLr3k2fa7@dread.disaster.area>
References: <bug-217604-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217604-201763@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:50:43AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217604
> 
>             Bug ID: 217604
>            Summary: Kernel metadata repair facility is not available, but
>                     kernel has CONFIG_XFS_ONLINE_REPAIR=y
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: j.fikar@gmail.com
>         Regression: No
> 
> Hi,
> 
> I'm trying the new xfs_scrub and I get this error:
> 
> $ sudo xfs_scrub /mnt/xfs
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Error: /mnt/xfs: Kernel metadata repair facility is not available.  Use -n to
> scrub.
> Info: /mnt/xfs: Scrub aborted after phase 1.
> /mnt/xfs: operational errors found: 1

We haven't merged all the online repair code yet so it is not yet
available to use. Please close the bug and monitor the upstream XFS
list to find out when the repair code is fully merged and enabled
at runtime.

FWIW, it is far better to send a message to the mailing list
(linux-xfs@vger.kernel.org) to find out what the status of something
is than it is to raise a bug just to ask a question about support...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
