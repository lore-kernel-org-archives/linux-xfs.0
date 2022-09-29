Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1125C6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Sep 2022 08:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbiI2Ibr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Sep 2022 04:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiI2Ibq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2022 04:31:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC1BAFAD7
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 01:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 598C1B8239B
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 08:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D077C433D6;
        Thu, 29 Sep 2022 08:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664440303;
        bh=M92fyjQ9P3ptrxPd48ttnDFTAEtqEefqbfMEKIrRFRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZ6ngIGUxpJXnMkbNoPAhAq+z9lzMDT86M4BYbrv6gB54M5vfeLtFljNVF0ulQDHL
         oQjJOIHUy5GlApfn/ClU/fignEX7kjAYKw203WLcGRUy6hf8s3o5C2DTP5WMXoA1Hc
         J6rMgZeSiqNjc87KKuOzsLF9j/kIFdW+Hx/xNy2R0s153dwJYqlarW1ybU38n9HDq8
         O/VZXrPZZYQz2pYfChr+64c7LwuPPQA/fOaMDcGLw1JJS0mKyI2TKech5PpNxvtggH
         gVtbcTKrzkg0ysMaZ5CKL+sIc2+xqIDWuY4hDCJY9XAMO/9Hs9ruJJceWXyJv01r4L
         fh0CNUUJdKAUw==
Date:   Thu, 29 Sep 2022 10:31:38 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v6] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20220929083138.mp5vyluf7w5wkd7u@andromeda>
References: <20180316170720.44227-1-jtulak@redhat.com>
 <20180323143313.31277-1-jtulak@redhat.com>
 <b82zjalgqmFQ_K7yf9vKylqobjqFq97qjcI77Ds3qyjOvZ3eVh_STXDw_3mxh5PFH1cGOh4TPl0n-TCMyf3-EA==@protonmail.internalid>
 <YzPbd1nbb30Wd8ji@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzPbd1nbb30Wd8ji@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > +
> > +# The flag -f is added by systemd/init scripts when /forcefsck file is present
> > +# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
> > +# this check, user has to explicitly require a forced fsck.
> > +# But first of all, test if it is a non-interactive session.
> > +# Invoking xfs_repair via fsck.xfs is only intended to happen via initscripts.
> > +# Normal administrative filesystem repairs should always invoke xfs_repair
> > +# directly.
> > +#
> > +# Use multiple methods to capture most of the cases:
> > +# The case for *i* and -n "$PS1" are commonly suggested in bash manual
> > +# and the -t 0 test checks stdin
> > +case $- in
> > +	*i*) FORCE=false ;;
> > +esac
> > +if [ -n "$PS1" -o -t 0 ]; then
> > +	FORCE=false
> > +fi
> > +
> > +if $FORCE; then
> > +	XFS_REPAIR=`command -v xfs_repair`
> > +	if [ ! -x "$XFS_REPAIR" ] ; then
> > +		echo "$NAME error: xfs_repair was not found!" 1>&2
> > +		exit 4
> > +	fi
> > +
> > +	$XFS_REPAIR -e $DEV
> > +	repair2fsck_code $?
> 
> Just to reopen years-old discussions --
> 
> Recently, a customer decided to add "fsck.mode=force" to the kernel
> command line to force systemd to fsck the rootfs on boot.  They
> performed a powerfail simulation, and on next boot they were dropped to
> an emergency shell because the log was dirty and xfs_repair returned a
> nonzero error code.  If the system was rebooted cleanly then xfs_repair
> rebuilds the space metadata and exits quietly.
> 
> Earlier in this thread we decided not to do a mount/umount cycle to
> clear a dirty log for fear that the mount could crash the kernel.  Would
> anyone like to entertain the idea of adding that cycle to fsck.xfs if
> the program argv includes '-y' and xfs_repair returns 2?  That would
> only happen if the sysadmin *also* adds "fsck.repair=yes" to the kernel
> command line.
> 

I am not really opposed at it.

Particularly, I don't like the idea of the chance of unnoticed corruptions. And
I'm afraid this will just encourage some users to set fsck.mode=force
'by default', which I don't think is ideal. Not to mention, one of the advantages
of journaling FS'es is exactly avoid forcing a fsck at mount time :)

Anyway, this is just my $0.02, I'm not really opposed to this if people find
this useful somehow to avoid human interaction in case of a corrupted rootfs.

> Omitting a fsck.repair= setting means systemd passes -a to fsck instead
> of -y.
> 
> --D
> 
> > +	exit $?
> > +fi
> > +
> >  if $AUTO; then
> >  	echo "$0: XFS file system."
> >  else
> > diff --git a/man/man8/fsck.xfs.8 b/man/man8/fsck.xfs.8
> > index ace7252d..a51baf7c 100644
> > --- a/man/man8/fsck.xfs.8
> > +++ b/man/man8/fsck.xfs.8
> > @@ -21,6 +21,13 @@ If you wish to check the consistency of an XFS filesystem,
> >  or repair a damaged or corrupt XFS filesystem,
> >  see
> >  .BR xfs_repair (8).
> > +.PP
> > +However, the system administrator can force
> > +.B fsck.xfs
> > +to run
> > +.BR xfs_repair (8)
> > +at boot time by creating a /forcefsck file or booting the system with
> > +"fsck.mode=force" on the kernel command line.
> >  .
> >  .SH FILES
> >  .IR /etc/fstab .
> > --
> > 2.16.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos Maiolino
