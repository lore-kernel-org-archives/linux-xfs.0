Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85387C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 21:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiLUVSf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLUVSe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 16:18:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAB8E0C8
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 13:18:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A8E4B81C3C
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 21:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176C3C433D2;
        Wed, 21 Dec 2022 21:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657511;
        bh=60m+AlfaKlBn5+3gLJE5teZCwq6y1UTAdCTkY2ZUG20=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BESFmQDHwGmRMtQNUDtNvy2BnfopI6ffmi28e6VeeZxuuHRt2QQ57VCZCXi5xVFlB
         oGOsf5TczZMX1mA7Cqe6uFKLoFUJT0pYJUpo90yuxC1i/vIGTKaFUWR1kRS0rcKmGO
         wOpmyHM9/8nw+HXZU4PWlZJKhc8iRlVBtvCSAXp8=
Date:   Wed, 21 Dec 2022 13:18:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
        ruansy.fnst@fujitsu.com, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] fsdax,xfs: fix data corruption problems
Message-Id: <20221221131830.36de8f478af0e6b0e8398c3b@linux-foundation.org>
In-Reply-To: <CAHk-=wjxdo-VBecNV90ye_X6C_zdkTUNqtqxuxbwz5OnL8Jhqg@mail.gmail.com>
References: <167155161011.40255.9717951395121213068.stg-ugh@magnolia>
        <CAHk-=wjxdo-VBecNV90ye_X6C_zdkTUNqtqxuxbwz5OnL8Jhqg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 21 Dec 2022 10:39:48 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Dec 20, 2022 at 8:01 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > As usual, I did a test-merge with the main upstream branch as of a few
> > minutes ago, and didn't see any conflicts.  Please let me know if you
> > encounter any problems.
> 
> Well... There are no conflicts, because there are no changes.
> 
> ...
>
> Adding Andrew to the Cc, because obviously there was some
> communication failure and confusion here. Quite often the dax changes
> *do* fome through Andrew, so maybe the only issue this time was that
> because it only really affected XFS, we ended up having that "xfs
> people _also_ worked on it".
> 

Sorry, I totally did not get (or comprehend) any such message.

Presumably Stephen was adding that tree into -next also, and never even
noticed the duplicated commits.

That's the third time this merge window.  I really do wish we had an
early warning system for this, and linux-next is the place to do it. 
Stephen did indicate that he would take a look at brewing something up.
