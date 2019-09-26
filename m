Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64A9C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 13:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD00C222BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 13:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfIZNFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 09:05:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfIZNFM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 09:05:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9C1830A8181;
        Thu, 26 Sep 2019 13:05:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 739085C21A;
        Thu, 26 Sep 2019 13:05:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <e31c4e16d1e056767f8997145df6f4b800398469.camel@themaw.net>
References: <e31c4e16d1e056767f8997145df6f4b800398469.camel@themaw.net> <156933112949.20933.12761540130806431294.stgit@fedora-28> <156933135322.20933.2166438700224340142.stgit@fedora-28> <20190926041427.GT26530@ZenIV.linux.org.uk>
To:     Ian Kent <raven@themaw.net>
Cc:     dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 06/16] xfs: mount-api - make xfs_parse_param() take context .parse_param() args
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22938.1569503110.1@warthog.procyon.org.uk>
Date:   Thu, 26 Sep 2019 14:05:10 +0100
Message-ID: <22939.1569503110@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 26 Sep 2019 13:05:12 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ian Kent <raven@themaw.net> wrote:

> The only other thing relevant to either case is messages not going
> to the kernel log if fsconfig() is being used which could make problem
> resolution more difficult.

Maybe we should just remove this entirely.  It's only partially capable since
I wasn't allowed to add a per-task message buffer, so it can't help you with
interior mounts - as done by NFS - or automounts.

David
