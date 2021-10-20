Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D86CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 11:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8609761373
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 11:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhJTLi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 07:38:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25756 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhJTLi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 07:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634729771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Xwys4rSlrSZ5q9NbXB42bFKNy4lu+mnuS2Gsh9V4Io=;
        b=I4L7XIHpYJQwIWwJ/AKthneacBGRM2rITXElTsTyPSGKuZAWiZ2y3ZIlzLHVwM46q6cHrC
        6cNXJQXv6qFd9tA6KwjTRkKAAnjiwd4refCyEUmKvKEZdl/C0O4u6dNDymHDIiobODlimM
        6+H25cNAUsR3Lc2WoaumgetK77MkLls=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-D7QQyqTfPxCmAkkv4TcN5w-1; Wed, 20 Oct 2021 07:36:10 -0400
X-MC-Unique: D7QQyqTfPxCmAkkv4TcN5w-1
Received: by mail-ed1-f71.google.com with SMTP id f4-20020a50e084000000b003db585bc274so20652530edl.17
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 04:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=4Xwys4rSlrSZ5q9NbXB42bFKNy4lu+mnuS2Gsh9V4Io=;
        b=vwverVow8xgHdxO+xyh0hH0wZ3rXc7plHe80sX7846+45+4HZ0FlvnyaXlu6UPqtpI
         dv0pe8e0husXRy9QyX+tBeEA8tExYjvLeQtTuOwuN+526lyAL4cqxYszpYfEjdqBE4Q7
         Dfk3m0EVW3u4kuCjWkag5rAUFAgbqP7nCTHHVYu7KZgdvHjOB8RysnpF0D2amdXCFXlS
         zjUt8Yxx8qXSjlBYWc/kL00lU9M5H0ddm139qqRLHumLDsDuLPuGNtUdytY9ykrw0tYA
         4CIbQnc+E6N0Azvs/ElElPeq+cKwrxRUzpziFWgy7whiSmwOlQAFdnsbreg+f5YWBsN3
         QToQ==
X-Gm-Message-State: AOAM531W22XCcJ0gACjRp4uutQr3Q7DAKm7VY0QbsWrRNV9GM0ZaLrdh
        6OCu/hfGm9OiB/TU9tSfwxvyZqf//U37tXQVS4PvfCgUNgqnf61NC3b65EaAc67b/tIk1EAl6dg
        Z0/F4twNA+l6Tlq5RaL/v
X-Received: by 2002:a17:906:c0d:: with SMTP id s13mr45667464ejf.309.1634729768964;
        Wed, 20 Oct 2021 04:36:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxadbEY6VL/YXdzT2Na+F13d+v8eoD/sjx8lZIknpq4DCbaPeoz5js7UniblZqJkobM86BC2w==
X-Received: by 2002:a17:906:c0d:: with SMTP id s13mr45667436ejf.309.1634729768697;
        Wed, 20 Oct 2021 04:36:08 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id z1sm1076887edc.68.2021.10.20.04.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:36:07 -0700 (PDT)
Date:   Wed, 20 Oct 2021 13:36:05 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Small project: Make it easier to upgrade root fs (i.e. to
 bigtime)
Message-ID: <20211020113605.ayzm2cxrexxjr5yl@andromeda.lan>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
References: <e5d00665-ff40-cd6a-3c5c-a022341c3344@sandeen.net>
 <20211019204418.GZ2361455@dread.disaster.area>
 <6f7d8d49-909a-f9f3-273c-8641eedb5ea2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f7d8d49-909a-f9f3-273c-8641eedb5ea2@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 19, 2021 at 04:04:14PM -0500, Eric Sandeen wrote:
> On 10/19/21 3:44 PM, Dave Chinner wrote:
> > On Tue, Oct 19, 2021 at 10:18:31AM -0500, Eric Sandeen wrote:
> > > Darrick taught xfs_admin to upgrade filesystems to bigtime and inobtcount, which is
> > > nice! But it operates via xfs_repair on an unmounted filesystem, so it's a bit tricky
> > > to do for the root fs.
> > > 
> > > It occurs to me that with the /forcefsck and /fsckoptions files[1], we might be able
> > > to make this a bit easier. i.e. touch /forcefsck and add "-c bigtime=1" to /fsckoptions,
> > > and then the initrd/initramfs should run xfs_repair with -c bigtime=1 and do the upgrade.
> > 
> > Does that happen before/after swap is enabled?

IIRC in general, it follows the /etc/fstab mount order, and to access that,
rootfs should be mounted, and, (also IIRC), the rootfs is mounted RO, and then
remounted RW once the boot pre-reqs are read, but I can confirm that.

> 
> > Also, ISTR historical problems with doing initrd based root fs
> > operations because it's not uncommon for the root filesystem to fail
> > to cleanly unmount on shutdown.  i.e. it can end up not having the
> > unmount record written because shutdown finishes with the superblock
> > still referenced. Hence the filesystem has to be mounted and the log
> > replayed before repair can be run on it....
> > 

I suppose this is already true nowadays? If /forcefsck exists, we are already
running fsck the on the rootfs, so, I wonder what happens nowadays, as I haven't
tried to use /forcefsck. But anyway, I don't think the behavior will be much
different from the current one. I should check what happens today..

> > > Does anyone see a problem with this?  If not, would anyone like to
> > > take this on as a small project?

If nobody has any objections, I'll be happy to work on this :)

Cheers
-- 
Carlos

