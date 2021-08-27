Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC9EC432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 14:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D57060F25
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 14:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245215AbhH0OEJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 10:04:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244821AbhH0OEJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 10:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630073000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2lt6Yes5E/3PjDitXMdNmO251tRFrirKX9df5TbSHsM=;
        b=a/FA+wBlZTnsD0JrsALt//2z103mpqm/nNGNBYsymRDarnZQpTbjPZrz7aJWzBa5zfokk1
        l2E+xgcxttcgcVTgL3aA51bUSSmtm13cuvGLfgnFIwRde0RiKJRq9R0mhEJlYhvbLgdAle
        bYqkkIVtZwJ0GX2uUwm/6Sj3BV9zHdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-VBdADjvePx-IcXiS-_fJeA-1; Fri, 27 Aug 2021 10:03:16 -0400
X-MC-Unique: VBdADjvePx-IcXiS-_fJeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92672802CB4;
        Fri, 27 Aug 2021 14:03:15 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E985960C81;
        Fri, 27 Aug 2021 14:03:14 +0000 (UTC)
Date:   Fri, 27 Aug 2021 09:03:12 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: dax: facilitate EXPERIMENTAL warning for dax=inode
 case
Message-ID: <20210827140312.vzrwee5keck67w5p@redhat.com>
References: <20210826173012.273932-1-bodonnel@redhat.com>
 <20210826180947.GL12640@magnolia>
 <f6ddf52a-0b85-665a-115e-106242b1af95@sandeen.net>
 <20210826220841.jsdlbquqq55cetnu@redhat.com>
 <9a9d54bd-42a5-45c7-38b2-dec12c49defc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a9d54bd-42a5-45c7-38b2-dec12c49defc@sandeen.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 06:43:44PM -0500, Eric Sandeen wrote:
> On 8/26/21 5:08 PM, Bill O'Donnell wrote:
> > On Thu, Aug 26, 2021 at 01:16:22PM -0500, Eric Sandeen wrote:
> > > 
> > > On 8/26/21 1:09 PM, Darrick J. Wong wrote:
> > > > On Thu, Aug 26, 2021 at 12:30:12PM -0500, Bill O'Donnell wrote:
> > > 
> > > > > @@ -1584,7 +1586,7 @@ xfs_fs_fill_super(
> > > > >    	if (xfs_has_crc(mp))
> > > > >    		sb->s_flags |= SB_I_VERSION;
> > > > > -	if (xfs_has_dax_always(mp)) {
> > > > > +	if (xfs_has_dax_always(mp) || xfs_has_dax_inode(mp)) {
> > > > 
> > > > Er... can't this be done without burning another feature bit by:
> > > > 
> > > > 	if (xfs_has_dax_always(mp) || (!xfs_has_dax_always(mp) &&
> > > > 				       !xfs_has_dax_never(mp))) {
> > > > 		...
> > > > 		xfs_warn(mp, "DAX IS EXPERIMENTAL");
> > > > 	}
> > > 
> > > changing this conditional in this way will also fail dax=inode mounts on
> > > reflink-capable (i.e. default) filesystems, no?
> > 
> > Correct. My original patch tests fine, and still handles the reflink and dax
> > incompatibility. The new suggested logic is problematic.
> > -Bill
> 
> I think that both your proposed patch and Darrick's suggestion have this problem.
> 
> "mount -o dax=inode" makes your new xfs_has_dax_inode(mp) true, and in that
> conditional, if the filesystem has reflink enabled, mount fails:
> 
> # mkfs.xfs -f /dev/pmem0p1
> meta-data=/dev/pmem0p1           isize=512    agcount=4, agsize=4194304 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=16777216, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=8192, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # mount -o dax=inode /dev/pmem0p1 /mnt/test
> mount: wrong fs type, bad option, bad superblock on /dev/pmem0p1,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> 
> # dmesg | tail -n 2
> [  192.691733] XFS (pmem0p1): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [  192.700300] XFS (pmem0p1): DAX and reflink cannot be used together!
> 

So, the "DAX enabled" is a misnomer in this case. However the incompatibility of DAX and reflink is
reflected in the next message, and indeed the mount fails. Is it now a matter of fixing
the message output so as not to indicate "DAX enabled..."?

Thanks-
Bill

