Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29CBC33CB2
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A09C214AF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:54:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XsiiT/KP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgA1QyX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 11:54:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42001 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725881AbgA1QyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 11:54:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580230462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Pj9JBvDmpFs4aXk7GXxiHClP/EscFcAWKjyAVjUjggo=;
        b=XsiiT/KPMduYir3+gLIh8TqzhTD1USxcgjFC9ExKGPw/6CPH3fmJpb6h/Qx0Khag6sYlnI
        uXdGoNIIR+dYyNDKz1JBtv6nPnw9GrY2uka1V49RjgKbdXzEzjVxxdCPlARovx8I7Tzjm+
        eLGOIkE5ZkiYPPrdcq5RNXjp7omGSCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-IV7kBx0LMU2OdEOiO-jyaw-1; Tue, 28 Jan 2020 11:54:19 -0500
X-MC-Unique: IV7kBx0LMU2OdEOiO-jyaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89B96100550E;
        Tue, 28 Jan 2020 16:54:18 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2ECD780A5C;
        Tue, 28 Jan 2020 16:54:18 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: mkfs: don't default to the physical sector size if it's bigger than XFS_MAX_SECTORSIZE
References: <x49h80ftviy.fsf@segfault.boston.devel.redhat.com>
        <20200128161423.GO3447196@magnolia>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 28 Jan 2020 11:54:17 -0500
Message-ID: <x49zhe7serq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> Do we need to check that ft->lsectorsize <= XFS_MAX_SECTORSIZE too?

We can.  What would be the correct response to such a situation?

> (Not that I really expect disks with 64k LBA units...)

It looks like you can tell loop to do that, but I wasn't able to make
that happen in practice.  I'm not quite sure why, though.

-Jeff

