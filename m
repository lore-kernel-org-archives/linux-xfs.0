Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09E5C33CB1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 14:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2B8B214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 14:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IwLPGwt8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgAOOff (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 09:35:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51429 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729139AbgAOOff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 09:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579098934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=02gzqhLOtgbp3kYs0sEj7toypycUFhqtBNRxiOLtfDo=;
        b=IwLPGwt81206FTl0a+78MJDXYYQNqhcjusuovIbSlWYU1JYTyWP9ujE8cNJOdFTFp3dBsx
        iEG3qlniPKOzkY3+Fbi3gIcWvmw27xjHXVIcarHsix2r1Vp9fT2mQSJNcIFcIrtMXWbC31
        MKNw1XCjM8rxCJC4zY2m4evBmmAAfzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-8SlNiMreOIWVPvbUAcL_5g-1; Wed, 15 Jan 2020 09:35:30 -0500
X-MC-Unique: 8SlNiMreOIWVPvbUAcL_5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12180802B79;
        Wed, 15 Jan 2020 14:35:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-52.rdu2.redhat.com [10.10.120.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B2AF5C28C;
        Wed, 15 Jan 2020 14:35:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200115133101.GA28583@lst.de>
References: <20200115133101.GA28583@lst.de> <4467.1579020509@warthog.procyon.org.uk> <00fc7691-77d5-5947-5493-5c97f262da81@gmx.com> <27181AE2-C63F-4932-A022-8B0563C72539@dilger.ca> <afa71c13-4f99-747a-54ec-579f11f066a0@gmx.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dhowells@redhat.com, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Andreas Dilger <adilger@dilger.ca>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problems with determining data presence by examining extents?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26092.1579098922.1@warthog.procyon.org.uk>
Date:   Wed, 15 Jan 2020 14:35:22 +0000
Message-ID: <26093.1579098922@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> If we can't get that easily it can be emulated using lseek SEEK_DATA /
> SEEK_HOLE assuming no other thread could be writing to the file, or the
> raciness doesn't matter.

Another thread could be writing to the file, and the raciness matters if I
want to cache the result of calling SEEK_HOLE - though it might be possible
just to mask it off.

One problem I have with SEEK_HOLE is that there's no upper bound on it.  Say
I have a 1GiB cachefile that's completely populated and I want to find out if
the first byte is present or not.  I call:

	end = vfs_llseek(file, SEEK_HOLE, 0);

It will have to scan the metadata of the entire 1GiB file and will then
presumably return the EOF position.  Now this might only be a mild irritation
as I can cache this information for later use, but it does put potentially put
a performance hiccough in the case of someone only reading the first page or
so of the file (say the file program).  On the other hand, probably most of
the files in the cache are likely to be complete - in which case, it's
probably quite cheap.

However, SEEK_HOLE doesn't help with the issue of the filesystem 'altering'
the content of the file by adding or removing blocks of zeros.

David

