Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE390E94102
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjJFS5j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjJFS5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:57:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C16B106
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:57:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA8EC433C8;
        Fri,  6 Oct 2023 18:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696618648;
        bh=TEDLq7uIiACxyizhFuPHOPe6jqi6hPKJmQil+g7/liQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lt2R7GeMeD5LGPz0Zf5YXCuU6WH8i9tWIO0PgE6v7a2isbBOFalFKz+Gdl9g2gwb9
         9Qum73AsxSQh4m5lDKHTbrD+G7P7E+vBNvT7HPhl5sHv+ylWQUp1eRVGRVvnLpo4Cp
         aq+8i5m+/gqj5l2lsKYbP/Bsyl9Nyah5djYIlSi4/Gi7IOPFcVnhxxFyY1oh+NitFR
         CPeK0aDRub8hOeT3bMiCRXv0159I6ptsP6IElL8r1s3d6j+xpgxlPe1l7nwZBl1MYb
         /L0FnzLkrUvHekRqCoPZBko2mAq962YevCQ5Ib2HOFe6NdByD/9Fhjo/IAi60G9EtW
         mhOslbLH0+JGg==
Date:   Fri, 6 Oct 2023 11:57:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Daan De Meyer <daan.j.demeyer@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: mkfs.xfs with --protofile does not copy extended attributes into
 the generated filesystem
Message-ID: <20231006185728.GY21298@frogsfrogsfrogs>
References: <CAO8sHc=UYg7SFh8DWYq6wRet2CW2P8tNr-pWRNJ2wN=+_qW17g@mail.gmail.com>
 <ZR8qWqksNx1kNhvi@dread.disaster.area>
 <20231006042250.GP21298@frogsfrogsfrogs>
 <ZR+OtcVIsVrJeqMO@dread.disaster.area>
 <20231006050451.GQ21298@frogsfrogsfrogs>
 <CAO8sHcmEXj4tVnLADGxX_k3nWGGVRiQueAkMVLMkAKBpPSMSGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO8sHcmEXj4tVnLADGxX_k3nWGGVRiQueAkMVLMkAKBpPSMSGg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 09:24:50AM +0200, Daan De Meyer wrote:
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
> > rsync doesn't support copying the fsxattr data (though it does support
> > extended attributes), and iirc xfsdump can only do entire filesystems,
> > right?
> 
> Additionally, when populating the filesystem in a regular file, to mount it
> we need loop devices and we need to be root. Both of which we want to
> avoid. So having an option to do this without mounting the filesystem like
> ext4 and btrfs have would be very useful. It doesn't have to be via '-p', I'm
> fine with a -d or --rootdir option like the ones that ext4 and btrfs
> have as well.

<shrug> How about libguestfs then?

--D

> Cheers,
> 
> Daan
> 
> On Fri, 6 Oct 2023 at 07:04, Darrick J. Wong <djwong@kernel.org> wrote:
> >
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
> > rsync doesn't support copying the fsxattr data (though it does support
> > extended attributes), and iirc xfsdump can only do entire filesystems,
> > right?
> >
> > --D
> >
> > > Cheers,
> > >
> > > Dave.
> > > --
> > > Dave Chinner
> > > david@fromorbit.com
