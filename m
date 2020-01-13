Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF77C33CAD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 11:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D39E3207E0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 11:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D81/IdPQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgAMLKf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 06:10:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29785 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726127AbgAMLKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 06:10:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578913832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QdRVhclazuJ7xDSVTKKwiIKmjUJuyn6jTN5TIX1NjAM=;
        b=D81/IdPQ+4dfBMmKlHzAvo4Spe4tBHyrdSghuGpE1U6z5UxwzfKbof8A644q7kvAJqN2ie
        tAjdybbbuNkmxCX4U0wQW2tt8DkrUYRSwjw493maznPfVzJdi0f0jYzp0vhix4OxhK7JTj
        rtQ1wQpXsZvNeBiscLXXjN4hhQsAvAo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-3DsMbj29MXiYzkLbQ0WQoQ-1; Mon, 13 Jan 2020 06:10:30 -0500
X-MC-Unique: 3DsMbj29MXiYzkLbQ0WQoQ-1
Received: by mail-wm1-f70.google.com with SMTP id n17so1244149wmk.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2020 03:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=QdRVhclazuJ7xDSVTKKwiIKmjUJuyn6jTN5TIX1NjAM=;
        b=r3E1PzmK/g35Ko2nk2pYplRwjwUNHMxP5YsOZPcUhKivPpneopzHmSAf6hiiouhZx1
         Crtx0fcY2GiuyzZ4RNX4SV9QeL3rrZerHP7mD1+NYV03wCyjkrswjdwoaIhorT9BaUj/
         Kown0cicyUfvHK+Fkc2ppe8SOhmEpzC5xCTOwRrzFB++ckAqhb/e/8vuEd9HjzkncAzW
         Bp2JjuFT1XPumYtVD85gbXCh20WmNN+JKUktNk7tf7Yb19dy92s0FotgFNSJUIyyuTkU
         5d/Kz0SsoKypPJ/H9npcULZPKYYqf1+G0yBdldMa8+AXgRgKRDmZujdSRd6OMBUMNb9H
         Du8g==
X-Gm-Message-State: APjAAAW9XTmnMP2K/F38NDN/COqMvnT58FDyVhCBpxK3HL1MxnBeyDjW
        KAvN/ZExlKxFZd9M8r8cV0nUFMI5XaPc2HMve7m7VZSddtu9bWWX1eXIGxv+QaTYYUUT5UQRS1w
        TkXVzPZRRJ72gLEdJmBrR
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr11901726wmi.104.1578913829044;
        Mon, 13 Jan 2020 03:10:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqxuHVxkP9PmcF4HxY/8UXkN+PpwoyUXgfVnpLUODAYcaZjLwZiQ+hmBNS0j+HHCleEYXiZbeg==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr11901701wmi.104.1578913828751;
        Mon, 13 Jan 2020 03:10:28 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id n189sm14362356wme.33.2020.01.13.03.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 03:10:28 -0800 (PST)
Date:   Mon, 13 Jan 2020 12:10:25 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink vs ThinLVM
Message-ID: <20200113111025.liaargk3sf4wbngr@orion>
Mail-Followup-To: Gionatan Danti <g.danti@assyoma.it>,
        linux-xfs@vger.kernel.org
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Gionatan.

On Mon, Jan 13, 2020 at 11:22:51AM +0100, Gionatan Danti wrote:
> Hi all,
> as RHEL/CentOS 8 finally ships with XFS reflink enabled, I was thinking on
> how to put that very useful feature to good use. Doing that, I noticed how
> there is a significant overlap between XFS CoW (via reflink) and dm-thin CoW
> (via LVM thin volumes).
> 
> I am fully aware that they are far from identical, both in use and scope:
> ThinLVM is used to create multiple volumes from a single pool, with
> volume-level atomic snapshot; on the other hand, XFS CoW works inside a
> single volume and with file-level atomic snapshot.
> 
> Still, in at least one use case they are quite similar: single-volume
> storage of virtual machine files, with vdisk-level snapshot. So lets say I
> have a single big volume for storing virtual disk image file, and using XFS
> reflink to take atomic, per file snapshot via a simple "cp --reflink
> vdisk.img vdisk_snap.img".
> 
> How do you feel about using reflink for such a purpose? Is the right tool
> for the job? Or do you think a "classic" approach with dmthin and lvm
> snapshot should be preferred? On top of my head, I can thin about the
> following pros and cons when using reflink vs thin lvm:
> 

> PRO:
> - xfs reflink works at 4k granularity;
> - significantly simpler setup and fs expansion, especially when staked
> devices (ie: vdo) are employed.
> 
> CONS:
> - xfs reflink works at 4k granularity, leading to added fragmentation
> (albeit mitigated by speculative preallocation?);
> - no filesystem-wide atomic snapshot (ie: various vdisk files are reflinked
> one-by-one, at small but different times).
> 
> Side note: I am aware of the fact that a snapshot taken without guest
> quiescing is akin to a crashed guest, but lets ignore that for the moment.
> 

First of all, I think there is no 'right' answer, but instead, use what best fit
you and your environment. As you mentioned, there are PROs and CONS for each
different solution.

I use XFS reflink to CoW my Virtual Machines I use for testing. As I know many
others do the same, and it works very well, but as you said. It is file-based
disk images, opposed to volume-based disk images, used by DM and LVM.man.

About your concern regarding fragmentation... The granularity is not really 4k,
as it really depends on the extent sizes. Well, yes, the fundamental granularity
is block size, but we basically never allocate a single block...

Also, you can control it by using extent size hints, which will help reduce the
fragmentation you are concerned about.
Check 'extsize' and 'cowextsize' arguments for mkfs.xfs and xfs_io.


Cheers

-- 
Carlos

