Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC10C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 22:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CFB65100
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 22:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhCIWfv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 17:35:51 -0500
Received: from mga12.intel.com ([192.55.52.136]:24682 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhCIWfn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 17:35:43 -0500
IronPort-SDR: BRi7TeKmc393rhtFXuyKIdvoMMxXfpjYv2j38XYHcaDHSyResMyHjAqkjTVanwSohgJkw0BaFm
 aFv7E9yT+pPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="167606720"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="167606720"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 14:35:42 -0800
IronPort-SDR: wwHwFVJVnD163V9weNIRiFFelXhoqLyoq1QGR2RP+DhOic6A0NhmCnfn5tpSEpllM4ePhxAvLV
 6RKfgDRL+JDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="369939989"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.54.74.11])
  by orsmga003.jf.intel.com with ESMTP; 09 Mar 2021 14:35:42 -0800
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 23426302F51; Tue,  9 Mar 2021 14:35:42 -0800 (PST)
From:   Andi Kleen <ak@linux.intel.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 15/45] xfs: CIL work is serialised, not pipelined
References: <20210305051143.182133-1-david@fromorbit.com>
        <20210305051143.182133-16-david@fromorbit.com>
        <20210308231432.GD3419940@magnolia>
        <20210308233819.GA74031@dread.disaster.area>
        <20210309015540.GY7269@magnolia>
Date:   Tue, 09 Mar 2021 14:35:42 -0800
In-Reply-To: <20210309015540.GY7269@magnolia> (Darrick J. Wong's message of
        "Mon, 8 Mar 2021 17:55:40 -0800")
Message-ID: <87ft14t0ox.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <djwong@kernel.org> writes:
> It might be nice to leave that as a breadcrumb, then, in case the
> spinlock scalability problems ever get solved.

It might be already solved, depending on if Dave's rule of thumb
was determined before the Linux spinlocks switched to MCS locks or not.

In my experience spinlock scalability depends a lot on how long the
critical section is (that is very important, short sections are a lot
worse than long sections), as well as if the contention is inside a
socket or over sockets, and the actual hardware behaves differently too.

So I would be quite surprised if the "rule of 4" generally holds.

-Andi
