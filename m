Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD20C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Jan 2022 21:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240231AbiAWVeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Jan 2022 16:34:09 -0500
Received: from host195-56-237-212.serverdedicati.aruba.it ([212.237.56.195]:62922
        "EHLO plutone.assyoma.it" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S235024AbiAWVeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jan 2022 16:34:09 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jan 2022 16:34:09 EST
Received: from webmail.assyoma.it (localhost [IPv6:::1])
        by plutone.assyoma.it (Postfix) with ESMTPA id 031CBDDDCBCF
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jan 2022 22:27:32 +0100 (CET)
MIME-Version: 1.0
Date:   Sun, 23 Jan 2022 22:27:32 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
To:     linux-xfs@vger.kernel.org
Subject: CFQ or BFQ scheduler and XFS
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <8bb2c601dfffd38c2809c7c6f6a369a5@assyoma.it>
X-Sender: g.danti@assyoma.it
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi list,
I have a question about CFQ scheduler and the old warning one can find 
on the faq page: "As of kernel 3.2.12, the default i/o scheduler, CFQ, 
will defeat much of the parallelization in XFS".

Can I ask for more information about the bad interaction between CFQ and 
XFS, and especially why it does defeat filesystem parallelization? Is 
this warning still valid? What about the newer BFQ?

Note: I always used deadline or noop with XFS, but I am facing a disk 
with random read starvation when NCQ is enabled and a mixed sequential & 
random load happens. So far I saw that the only scheduler (somewhat) 
immune to the issue is CFQ, probably because it does not mix IO from 
multiple processes (it issue IO from one process at time, if I 
understand it correctly).

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
