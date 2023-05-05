Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBC0C77B75
	for <linux-xfs@archiver.kernel.org>; Fri,  5 May 2023 23:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjEEXmL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 May 2023 19:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjEEXmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2023 19:42:10 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF93F5FE0
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2023 16:42:07 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b5465fc13so1867036b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 May 2023 16:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683330127; x=1685922127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCtnoETSxcB113Zij2dc92/a6FXT6zg5FXhG1u0c1nk=;
        b=QusrV2Wwp2bfcRiTRr6hzIF/JXaTe4s/VrPmwKwo0KjCO5zokwC9p/TVY23qdqD/l1
         Dli2uc+0UwP0iuI3XJJiRqCCR1FgBhbsbCfs3DBsxBDA+bBTXb8II9k8UOkYruYMdXhy
         gwAAOON1JGC03tKiYjRGDxrPMDO2D458c4fsVC5Dvmbt5so6xvclSNo3u4T0qTypnasy
         eyJy1DNm0nF83oEQuDkzVIzBajW2FDDdAiEilNv9J3lj3iA93K7uz8wuxLyAqRBsSQeD
         7aahCv7qFLZjDKFH0N+HzdR7mcuioyTEBOlzKFarm+J+e4+MCHsEUXooUNe0p7ye3H6n
         fFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683330127; x=1685922127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCtnoETSxcB113Zij2dc92/a6FXT6zg5FXhG1u0c1nk=;
        b=CvTbFjd0b8mHPcUigaMGVTrOT3+s94/KAZFyqG2aXWYFm6jLdSPy5EB7AXFFlmxfIy
         DeEsbuwKxOkzeztusTMhFhBfUMkmz6fv6crW4UuGXRAjPhMQ0ZPav8cgP9ihYIcGKM8r
         5hsu78NEynDqLkKfYgR+DFV8G1v6Amgn9tKqoYOrbi4rnFbz2ODyUdmU24FsTSiMFuYX
         WANHnJSPsutLYSp2npXatiw0x5XQwxyefCoQ/mKszWTmshooK3djZ4OZK0SXJYwG5mOH
         u/ehxn5nfKsXTL6PUl7P32iMYKcUIhVRctCYiVADwBKgpUrV+GEDOMoWX5qalCvqKAkO
         fkmg==
X-Gm-Message-State: AC+VfDzvNjsxj+fsQX5mHGgua65ITC/euCceK0n0EK0uZ/Ui8AjnwJwO
        /Q/KwBdq1vFPF1DMcxwOy0GGGQ==
X-Google-Smtp-Source: ACHHUZ6ZXwTvDt9dgqu5VnMU2vt75ZEwPCsWikBzLJH1LKI2sJCZP8HWyuvB09pM2j5L3woioye+0w==
X-Received: by 2002:a05:6a20:1590:b0:f6:592a:7e28 with SMTP id h16-20020a056a20159000b000f6592a7e28mr3982333pzj.14.1683330127470;
        Fri, 05 May 2023 16:42:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id x2-20020a056a00270200b006338e0a9728sm2097064pfv.109.2023.05.05.16.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 16:42:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pv53r-00BpPv-Ud; Sat, 06 May 2023 09:42:03 +1000
Date:   Sat, 6 May 2023 09:42:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
        kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jejb@linux.ibm.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, paul@paul-moore.com,
        jmorris@namei.org, serge@hallyn.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Subject: Re: [PATCH RFC 12/16] xfs: Add support for fallocate2
Message-ID: <20230505234203.GO3223426@dread.disaster.area>
References: <20230503183821.1473305-1-john.g.garry@oracle.com>
 <20230503183821.1473305-13-john.g.garry@oracle.com>
 <20230503232616.GG3223426@dread.disaster.area>
 <20230505222333.GM15394@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505222333.GM15394@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 05, 2023 at 03:23:33PM -0700, Darrick J. Wong wrote:
> On Thu, May 04, 2023 at 09:26:16AM +1000, Dave Chinner wrote:
> > On Wed, May 03, 2023 at 06:38:17PM +0000, John Garry wrote:
> > If we want fallocate() operations to apply filesystem atomic write
> > constraints to operations, then add a new modifier flag to
> > fallocate(), say FALLOC_FL_ATOMIC. The filesystem can then
> > look up it's atomic write alignment constraints and apply them to
> > the operation being performed appropriately.
> > 
> > > The alignment flag is not sticky, so further extent mutation will not
> > > obey this original alignment request.
> > 
> > IOWs, you want the specific allocation to behave exactly as if an
> > extent size hint of the given alignment had been set on that inode.
> > Which could be done with:
> > 
> > 	ioctl(FS_IOC_FSGETXATTR, &fsx)
> > 	old_extsize = fsx.fsx_extsize;
> > 	fsx.fsx_extsize = atomic_align_size;
> > 	ioctl(FS_IOC_FSSETXATTR, &fsx)
> 
> Eww, multiple threads doing fallocates can clobber each other here.

Sure, this was just an example of how the same behaviour could be be
acheived without the new ioctl. Locking and other trivialities were
left as an exercise for the reader.

> 
> > 	fallocate(....)
> > 	fsx.fsx_extsize = old_extsize;
> > 	ioctl(FS_IOC_FSSETXATTR, &fsx)
> 
> Also, you can't set extsize if the data fork has any mappings in it,
> so you can't set the old value.  But perhaps it's not so bad to expect
> that programs will set this up once and not change the underlying
> storage?
> 
> I'm not actually sure why you can't change the extent size hint.  Why is
> that?

Hysterical raisins, I think.

IIUC, it was largely to do with the fact that pre-existing
allocation could not be realigned, so once allocation has been done
the extent size hint can't guarantee extent size hint aligned/sized
extents are actually allocated for the file.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
