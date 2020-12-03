Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554BCC4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00BDE207B8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgLCUQh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:16:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728032AbgLCUQg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:16:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607026510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gK+7PbidYO3ZIXUKWgA3YA1HTz0ROqT+BtZSIAPfma8=;
        b=IRI+687Vm5n/0dd4471zzjqQUup0IV1pZBc8zYkrmp13cyEL3wHq2IuZO7M1mH7hA1GpAn
        R1rWGJ+8OKsnowL33+Qx2g03/fp+9Ict5k7SVI9zj30dXkky5Z2aqa+36bkfiUCs8zMZFy
        6tQPKzUVM3uXvosujantb1xEykiIQAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-mwhsd2ZgNwi6tNvVGA5blg-1; Thu, 03 Dec 2020 15:15:08 -0500
X-MC-Unique: mwhsd2ZgNwi6tNvVGA5blg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0AD0BBEE2;
        Thu,  3 Dec 2020 20:15:06 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD15D5D6AC;
        Thu,  3 Dec 2020 20:15:06 +0000 (UTC)
Subject: Re: [PATCH 3/3] xfs_quota: make manpage non-male-specific
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <9fde98da-d221-87d0-a401-2c82cf1df35f@redhat.com>
 <20201203201032.GL106272@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <77fc2a55-c129-56f9-ebd1-dc75cf4478a5@redhat.com>
Date:   Thu, 3 Dec 2020 14:15:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201203201032.GL106272@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/3/20 2:10 PM, Darrick J. Wong wrote:
> On Thu, Dec 03, 2020 at 02:01:24PM -0600, Eric Sandeen wrote:
>> Users are not exclusively male, so fix that implication.
> 
> Why not fix configure.ac too?  Surely ./configure users are not also
> exclusively male? ;)
> 
> "If the user choses a different prefix assume he just wants..."

hm ok, I only searched man pages.

xfsprogs: don't be male-specific? :)

-Eric

