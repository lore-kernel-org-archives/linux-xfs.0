Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C808FC77B70
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Apr 2023 08:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjDNIRB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Apr 2023 04:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjDNIQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 04:16:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C780F7AB8;
        Fri, 14 Apr 2023 01:16:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 06A211FD93;
        Fri, 14 Apr 2023 08:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681460171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AcyGnHXf1H55h8xNhp8GjpAGA7SaHNrd2EolJsHcuyg=;
        b=cSbVGACM8ZaPvQjq6uwolfJvnBYOFaHNzFjpdiTFjrV73eAX32W+zTksofPpahr0D05PJW
        0+Em3r5KZQdq7pJX6XekpPMEemB6a6s+gxGFJK4WA9nVmSf6L1g228aGHsc7gbpfS2dxF2
        rkRaldFuAbbzp0jy++YxPJZNaJUZTF4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DEDEC139FC;
        Fri, 14 Apr 2023 08:16:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ODQSNMoLOWQVYwAAMHmgww
        (envelope-from <mhocko@suse.com>); Fri, 14 Apr 2023 08:16:10 +0000
Date:   Fri, 14 Apr 2023 10:16:07 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 2/3] mm: vmscan: move set_task_reclaim_state() near
 flush_reclaim_state()
Message-ID: <ZDkLx7jIkQczYqLY@dhcp22.suse.cz>
References: <20230413104034.1086717-1-yosryahmed@google.com>
 <20230413104034.1086717-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413104034.1086717-3-yosryahmed@google.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 13-04-23 10:40:33, Yosry Ahmed wrote:
> Move set_task_reclaim_state() near flush_reclaim_state() so that all
> helpers manipulating reclaim_state are in close proximity.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Michal Hocko <mhocko@suse.com>
-- 
Michal Hocko
SUSE Labs
