Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4450C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AD8A64E62
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhBWDHx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhBWDHw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:07:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB43C64DEC;
        Tue, 23 Feb 2021 03:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049631;
        bh=lWPUkp+r/2cNmy06o+pDuthveranmpthjK6+1EPsUVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDXpnQphZbZoAgfFr3aduR+04BHDAD6ZPuy5fr08edwH8ia7koVQ5kKLlAYPknGsd
         3f0KfXPWXHtrLfCdZ29QNeXurxwV20MIp9M18ctpoo/aik0pi02vjDAw8xQYvCAuwW
         6Z8dswaYAaDX3HJBKr3nz4v5EFKYHD05o3bLZ6bOwgNTlos/McLllxyW5nwJ3Gr/pg
         /OSc5xviWot3F4Shi0luFH957KZRkyS0Q7fOfSbGPPCnbhDV4BzI4VHnafTTZwvUn8
         4K4Xm32ClnNz+9PS1fqeHaB1wPGTdnhITH6d35VX+8Wbzh3w3S6+CRKnh/j+ljbnz2
         nprL/8JT+AN9w==
Date:   Mon, 22 Feb 2021 19:07:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Dimitri John Ledkov <xnox@ubuntu.com>
Subject: Re: [PATCH 1/4] debian: Drop trying to create upstream distribution
Message-ID: <20210223030711.GG7272@magnolia>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-2-bastiangermann@fishpost.de>
 <20210221040129.GK4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221040129.GK4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 21, 2021 at 03:01:29PM +1100, Dave Chinner wrote:
> On Sat, Feb 20, 2021 at 01:16:06PM +0100, Bastian Germann wrote:
> > This is a change introduced in 4.3.0+nmu1ubuntu1.
> 
> Why? When the change was made is not important, explaining why the
> change needs to be made is what should be in the commit message.
> i.e. Tell us why this isn't needed any more...

Yes, this is vital information to have in the commit message.

I'm guessing it has something to do with the fact that 'make dist' tries
to create source tarballs, which is a strange thing to do during the
binary build, and in any case it ultimately fails because tarball
generation now requires .gitcensus, which is cleaned out and then
requires git to regeneration, which you can't do when you're building
from a source tarball?

<shrug> Hm?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
