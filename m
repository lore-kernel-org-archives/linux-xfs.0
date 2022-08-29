Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3615ECAAD4
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 22:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiH2WKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 18:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH2WKx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 18:10:53 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 640EA79EF6
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 15:10:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-4-169.pa.nsw.optusnet.com.au [49.195.4.169])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 62DFB62DA00;
        Tue, 30 Aug 2022 08:10:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oSmxz-001UMJ-W0; Tue, 30 Aug 2022 08:10:48 +1000
Date:   Tue, 30 Aug 2022 08:10:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: questions about hybird xfs wih ssd/hdd  by realtime subvol
Message-ID: <20220829221047.GU3600936@dread.disaster.area>
References: <20220829102619.AE3B.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220829102619.AE3B.409509F4@e16-tech.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=630d396a
        a=FOdsZBbW/tHyAhIVFJ0pRA==:117 a=FOdsZBbW/tHyAhIVFJ0pRA==:17
        a=IkcTkHD0fZMA:10 a=biHskzXt2R4A:10 a=H0umD5oqAAAA:8 a=VwQbUJbxAAAA:8
        a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8 a=jiEFvMsB7wAHyGiLJbAA:9
        a=QEXdDO2ut3YA:10 a=oZNyUrSE6F0A:10 a=du2hvLAJtKcNxoDMbUSS:22
        a=AjGcO6oz07-iQ99wixmX:22 a=i3VuKzQdj-NEYjvDI-p3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 29, 2022 at 10:26:20AM +0800, Wang Yugui wrote:
> Hi,
> 
> I saw some info about hybird xfs wih ssd/hdd  by realtime subvol.
> 
> Hybrid XFS—Using SSDs to Supercharge HDDs at Facebook
> https://www.usenix.org/conference/srecon19asia/presentation/shamasunder

....

> Is there any tool/kernel option/kernel patch to control the data to save
> into normal vol or realtime subvol firstly?

FB were running a modified kernel that selected the rt dev based on
the initial allocation size. Behaviour for them was predictable
because they also controlled the application that was storing the
data. See:

https://lore.kernel.org/linux-xfs/20171128215527.2510350-1-rwareing@fb.com/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
