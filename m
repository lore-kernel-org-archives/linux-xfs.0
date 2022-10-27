Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDC5ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 16:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbiJ0QxC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 12:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiJ0Qwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 12:52:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F4D19D88C;
        Thu, 27 Oct 2022 09:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HICjCe/T3KktXFKRv+wo+yHgKZxC3DJ5boYWFpCcesE=; b=ibo+HdQTm3+r0wK7uqOdAST2le
        gsw90CiCXIlAGkIzYEC7A+1vAxYVvC2H0hZ10bgepKdLD3/JvHNjHYDSLBj6+IMEOO2t04AEf1jU5
        lu5U0nhrME+intT5DAO17p3zcr7TRGet6GnYJ2BJhLU/oAH8PbQD7ZdsHHdw75fDQWPxqDqypniA2
        fTj5J2gsP69L25Yrd0GAmXLnost182Tc7hcAyZJFAw3ovutFVUEzk+DjqTdznsdJ2E+BrW0AIFxFL
        kvXKgp74xWaP05RzSk/0hHsCaffJDUb4wbrqJOGF1vL51uheP2Y1gdQ8hpRXL7tUPBTLBx0Q9kbfO
        u8asqKmQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oo662-006uvv-BB; Thu, 27 Oct 2022 16:51:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5D75330008D;
        Thu, 27 Oct 2022 18:51:09 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 374FA2C64658F; Thu, 27 Oct 2022 18:51:09 +0200 (CEST)
Date:   Thu, 27 Oct 2022 18:51:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Yujie Liu <yujie.liu@intel.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        fengwei.yin@intel.com, ying.huang@intel.com,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [tip:x86/core] [kallsyms] f138918162:
 WARNING:CPU:#PID:#at_fs/xfs/xfs_message.c:#xfs_buf_alert_ratelimited.cold-#[xfs]
Message-ID: <Y1q2/fdvXI67MRch@hirez.programming.kicks-ass.net>
References: <202210241614.2ae4c1f5-yujie.liu@intel.com>
 <Y1kDEmLeRA2UGeF8@hirez.programming.kicks-ass.net>
 <Y1kiuTIYobR4nexS@hirez.programming.kicks-ass.net>
 <Y1nobODPLUjcteJ0@yujie-X299>
 <2543dfb1-d9dc-0888-dbea-e420a19d732c@intel.com>
 <Y1qv3ku6ULHy8hOF@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1qv3ku6ULHy8hOF@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


> However, I noticed that the callsite in the WARNING: message has changed
> from the usual 'asswarn' (which is the caller of WARN_ON) to
> 'xfs_buf_alert_ratelimited', which seems totally wrong since XFS log
> recovery doesn't touch xfs_buf objects at all.

Yeah; and I've meanwhile found more cases where it goes sideways.

I'll revert this patch and try an alternative approach. I'll post
patches tomorrow or something.

Sorry about this.
