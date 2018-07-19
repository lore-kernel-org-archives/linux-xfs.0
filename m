Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f50.google.com ([209.85.221.50]:42888 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730234AbeGSM2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 08:28:04 -0400
Received: by mail-wr1-f50.google.com with SMTP id e7-v6so7751176wrs.9
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 04:45:17 -0700 (PDT)
Date: Thu, 19 Jul 2018 13:45:14 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: filefrag and reflink
Message-ID: <20180719114514.xwfxoy4nco77lacs@odin.usersys.redhat.com>
References: <CAJCQCtSJUV-0LYCTS2mfeZWA812aqc5oQagsWZ5fi3xuXQ9ncA@mail.gmail.com>
 <20180718195940.GA4813@magnolia>
 <165c936c-7dc4-7336-3d7e-268ec6746b56@sandeen.net>
 <20180718204715.GB4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180718204715.GB4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

> > zeros, while a cp --reflink will create a sparse file, though?
> 
> Well see therein lies the problem.  The documentation for cp states:
> 
> "When --reflink[=always] is specified, perform a lightweight copy, where
> the data blocks are copied only when modified."
> 
> The lightest weight copy for a bunch of zeroes is a hole.  That's the
> interpretation I went with. :)
> 
> OTOH the "copied only when modified" language does sort of imply that
> you'd share the unwritten extents and then COW them, but that involves
> adding more machinery to _iomap_begin to copy-write over zeroes,
> which seems pointless and would involve a format change since old
> kernels wouldn't know to check for shared unwritten extents...
> 
> ...and if your worry is about being able to write to tmp3 without
> hitting ENOSPC then you'll have to fallocate + funshare the file
> separately anyway.

/me should read the whole thread before replying to earlier messages :P

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
