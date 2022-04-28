Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA104C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 03:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242203AbiD1Dev (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 23:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242206AbiD1Deu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 23:34:50 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FCD97DA9F
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 20:31:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 83AFE10E5F4D;
        Thu, 28 Apr 2022 13:31:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njusP-005Opx-6n; Thu, 28 Apr 2022 13:31:33 +1000
Date:   Thu, 28 Apr 2022 13:31:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] io/mmap.c: fix musl build on mips64
Message-ID: <20220428033133.GR1098723@dread.disaster.area>
References: <20220418203606.760110-1-fontaine.fabrice@gmail.com>
 <20220418230222.GN1544202@dread.disaster.area>
 <CAPi7W8206zDwkfbw4ruQ2B+TN+E3XX2NQ35mtzMT+aQ2+6BYAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPi7W8206zDwkfbw4ruQ2B+TN+E3XX2NQ35mtzMT+aQ2+6BYAw@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=626a0a96
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=EMJQmhU37cHKYb5OrV8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 09:54:02PM +0200, Fabrice Fontaine wrote:
> Hi,
> 
> Were you able to go further in your tests?

I've looked into it a bit more, and this is a string that ends in a
big tangled ball that I do not have time to untangle right now.

Can you please fix the commit message to indicate why moving the
header file avoids the build issue so we have a record of the reason
for the issue occuring in the commit history?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
