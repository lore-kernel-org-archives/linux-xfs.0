Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83974CE79D4
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Sep 2023 14:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbjITOYU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjITOYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 10:24:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF623D7
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 07:24:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49195C433C8;
        Wed, 20 Sep 2023 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695219850;
        bh=AOB7BsE2Bzls7g+FweYyB0QotbSTPLbpQMn3sHo93gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pAN2m4mjYmgi/Oz+LO63twESrPn3M+CTVAlnHH+YE8l1V5nlc9q5HJio6q7elgJOn
         uejkgCDueRi1mBhlwbjbEA8BS8xu7gIVgvt3xl8BSinbmcufIrUOfrb0m6Tc5N0Rqd
         0n95pxjjWVxPMmpxPBqqmuhF+BaYaqEVYgiItAYNLVQdMvrzOPl4AZpJIOfkQyvSjr
         pcDit1V1wS1JzFQMQIXp1m4QfS8ztqfx1IOGisd2As3tx/OKE8RRimUhtYUtE+43je
         BgoEqWL1YSbJtLiVJwGTWU28L+iGSdYRn8LtM+ynWtMzvrEJvoD9CcfWH+ls1wx0xW
         0I5j9mRcj1mhA==
Date:   Wed, 20 Sep 2023 07:24:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     chandan.babu@gmail.com, david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, peterz@infradead.org,
        ritesh.list@gmail.com, sandeen@sandeen.net, tglx@linutronix.de
Subject: Re: [GIT PULL] xfs: fix ro mounting with unknown rocompat features
Message-ID: <20230920142409.GH348037@frogsfrogsfrogs>
References: <169513911841.1384408.4221257193552110896.stg-ugh@frogsfrogsfrogs>
 <87jzsl6sri.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzsl6sri.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 20, 2023 at 03:50:04PM +0530, Chandan Babu R wrote:
> On Tue, Sep 19, 2023 at 09:01:42 AM -0700, Darrick J. Wong wrote:
> > Hi Chandan,
> >
> > Please pull this branch with changes for xfs for 6.6-rc2.
> >
> > As usual, I did a test-merge with the main upstream branch as of a few
> > minutes ago, and didn't see any conflicts.  Please let me know if you
> > encounter any problems.
> >
> 
> Darrick, Unfortunately applying fix-efi-recovery-6.6_2023-09-12 tag pulls in
> the older version of "xfs: fix log recovery when unknown rocompat bits are
> set".

Ah, right, I forgot to resend all 8 pull requests.  My bad. :(

> I think it is best to continue having the older version of "xfs: fix log
> recovery when unknown rocompat bits are set" patch i.e. I will include the
> current version of xfs-6.6-fixes-1 tag in my pull request to Linus instead of
> replacing commits from fix-ro-mounts-6.6_2023-09-12 with
> fix-ro-mounts-6.6_2023-09-19.

Ok.  I'll push an iomap-for-next update, and maybe all the bugs will be
sorted in -rc3. :)

--D

> 
> Sorry about the noise.
> 
> -- 
> Chandan
