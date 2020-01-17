Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14FEC33CB6
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 11:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B920421582
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 11:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ro6qziJX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgAQLnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 06:43:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24353 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726876AbgAQLnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 06:43:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579261385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gd8m04MBeBFjlqqhoY1pGB2lRynPKyQkVinKGfYGuLE=;
        b=Ro6qziJXNxPLuSws0aZLi8pWmdSQq1iuWy+uronljlXTvn3fo7wTUDUR+PYZPLfFypfLKf
        jLYxbuEUdcdceW1ZtOhmVk/gBADym01GMgtreDsji9kCibUiWzuMml812mvP1t4do1PZYJ
        dRWKE1C60cm6xGWQAlFSaEVOOrsVx0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-3ZtNOC-EPnyeBRrPstvaeQ-1; Fri, 17 Jan 2020 06:43:02 -0500
X-MC-Unique: 3ZtNOC-EPnyeBRrPstvaeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90542108597A;
        Fri, 17 Jan 2020 11:42:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-49.rdu2.redhat.com [10.10.120.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F88910013A1;
        Fri, 17 Jan 2020 11:42:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <2397bb4a-2ca2-4b44-8c79-64efba9aa04d@www.fastmail.com>
References: <2397bb4a-2ca2-4b44-8c79-64efba9aa04d@www.fastmail.com> <20200114170250.GA8904@ZenIV.linux.org.uk> <3326.1579019665@warthog.procyon.org.uk> <9351.1579025170@warthog.procyon.org.uk>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     dhowells@redhat.com, "Colin Walters" <walters@verbum.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        "Christoph Hellwig" <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        adilger.kernel@dilger.ca,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Chris Mason" <clm@fb.com>, josef@toxicpanda.com, dsterba@suse.com,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Making linkat() able to overwrite the target
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <359590.1579261375.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 17 Jan 2020 11:42:55 +0000
Message-ID: <359591.1579261375@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Omar,

Do you still have your AT_REPLACE patches?  You said that you'd post a v4
series, though I don't see it.  I could make use of such a feature in
cachefiles inside the kernel.  For my original question, see:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Dfscache-iter

And do you have ext4 support for it?

Colin Walters <walters@verbum.org> wrote:

> On Tue, Jan 14, 2020, at 1:06 PM, David Howells wrote:
> =

> > Yes, I suggested AT_LINK_REPLACE as said magical flag.
> =

> This came up before right?
> =

> https://lore.kernel.org/linux-fsdevel/cover.1524549513.git.osandov@fb.co=
m/

David

