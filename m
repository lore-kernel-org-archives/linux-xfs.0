Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864CAC41513
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 09:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjHGJLo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 05:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjHGJLn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 05:11:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70543E68;
        Mon,  7 Aug 2023 02:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D917616E6;
        Mon,  7 Aug 2023 09:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11130C433C8;
        Mon,  7 Aug 2023 09:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691399501;
        bh=jo05FRX8fxSniehU439g0zTeJkxYcL2Nno5qi9V86Dk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JUpB8aqlWBbjSIDG2OjPDnFTb1NPFIcJs6mjX/zmKdGLV98KN5OwwC6Lxkzce8fO0
         jlsxptGiMmH3OFHdIhj2cOUH1GzAwY7BznwrZDqH0pCzXN7QdCAWU62gFrYCXJKghf
         S/uK5UqTpaZnMZuZKXtdetRYn4W9ThzxlStgfEcE=
Date:   Mon, 7 Aug 2023 11:11:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, amir73il@gmail.com,
        dchinner@redhat.com, yangx.jy@fujitsu.com,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] Fix xfs/179 for 5.10 stable
Message-ID: <2023080737-marathon-payday-cd03@gregkh>
References: <20230803093652.7119-1-guoqing.jiang@linux.dev>
 <20230804154757.GI11352@frogsfrogsfrogs>
 <5d44e45b-cb85-b878-f21d-d0b508c3b696@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d44e45b-cb85-b878-f21d-d0b508c3b696@linux.dev>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2023 at 10:39:44AM +0800, Guoqing Jiang wrote:
> 
> 
> On 8/4/23 23:47, Darrick J. Wong wrote:
> > On Thu, Aug 03, 2023 at 05:36:50PM +0800, Guoqing Jiang wrote:
> > > Hi,
> > > 
> > > With the two patches applied, xfs/179 can pass in 5.10.188. Otherwise I got
> > > 
> > > [root@localhost xfstests]# ./check xfs/179
> > > FSTYP         -- xfs (non-debug)
> > > PLATFORM      -- Linux/x86_64 localhost 5.10.188-default #14 SMP Thu Aug 3 15:23:19 CST 2023
> > > MKFS_OPTIONS  -- -f /dev/loop1
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/scratch
> > > 
> > > xfs/179 1s ... [failed, exit status 1]- output mismatch (see /root/xfstests/results//xfs/179.out.bad)
> > >      --- tests/xfs/179.out	2023-07-13 16:12:27.000000000 +0800
> > >      +++ /root/xfstests/results//xfs/179.out.bad	2023-08-03 16:55:38.173787911 +0800
> > >      @@ -8,3 +8,5 @@
> > >       Check scratch fs
> > >       Remove reflinked files
> > >       Check scratch fs
> > >      +xfs_repair fails
> > >      +(see /root/xfstests/results//xfs/179.full for details)
> > >      ...
> > >      (Run 'diff -u /root/xfstests/tests/xfs/179.out /root/xfstests/results//xfs/179.out.bad'  to see the entire diff)
> > > 
> > > HINT: You _MAY_ be missing kernel fix:
> > >        b25d1984aa88 xfs: estimate post-merge refcounts correctly
> > > 
> > > Ran: xfs/179
> > > Failures: xfs/179
> > > Failed 1 of 1 tests
> > > 
> > > Please review if they are approriate for 5.10 stable.
> > Seems fine to me, but ... there is no maintainer for 5.10; is your
> > employer willing to support this LTS kernel?
> 
> Hi Darrick,
> 
> Thanks for your review! I think Amir is the maintainer for 5.10 😉. I can
> help
> if needed since our kernel is heavily based on 5.10 stable. We also run
> tests
> against 5.10 stable, that is why I send fixes patches for it.
> 
> Hi Greg,
> 
> Could you consider add the two to your list? Thank you!

Sorry, but as these would only be in th 5.10.y release, and not in any
newer stable kernel, you would have a regression if you moved to a newer
stable kernel branch, right?

Because of that, no, I can't take this, nor should you want me to, as
you would have a regression if you upgraded, right?

I'll be glad to do so if we have backports for all relevant stable
kernels.

thanks,

greg k-h
