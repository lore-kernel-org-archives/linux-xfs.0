Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A41C35247
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 18:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C9D2084E
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 18:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ezkaz9ZY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgBDSiN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 13:38:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24405 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727308AbgBDSiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 13:38:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580841492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sPOWjs8UQdIupics/bzSdG2x1PB/kyOBhzzZKyHS4nY=;
        b=Ezkaz9ZY1NifF7lB15EjUc/hJw3JGSrTFbQMDPzDRm28JlrnPnqIuF/aTKauDCatfs7fbM
        GsP7Yv0XQEv/wTv6L0sC8OKCdMb0KMdh0B4/Tq/XP3xv4yzGnBNS+GnRXyt1DieSh0mKJa
        DOWjG/gOH6sG5EO8RPmRuu3gIKxyQOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-B0VvljFYNei0U9Vs04RiAQ-1; Tue, 04 Feb 2020 13:38:09 -0500
X-MC-Unique: B0VvljFYNei0U9Vs04RiAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07FDD8010F8;
        Tue,  4 Feb 2020 18:38:09 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A20FE1A7E3;
        Tue,  4 Feb 2020 18:38:08 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: mkfs: don't default to the physical sector size if it's bigger than XFS_MAX_SECTORSIZE
References: <x49h80ftviy.fsf@segfault.boston.devel.redhat.com>
        <20200128161423.GO3447196@magnolia>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 04 Feb 2020 13:38:07 -0500
In-Reply-To: <20200128161423.GO3447196@magnolia> (Darrick J. Wong's message of
        "Tue, 28 Jan 2020 08:14:23 -0800")
Message-ID: <x49r1zayz8w.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> On Tue, Jan 28, 2020 at 11:07:01AM -0500, Jeff Moyer wrote:
>> Hi,
>> 
>> In testing on ppc64, I ran into the following error when making a file
>> system:
>> 
>> # ./mkfs.xfs -b size=65536 -f /dev/ram0
>> illegal sector size 65536
>> 
>> Which is odd, because I didn't specify a sector size!  The problem is
>> that validate_sectorsize defaults to the physical sector size, but in
>> this case, the physical sector size is bigger than XFS_MAX_SECTORSIZE.
>> 
>> # cat /sys/block/ram0/queue/physical_block_size 
>> 65536
>> 
>> Fall back to the default (logical sector size) if the physical sector
>> size is greater than XFS_MAX_SECTORSIZE.
>
> Do we need to check that ft->lsectorsize <= XFS_MAX_SECTORSIZE too?

Actually, that's done later in the same function:

        /* validate specified/probed sector size */
        if (cfg->sectorsize < XFS_MIN_SECTORSIZE ||
            cfg->sectorsize > XFS_MAX_SECTORSIZE) {
                fprintf(stderr, _("illegal sector size %d\n"), cfg->sectorsize);
                usage();
        }

-Jeff

