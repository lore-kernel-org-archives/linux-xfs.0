Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCC0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 16:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbiA0QuJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 11:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbiA0QuJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 11:50:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E09C061714;
        Thu, 27 Jan 2022 08:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D867B80D70;
        Thu, 27 Jan 2022 16:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A626DC340E4;
        Thu, 27 Jan 2022 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643302206;
        bh=+LfawAXH2gQ2TbaBe0JzcDv1nk+wJZIKhVlzd3yjN3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WEV6/ULnIBTF21Cu/tQMvjDCUQvSt/tw/O27j3yer9tnQjcjP/u5OzHLSSJnbuCes
         YqlW+6zNxyKvo26d1zZ/18437Q9hxS+beXnufa1GqQXxwJGioO7RUb0KB35zjo/47p
         CcpzxJO/nx2gd+8m+eUYjiV7qeO79jvXL4tzWGHbxaKrqu3a7tQqlstrBVe87voS7o
         6/+USzNCzdhIzH5gv7ueMRUenPGE/r9QF0A6mVRCDFJvgZ5jbVvaA2CJZQUIfozLit
         ZWmTVUWpNND9inSy4ZyCPtRymKLyURfc12/MWq8/RIRALhF4KcDwvfVA23tThglYDS
         cMyd3tpKt9KXQ==
Date:   Thu, 27 Jan 2022 08:50:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: yet another approach to fix loop autoclear for xfstets xfs/049
Message-ID: <20220127165005.GE13540@magnolia>
References: <20220126155040.1190842-1-hch@lst.de>
 <20220126193840.GA2761985@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126193840.GA2761985@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 26, 2022 at 11:38:40AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 26, 2022 at 04:50:32PM +0100, Christoph Hellwig wrote:
> > Hi Jens, hi Tetsuo,
> > 
> > this series uses the approach from Tetsuo to delay the destroy_workueue
> > cll, extended by a delayed teardown of the workers to fix a potential
> > racewindow then the workqueue can be still round after finishing the
> > commands.  It then also removed the queue freeing in release that is
> > not needed to fix the dependency chain for that (which can't be
> > reported by lockdep) as well.
> 
> [add xfs to cc list]
> 
> This fixes all the regressions I've been seeing in xfs/049 and xfs/073,
> thank you.  I'll give this a spin with the rest of fstests overnight.

After an overnight run with 5.17-rc1 + {xfs,iomap}-for-next + this patchset,
fstests is back to normal.

Tested-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> --D
