Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BD0E92FF1
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 07:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjJFHZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 03:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjJFHZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 03:25:04 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD07CCA
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 00:25:02 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-57bab4e9e1aso1095719eaf.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 00:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696577102; x=1697181902; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eg+2GRW0aRszkDMex8YRwQkNSe/hWapRtD78Z3O2tBk=;
        b=OrJBCa+SZif9H9FmuFp8HRSK5vgijvFJl7i2AtJ9Gq2sHMjXdCinNJj2XHpfKhhxu+
         N462eNAqh3Kxli+sVG3c6djhooSv+NRtTbs0y/m4lW9xAhWmO68HrLv7Ogbwjo8l3W5c
         chK85lAbX/giPNxpyw0IxspL6ANO4QT/j45kgYslKRy1B9QXC4y6h7RF4mg1kRk/tpsa
         dzyIzsB85g1Za5xsUrbutOWWaeLj23s9FCd39MFAJfqobUowUdrXfhR+F/l997MU4DIq
         bPDY3SlrUw5ZpvD6hcUCR+FRSK6ylJbc/s4W9TEKrBus0lNMJmmjU9mWLkEwY+ap2ruk
         aV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696577102; x=1697181902;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eg+2GRW0aRszkDMex8YRwQkNSe/hWapRtD78Z3O2tBk=;
        b=PIuN91ZQFCuIME2oSApjRfOuPqsabPLhm4VlKH89IPrYUQfdJzydeTXN/OZ7BnarX8
         OcqQ9Afw9mydSZsP7YuKdRtWRkF+qwBZ0jwvT36G5KvN7Sbef9uwvbXLFyw92OrDhwKV
         hlsxZ8QnmwX8Q1KbMWv2mmBKLoOGCU/mujIiCA3F5JwAGB2GmtUchESXkDmHQcXe6iR4
         3zkOF67QYP37hHAyQn1dn4u35B2Qp540IUmpAAKkTLj1YB4XUIJRC7lSChxi/5Xpntd4
         kDeQQ5r0B6kLIziRNNLTVn7y5ni7nk8DTwniJGwZmdlvIsrrfb7pc06PaflcK1kgXOT2
         U+bw==
X-Gm-Message-State: AOJu0Yyy1CyZokG3xaZCN9f39qCdaLAiQV5eyC4hgxkg0LjGz2o/5L0w
        JnYJoYTbcAonEwmtrDDcgfQUsykxrit4qPLSa/4=
X-Google-Smtp-Source: AGHT+IFU3JS2o8b2qGDSbf/XHZccFTf3o5u0DkxEyewpWpcLANyScKEh/jQQtDcnnYnzC+lxCytOfYpOq1+qm+zTtlY=
X-Received: by 2002:a05:6358:4414:b0:145:6fdf:9c86 with SMTP id
 z20-20020a056358441400b001456fdf9c86mr6418666rwc.13.1696577101712; Fri, 06
 Oct 2023 00:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
 <ZR8qWqksNx1kNhvi@dread.disaster.area> <20231006042250.GP21298@frogsfrogsfrogs>
 <ZR+OtcVIsVrJeqMO@dread.disaster.area> <20231006050451.GQ21298@frogsfrogsfrogs>
In-Reply-To: <20231006050451.GQ21298@frogsfrogsfrogs>
From:   Daan De Meyer <daan.j.demeyer@gmail.com>
Date:   Fri, 6 Oct 2023 09:24:50 +0200
Message-ID: <CAO8sHcmEXj4tVnLADGxX_k3nWGGVRiQueAkMVLMkAKBpPSMSGg@mail.gmail.com>
Subject: Re: mkfs.xfs with --protofile does not copy extended attributes into
 the generated filesystem
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 03:36:05PM +1100, Dave Chinner wrote:
> On Thu, Oct 05, 2023 at 09:22:50PM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 06, 2023 at 08:27:54AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 05, 2023 at 10:37:34AM +0200, Daan De Meyer wrote:
> > > > Hi,
> > > >
> > > > It seems using --protofile ignores any extended attributes set on
> > > > source files. I would like to generate an XFS filesystem using
> > > > --protofile where extended attributes are copied from the source files
> > > > into the generated filesystem. Any way to make this happen with
> > > > --protofile?
> > >
> > > mkfs.xfs doesn't have a '--protofile' option. It has a '-p <file>'
> > > option for specifying a protofile - is that what you mean?
> >
> > While we're on the topic, would it also be useful to have a -p switch
> > that would copy the fsxattr options as well?
>
> If protofile support is going to be extended then supporting
> everything that can be read/set through generic kernel interfaces
> would be appropriate...
>
> But I'm not convinced that we should extend protofile support
> because mounting the filesytsem and running rsync, xfs_restore, etc
> can already do all this stuffi with no development work necessary...

> rsync doesn't support copying the fsxattr data (though it does support
> extended attributes), and iirc xfsdump can only do entire filesystems,
> right?

Additionally, when populating the filesystem in a regular file, to mount it
we need loop devices and we need to be root. Both of which we want to
avoid. So having an option to do this without mounting the filesystem like
ext4 and btrfs have would be very useful. It doesn't have to be via '-p', I'm
fine with a -d or --rootdir option like the ones that ext4 and btrfs
have as well.

Cheers,

Daan

On Fri, 6 Oct 2023 at 07:04, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Oct 06, 2023 at 03:36:05PM +1100, Dave Chinner wrote:
> > On Thu, Oct 05, 2023 at 09:22:50PM -0700, Darrick J. Wong wrote:
> > > On Fri, Oct 06, 2023 at 08:27:54AM +1100, Dave Chinner wrote:
> > > > On Thu, Oct 05, 2023 at 10:37:34AM +0200, Daan De Meyer wrote:
> > > > > Hi,
> > > > >
> > > > > It seems using --protofile ignores any extended attributes set on
> > > > > source files. I would like to generate an XFS filesystem using
> > > > > --protofile where extended attributes are copied from the source files
> > > > > into the generated filesystem. Any way to make this happen with
> > > > > --protofile?
> > > >
> > > > mkfs.xfs doesn't have a '--protofile' option. It has a '-p <file>'
> > > > option for specifying a protofile - is that what you mean?
> > >
> > > While we're on the topic, would it also be useful to have a -p switch
> > > that would copy the fsxattr options as well?
> >
> > If protofile support is going to be extended then supporting
> > everything that can be read/set through generic kernel interfaces
> > would be appropriate...
> >
> > But I'm not convinced that we should extend protofile support
> > because mounting the filesytsem and running rsync, xfs_restore, etc
> > can already do all this stuffi with no development work necessary...
>
> rsync doesn't support copying the fsxattr data (though it does support
> extended attributes), and iirc xfsdump can only do entire filesystems,
> right?
>
> --D
>
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
