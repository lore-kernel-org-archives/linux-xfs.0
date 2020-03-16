Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB32DC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 03:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E5F220663
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 03:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=firstfloor.org header.i=@firstfloor.org header.b="esZutmO0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgCPDhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Mar 2020 23:37:23 -0400
Received: from one.firstfloor.org ([193.170.194.197]:60350 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbgCPDhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Mar 2020 23:37:23 -0400
Received: by one.firstfloor.org (Postfix, from userid 503)
        id 69C2686848; Mon, 16 Mar 2020 04:37:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1584329839;
        bh=FixnRze9CuGCBQt3R3GyvExcHQzpYMq+rQcsBZ46s18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=esZutmO0TlABkZe0rlhwE00eJSKSZ2EoRkLzsNC7hd+3PlVWorKnkjneZm1cATGpt
         vzJUHSRBMLly+A9S0P9Wtd1cW9+EA63zRijyMbAR2pztSHY8nctDiyVmT44NSlNnQ3
         di0QJjaUWJk/VOra9ifxuh3m6VD+zZlbWHVERtIQ=
Date:   Sun, 15 Mar 2020 20:37:19 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Andi Kleen <andi@firstfloor.org>, linux-xfs@vger.kernel.org
Subject: Re: Shutdown preventing umount
Message-ID: <20200316033717.bnofrpg5yrciyhvz@two.firstfloor.org>
References: <20200314133107.4rv25sp4bvhbjjsx@two.firstfloor.org>
 <20200316020342.GP10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316020342.GP10776@dread.disaster.area>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 01:03:42PM +1100, Dave Chinner wrote:
> On Sat, Mar 14, 2020 at 06:31:10AM -0700, Andi Kleen wrote:
> > 
> > Hi,
> > 
> > I had a cable problem on a USB connected XFS file system, triggering 
> > some IO errors, and the result was that any access to the mount point
> > resulted in EIO. This prevented unmounting the file system to recover
> > from the problem. 
> 
> Full dmesg output, please.

http://www.firstfloor.org/~andi/dmesg-xfs-umount

> > 
> > XFS (...): log I/O error -5
> > 
> > scsi 7:0:0:0: rejecting I/O to dead device
> 
> Where is unmount stuck? 'echo w > /proc/sysrq-trigger' output if it
> is hung, 'echo l > /proc/sysrq-trigger' if it is spinning, please?

It's not stuck. It always errored out with EIO.

-Andi
