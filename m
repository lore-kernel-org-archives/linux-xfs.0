Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DD6EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 02:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbjFPCQd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 22:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjFPCQc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 22:16:32 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2952296F
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 19:16:28 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-75d57fdb014so26942485a.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 19:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686881788; x=1689473788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IZw3pdY0opDLGDsTpwuj97Ucsrogt/lYMMv4qSi3gyk=;
        b=LcdHAK6OBNquNv/JQRwCg+VrLHLuSftgvh8ISu6SSLBLGyEbonYMW/tJNgmjliiwYh
         V1iz7wFjZASvHjLNdI2LU+GoXeF0AYJC/UHJWypAZ9Eb3/eJCRRb/KxYMueNf7QwxkHS
         JDU4DpV/qAWKCx3S9eC27KlerVYlt5WfGVdZl+4poxBOk5u3etIbg+gknXL7cS+f1ijD
         jd/p9VaUMj2EAvkPLjZRCTC5B8GevcKzvOh+Nvf1oJhA7wC3ZvTvod7+6ig5OC3ax+1U
         snDBEwed5e1tYtKODV3WqGTsOVCBzO50G2lGszNDENQ975Ox5KWEHsmAnRmFUWkIIAps
         OhwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686881788; x=1689473788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZw3pdY0opDLGDsTpwuj97Ucsrogt/lYMMv4qSi3gyk=;
        b=ZnBFsJz3ZA0oA8zy+PbNAFOpqkwE2GgmbWf198G0BOeo0dluYJUIkwyk0tFXE0Cp2I
         BgAw9jy6OT7urWaqsTWGRGG8cS5CI32oIutDYgbX4sO+1ls2zX40KcEHX5T2cAVaUaF8
         jLJmlQPTUQaDWNQwawYDjnXYq9v4Av27rQVm47AJeEbrxojg7VZhdF4yMzTRT9pzJ/lW
         3ZkMrJ6YEpIWtZ7TDlhlFwc0EiGbNkk6scOVIgsVmrYEJPa32jN4g86y1oq37/QDC5xz
         SxBMy+TRzPVB54BZfY6sjSV9mJdI0kfaObp6ZWyqLbojbPgM5I/YnwQJAiaVB5BVL7fm
         Vw6A==
X-Gm-Message-State: AC+VfDxCz2/k9zhwWamVDrd8/+A9KrEXx5Li7D2bp6kw9bVE1WGOwKZv
        Z0gW4DE8LXyeUuI37/dnSp4Q/g==
X-Google-Smtp-Source: ACHHUZ4JZ83vV8quUTC03gNsp2qjvYIN2N3WDX9eoxTSBd2ZhQw6YgM1ThlfXTDMar3ksVs40dvuSQ==
X-Received: by 2002:a05:620a:2ee:b0:75e:bb66:5155 with SMTP id a14-20020a05620a02ee00b0075ebb665155mr400690qko.36.1686881787753;
        Thu, 15 Jun 2023 19:16:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id s9-20020a637709000000b005533dcb7586sm372614pgc.20.2023.06.15.19.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 19:16:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9z0h-00CIiC-1x;
        Fri, 16 Jun 2023 12:16:23 +1000
Date:   Fri, 16 Jun 2023 12:16:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     mcgrof@kernel.org, jack@suse.cz, hch@infradead.org,
        ruansy.fnst@fujitsu.com, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] fs: distinguish between user initiated freeze and
 kernel initiated freeze
Message-ID: <ZIvF9/UjxBuBGF9Z@dread.disaster.area>
References: <168688010689.860947.1788875898367401950.stgit@frogsfrogsfrogs>
 <168688011268.860947.290191757543068705.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168688011268.860947.290191757543068705.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 06:48:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Userspace can freeze a filesystem using the FIFREEZE ioctl or by
> suspending the block device; this state persists until userspace thaws
> the filesystem with the FITHAW ioctl or resuming the block device.
> Since commit 18e9e5104fcd ("Introduce freeze_super and thaw_super for
> the fsfreeze ioctl") we only allow the first freeze command to succeed.
> 
> The kernel may decide that it is necessary to freeze a filesystem for
> its own internal purposes, such as suspends in progress, filesystem fsck
> activities, or quiescing a device prior to removal.  Userspace thaw
> commands must never break a kernel freeze, and kernel thaw commands
> shouldn't undo userspace's freeze command.
> 
> Introduce a couple of freeze holder flags and wire it into the
> sb_writers state.  One kernel and one userspace freeze are allowed to
> coexist at the same time; the filesystem will not thaw until both are
> lifted.
> 
> I wonder if the f2fs/gfs2 code should be using a kernel freeze here, but
> for now we'll use FREEZE_HOLDER_USERSPACE to preserve existing
> behaviors.
> 
> Cc: mcgrof@kernel.org
> Cc: jack@suse.cz
> Cc: hch@infradead.org
> Cc: ruansy.fnst@fujitsu.com
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/vfs.rst |    6 ++-
>  block/bdev.c                      |    8 ++--
>  fs/f2fs/gc.c                      |    4 +-
>  fs/gfs2/glops.c                   |    2 -
>  fs/gfs2/super.c                   |    6 +--
>  fs/gfs2/sys.c                     |    4 +-
>  fs/gfs2/util.c                    |    2 -
>  fs/ioctl.c                        |    8 ++--
>  fs/super.c                        |   79 +++++++++++++++++++++++++++++++++----
>  include/linux/fs.h                |   15 +++++--
>  10 files changed, 101 insertions(+), 33 deletions(-)

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
