Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F35C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 07:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241940AbiAXHzm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 02:55:42 -0500
Received: from host195-56-237-212.serverdedicati.aruba.it ([212.237.56.195]:57893
        "EHLO plutone.assyoma.it" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S236059AbiAXHzl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 02:55:41 -0500
Received: from webmail.assyoma.it (localhost [IPv6:::1])
        by plutone.assyoma.it (Postfix) with ESMTPA id 7D82FDDDDDF6;
        Mon, 24 Jan 2022 08:55:38 +0100 (CET)
MIME-Version: 1.0
Date:   Mon, 24 Jan 2022 08:55:38 +0100
From:   Gionatan Danti <g.danti@assyoma.it>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: CFQ or BFQ scheduler and XFS
In-Reply-To: <20220123225201.GK59729@dread.disaster.area>
References: <8bb2c601dfffd38c2809c7c6f6a369a5@assyoma.it>
 <20220123225201.GK59729@dread.disaster.area>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <cc75ce7be96964eb1b95783b3fb16158@assyoma.it>
X-Sender: g.danti@assyoma.it
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 2022-01-23 23:52 Dave Chinner ha scritto:
> CFQ doesn't understand that IO from different threads/tasks are
> related and so it cannot account for/control multi-threaded IO
> workloads.  Given that XFS's journal IO is inherently a
> multi-threaded IO workload, CFQ IO accounting and throttling simply
> does not work properly with XFS or any other filesystem that
> decouples IO from the user task context that requires the IO to be
> done on it's behalf.

Hi Dave,
ah, so it forces all threads under the same time slice? I thought it was 
thread aware...
Is it the same even for BFQ?

> And, as per above, that's exactly why it doesn't work well with XFS...
> 
> Read starvation during sequential writes sounds more like a problem
> with the block layer writeback throttle or something you need to
> use an IO controller (blk-cgroups) to address, not try to fix with a
> IO scheduler...

To tell the truth, I simply disabled NCQ on the affected drive. I don't 
think anything is wrong with the block layer simply because I can 
constantly replicate the random read starvation by running, at the same 
time, the following fio commands against the raw block device:

fio --name=test --filename=/dev/sda --direct=1 --rw=read --runtime=30    
  #seq read
fio --name=test --filename=/dev/sda --direct=1 --rw=randread 
--runtime=30 #rnd read

The first fio sucks almost any resources, leaving the randread process 
with ~2 IOPS with frequent drops to 0.
Using CFQ seems to avoid total starvation, but I then remembered it has 
some scalability and performance issues.
Disabling NCQ solves the issue, at the cost of not using any hardware 
queue (obviously).

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
