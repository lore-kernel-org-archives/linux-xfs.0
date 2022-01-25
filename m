Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3860C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 02:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351167AbiAYCKg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:10:36 -0500
Received: from host195-56-237-212.serverdedicati.aruba.it ([212.237.56.195]:56910
        "EHLO plutone.assyoma.it" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S3414081AbiAYAmp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 19:42:45 -0500
Received: from webmail.assyoma.it (localhost [IPv6:::1])
        by plutone.assyoma.it (Postfix) with ESMTPA id AA40BDC97CC2;
        Tue, 25 Jan 2022 01:42:42 +0100 (CET)
MIME-Version: 1.0
Date:   Tue, 25 Jan 2022 01:42:42 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: CFQ or BFQ scheduler and XFS
In-Reply-To: <20220124211329.GM59729@dread.disaster.area>
References: <8bb2c601dfffd38c2809c7c6f6a369a5@assyoma.it>
 <20220123225201.GK59729@dread.disaster.area>
 <cc75ce7be96964eb1b95783b3fb16158@assyoma.it>
 <20220124211329.GM59729@dread.disaster.area>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <f9b5cb7a4f874c63843bbbed37d02375@assyoma.it>
X-Sender: g.danti@assyoma.it
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 2022-01-24 22:13 Dave Chinner ha scritto:
> No, the opposite. e.g. thread A does IO and then runs fsync(), which
> needs to force the log, that triggers CIL push work which runs in a
> different thread B.  Thread A blocks waiting for the CIL push,
> thread B runs immediately.  Thread B then issues log IO, but the IO
> from thread B is queued by CFQ because thread A's timeslice hasn't
> expired. Hence log force is delayed until thread A's timeslice
> expires, even though it is being done on behalf of thread A and
> thread A is blocked until the IO from Thread B is scheduled and
> completed.

Hi Dave,
ok, I can see now why it is so bad (especially when multiple threads are 
involved).

> 
> No idea - I use noop for everything these days because IO schedulers
> often cause more problems than they solve on SSDs, sparse virtual
> machine images, thinly provisioned storage, etc....
> 
> Cheers,
> 
> Dave.

Right...

Thank you so much for the clear explanation.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
