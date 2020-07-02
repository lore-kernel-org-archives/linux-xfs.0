Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE4FC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 11:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED19720723
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 11:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKB/Lofk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgGBLeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 07:34:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38324 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgGBLeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 07:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593689684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R597LcNPgLCyE+PqqLTwMXF37wXcJJGanBDAHzf99MQ=;
        b=BKB/Lofk61mMl3LY+jRi03hrQTfmYBqUw/sItmNurYzGDvQ1XhOG4jIn7wYa06+u46mAhV
        ao6ppcwtAZmyER+ae4NoKc1rGGc/uU7e2uMwLrMm34avYCgarAjzcNLnuPwbbsp7dg2vQ5
        bVuXESfOcdQNgUdXhgdoeY+tTjglpJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-b_r5NOs4Mbaf24X92nH66A-1; Thu, 02 Jul 2020 07:34:40 -0400
X-MC-Unique: b_r5NOs4Mbaf24X92nH66A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A99AF107ACF4;
        Thu,  2 Jul 2020 11:34:39 +0000 (UTC)
Received: from bfoster (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EBFF7419D;
        Thu,  2 Jul 2020 11:34:38 +0000 (UTC)
Date:   Thu, 2 Jul 2020 07:34:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Diego Zuccato <diego.zuccato@unibo.it>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Separate user- and project- quota ?
Message-ID: <20200702113437.GA55314@bfoster>
References: <93882c1f-f26e-96c7-0a60-68fc9381e36c@unibo.it>
 <2c0bfee3-01cc-65cf-2be1-1af9432a18be@sandeen.net>
 <df054c4d-a1e1-2425-3319-dafa88fc9f08@unibo.it>
 <9c64b36f-8222-a031-b458-9b15d8e6831f@sandeen.net>
 <cb98acba-ebbd-5b45-36bd-0ee292449615@unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb98acba-ebbd-5b45-36bd-0ee292449615@unibo.it>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:14:01AM +0200, Diego Zuccato wrote:
> Il 01/07/20 20:46, Eric Sandeen ha scritto:
> 
> > Hm, yes, worth a look.  All 3 have been supported together for quite some
> > time now, I didn't know it reacted badly on old filesystems.
> > What did the failure look like?
> Boot failure saying something about superblock not supporting both
> group- and project- quotas at the same time.
> I think it's related to
> XFS (dm-0): Mounting V4 Filesystem
> As I said, it' quite an old fs :)
> 
> xfs_info reports:
> meta-data=/dev/sdb1      isize=256    agcount=41, agsize=268435455 blks
>          =               sectsz=512   attr=2, projid32bit=0
>          =               crc=0        finobt=0, sparse=0, rmapbt=0
>          =               reflink=0
> data     =               bsize=4096   blocks=10742852608, imaxpct=5
>          =               sunit=0      swidth=0 blks
> naming   =version 2      bsize=4096   ascii-ci=0, ftype=0
> log      =internal log   bsize=4096   blocks=521728, version=2
>          =               sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none           extsz=4096   blocks=0, rtextents=0
> 
> Too bad it's a production server (serving the home for the cluster) and
> I can't down it now.
> 

I missed how this went from a question around interaction between user
and project quotas to reporting of a problem associated with enablement
of group+project quotas and an old fs. The above shows a v4 superblock
(crc=0), which means project and group quotas share an inode and thus
are mutually exclusive. It sounds to me that the problem is simply that
you're specifying a set of incompatible mount options on a v4 fs, but
you haven't really stated the problem clearly. I.e.:

# mount /dev/test/scratch /mnt/ -o gquota,pquota
mount: /mnt: wrong fs type, bad option, bad superblock on /dev/mapper/test-scratch, missing codepage or helper program, or other error.
# dmesg | tail
[  247.554345] XFS (dm-3): Super block does not support project and group quota together

We have to fail in this scenario (as opposed to randomly picking one)
because either one can work for any mount (presumably wiping out the old
quotas when changing from one mode to the other across a mount).

Brian

> -- 
> Diego Zuccato
> DIFA - Dip. di Fisica e Astronomia
> Servizi Informatici
> Alma Mater Studiorum - Università di Bologna
> V.le Berti-Pichat 6/2 - 40127 Bologna - Italy
> tel.: +39 051 20 95786
> 

