Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2139C33C9E
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 18:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BDA12084D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 18:55:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PsZOg2dq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgANSzy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 13:55:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52133 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbgANSzy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 13:55:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579028153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EhZHv8iNQCa35xCWnRUQPp9lfdnuViJaH22n40GrRTo=;
        b=PsZOg2dq8EyGEWorKrjZX41TU2Gg3PKuyRfxGR6tgjqABkPNEEzgpszVSfaq3jIilbGDZ5
        snnYrniy1jwxLEkkkU7iWYNRrUjDx0tZ8OcEzTWEgFEDymY9fzJdSQCiuh9YzwL71JpMr7
        1qdzsB36HqhYHG25zkv7LLC276PrfSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Eu7dLCFyNbW25loSeKj39w-1; Tue, 14 Jan 2020 13:55:49 -0500
X-MC-Unique: Eu7dLCFyNbW25loSeKj39w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 823AE10509B8;
        Tue, 14 Jan 2020 18:55:47 +0000 (UTC)
Received: from llong.remote.csb (ovpn-122-218.rdu2.redhat.com [10.10.122.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B79555DA32;
        Tue, 14 Jan 2020 18:55:43 +0000 (UTC)
Subject: Re: [PATCH 02/12] locking/rwsem: Exit early when held by an anonymous
 owner
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20200114161225.309792-1-hch@lst.de>
 <20200114161225.309792-3-hch@lst.de>
 <925d1343-670e-8f92-0e73-6e9cee0d3ffb@redhat.com>
 <20200114182514.GA9949@lst.de>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <8fae9cfa-93b0-4d54-6d16-35e920e25b6c@redhat.com>
Date:   Tue, 14 Jan 2020 13:55:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200114182514.GA9949@lst.de>
Content-Type: multipart/mixed;
 boundary="------------6BEFFBDE05D958EEDA91B3B4"
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------6BEFFBDE05D958EEDA91B3B4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 1/14/20 1:25 PM, Christoph Hellwig wrote:
> On Tue, Jan 14, 2020 at 01:17:45PM -0500, Waiman Long wrote:
>> The owner field is just a pointer to the task structure with the lower 3
>> bits served as flag bits. Setting owner to RWSEM_OWNER_UNKNOWN (-2) will
>> stop optimistic spinning. So under what condition did the crash happen?
> When running xfstests with all patches in this series except for this
> one, IIRC in generic/114.

Could you try the attached patch to see if it can fix the problem?

Thanks,
Longman


--------------6BEFFBDE05D958EEDA91B3B4
Content-Type: text/x-patch;
 name="0001-locking-rwsem-Fix-kernel-crash-when-spinning-on-RWSE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-locking-rwsem-Fix-kernel-crash-when-spinning-on-RWSE.pa";
 filename*1="tch"

From 1fcfa946609b5e919a6b953a64be6853af5cdf05 Mon Sep 17 00:00:00 2001
From: Waiman Long <longman@redhat.com>
Date: Tue, 14 Jan 2020 13:39:02 -0500
Subject: [PATCH] locking/rwsem: Fix kernel crash when spinning on
 RWSEM_OWNER_UNKNOWN

The commit 91d2a812dfb9 ("locking/rwsem: Make handoff writer
optimistically spin on owner") will allow a recently woken up waiting
writer to spin on the owner. Unfortunately, if the owner happens to be
RWSEM_OWNER_UNKNOWN, the code will incorrectly spin on it leading to a
kernel crash. This is fixed by passing the proper non-spinnable bits
to rwsem_spin_on_owner() so that RWSEM_OWNER_UNKNOWN will be treated
as a non-spinnable target.

Fixes: 91d2a812dfb9 ("locking/rwsem: Make handoff writer optimistically spin on owner")

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/locking/rwsem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 44e68761f432..1dd3d53f43c3 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1227,7 +1227,7 @@ rwsem_down_write_slowpath(struct rw_semaphore *sem, int state)
 		 * without sleeping.
 		 */
 		if ((wstate == WRITER_HANDOFF) &&
-		    (rwsem_spin_on_owner(sem, 0) == OWNER_NULL))
+		    rwsem_spin_on_owner(sem, RWSEM_NONSPINNABLE) == OWNER_NULL)
 			goto trylock_again;
 
 		/* Block until there are no active lockers. */
-- 
2.18.1


--------------6BEFFBDE05D958EEDA91B3B4--

