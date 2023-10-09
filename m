Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86788E95A91
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 09:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345822AbjJIJ7y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 05:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345708AbjJIJ7y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 05:59:54 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B7797
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 02:59:52 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-58d26cfe863so340732a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 09 Oct 2023 02:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696845592; x=1697450392; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k29XlXnCZ+KiT1CJrWCWSZAXfWHfCFyOSqAAsQe6yPM=;
        b=S6bj907VMnXnjQHMkmZHpNSxMVF/L2Gv2zxLy6oAqVqKXgb06Sh6/nuL3pKaIUBDpc
         gBFCTD71GtDENMla13sYNAAntpf4vLucs8XKP6zdatyNPE4J71/hAsx3M7ibn3+j/pBV
         PvpVsYMSR1LpabJsAVnsUkBoJVrn4X6ysEQ+joMSeEG396jkEsb57bFsiMmKmhyHjrxU
         Mcxf3+rdK1zbNlyDviC1M2qQ9RmNpdhwOTW30JgBkZ9TegE9IOPe4ITeJYN+UTuHm+qY
         NbaQMCMaH34oedSd3Ut/GYkds+9vilzQwsbULU0bkT8LHHVMf0noV6LULiFu97PEwamf
         HVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696845592; x=1697450392;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k29XlXnCZ+KiT1CJrWCWSZAXfWHfCFyOSqAAsQe6yPM=;
        b=o2AqcZkMLeR82OVcYqTcGNj+KIfJlOIq1Ctdu4XIwUAdA4z69o9Hl9eDQtAsoW+N5i
         m84O1+P2XBBt8YExeWWAKkKPAW3ka7XtcfiUUvAtCk1k+HUTDjMKH2C5cStfQ4raocFU
         uPFJmn70CnpOO5k+Ad2Fx5gJDLopYm808tO9Dgms0+uyoFckXQUNL3hdkE/zRI/xcfTo
         pe2eDydmHSjqAhY8J5LqE1JcTIKiiHgh3f1hRzzreCeJe8qDRXe4x9CnrnsBnQja4OSk
         2xJ9pCiLuwpVwtzt1MgVhS8ajrGLGtUYXUF90MrtTRLuzUb21mgojNl+SPok/kZXLZ6Z
         1qNw==
X-Gm-Message-State: AOJu0YzYKpXYJvVscXc19FBIv8tyApUV3NTUuIy5kjrBE7WslX+pA9zM
        1W3HrBrZEeFcXlnTeq31O9Kt0gbxzcfjnpvPuF4=
X-Google-Smtp-Source: AGHT+IEb3z0mnowBqzxAiPV3IKQJcxtfF98NFR6ALHOqPNIEeygobeOt3vNLr81RfnC3P9RkClid9Xt+y5xMm6/Q6Cc=
X-Received: by 2002:a17:90b:1e51:b0:26b:49de:13bd with SMTP id
 pi17-20020a17090b1e5100b0026b49de13bdmr11644130pjb.36.1696845591928; Mon, 09
 Oct 2023 02:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
 <ZR8qWqksNx1kNhvi@dread.disaster.area> <20231006042250.GP21298@frogsfrogsfrogs>
 <ZR+OtcVIsVrJeqMO@dread.disaster.area> <20231006050451.GQ21298@frogsfrogsfrogs>
 <CAO8sHcmEXj4tVnLADGxX_k3nWGGVRiQueAkMVLMkAKBpPSMSGg@mail.gmail.com> <20231006185728.GY21298@frogsfrogsfrogs>
In-Reply-To: <20231006185728.GY21298@frogsfrogsfrogs>
From:   Daan De Meyer <daan.j.demeyer@gmail.com>
Date:   Mon, 9 Oct 2023 11:59:41 +0200
Message-ID: <CAO8sHcnwozN-MYVC9wgSJC+B=xm=W1vvEDDFh-w-rohMLD7JPA@mail.gmail.com>
Subject: Re: mkfs.xfs with --protofile does not copy extended attributes into
 the generated filesystem
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Using a virtual machine under the hood to get around these limitations
isn't really an option either. Like I said, this works perfectly fine
if the filesystem's mkfs tool supports populating the filesystem from
a given directory (and btrfs, ext4 already support this with xattrs
and everything). It even works fine with XFS's -p option already,
except when you try to build an image with SELinux enabled as all the
SELinux xattrs are stripped. I would just like to not have to tell my
users to use another filesystem than XFS when they would like to build
images with SELinux enabled unprivileged.

Cheers,

Daan

On Fri, 6 Oct 2023 at 20:57, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Oct 06, 2023 at 09:24:50AM +0200, Daan De Meyer wrote:
> > On Fri, Oct 06, 2023 at 03:36:05PM +1100, Dave Chinner wrote:
> > > On Thu, Oct 05, 2023 at 09:22:50PM -0700, Darrick J. Wong wrote:
> > > > On Fri, Oct 06, 2023 at 08:27:54AM +1100, Dave Chinner wrote:
> > > > > On Thu, Oct 05, 2023 at 10:37:34AM +0200, Daan De Meyer wrote:
> > > > > > Hi,
> > > > > >
> > > > > > It seems using --protofile ignores any extended attributes set on
> > > > > > source files. I would like to generate an XFS filesystem using
> > > > > > --protofile where extended attributes are copied from the source files
> > > > > > into the generated filesystem. Any way to make this happen with
> > > > > > --protofile?
> > > > >
> > > > > mkfs.xfs doesn't have a '--protofile' option. It has a '-p <file>'
> > > > > option for specifying a protofile - is that what you mean?
> > > >
> > > > While we're on the topic, would it also be useful to have a -p switch
> > > > that would copy the fsxattr options as well?
> > >
> > > If protofile support is going to be extended then supporting
> > > everything that can be read/set through generic kernel interfaces
> > > would be appropriate...
> > >
> > > But I'm not convinced that we should extend protofile support
> > > because mounting the filesytsem and running rsync, xfs_restore, etc
> > > can already do all this stuffi with no development work necessary...
> >
> > > rsync doesn't support copying the fsxattr data (though it does support
> > > extended attributes), and iirc xfsdump can only do entire filesystems,
> > > right?
> >
> > Additionally, when populating the filesystem in a regular file, to mount it
> > we need loop devices and we need to be root. Both of which we want to
> > avoid. So having an option to do this without mounting the filesystem like
> > ext4 and btrfs have would be very useful. It doesn't have to be via '-p', I'm
> > fine with a -d or --rootdir option like the ones that ext4 and btrfs
> > have as well.
>
> <shrug> How about libguestfs then?
>
> --D
>
> > Cheers,
> >
> > Daan
> >
> > On Fri, 6 Oct 2023 at 07:04, Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Fri, Oct 06, 2023 at 03:36:05PM +1100, Dave Chinner wrote:
> > > > On Thu, Oct 05, 2023 at 09:22:50PM -0700, Darrick J. Wong wrote:
> > > > > On Fri, Oct 06, 2023 at 08:27:54AM +1100, Dave Chinner wrote:
> > > > > > On Thu, Oct 05, 2023 at 10:37:34AM +0200, Daan De Meyer wrote:
> > > > > > > Hi,
> > > > > > >
> > > > > > > It seems using --protofile ignores any extended attributes set on
> > > > > > > source files. I would like to generate an XFS filesystem using
> > > > > > > --protofile where extended attributes are copied from the source files
> > > > > > > into the generated filesystem. Any way to make this happen with
> > > > > > > --protofile?
> > > > > >
> > > > > > mkfs.xfs doesn't have a '--protofile' option. It has a '-p <file>'
> > > > > > option for specifying a protofile - is that what you mean?
> > > > >
> > > > > While we're on the topic, would it also be useful to have a -p switch
> > > > > that would copy the fsxattr options as well?
> > > >
> > > > If protofile support is going to be extended then supporting
> > > > everything that can be read/set through generic kernel interfaces
> > > > would be appropriate...
> > > >
> > > > But I'm not convinced that we should extend protofile support
> > > > because mounting the filesytsem and running rsync, xfs_restore, etc
> > > > can already do all this stuffi with no development work necessary...
> > >
> > > rsync doesn't support copying the fsxattr data (though it does support
> > > extended attributes), and iirc xfsdump can only do entire filesystems,
> > > right?
> > >
> > > --D
> > >
> > > > Cheers,
> > > >
> > > > Dave.
> > > > --
> > > > Dave Chinner
> > > > david@fromorbit.com
