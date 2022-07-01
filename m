Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C38C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Jul 2022 23:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGAXOG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Jul 2022 19:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGAXOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Jul 2022 19:14:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140795A2DD;
        Fri,  1 Jul 2022 16:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S8USlrNUO8+wQhnb4BEP9KtXRqoYCICYXDcbrFhD5Gc=; b=XT9GxII5/xOuwb8uvSjueBo1Bv
        we74zIEW3EtrpNo6FbbY+RjW1+PY9Pby6y0/NkC4z7pRr0lrYQfLfizStBKa/pHOKDp8SuFnP06x5
        /UAkYW3RDgwqbaSke5FUGjQX7vTPCWFlrN8TcVL9DGNwesMM2V7f4qFTiBcTZoIxc0rjbg2iBKh10
        OutDMc6cY9UpUNUoSnax+Inar3Y5KTf9YpaAx/P7kuMdXjYxJ3hf/abpeS9fqqW6LSO/bXsVTw89h
        EAQ8pBk7KOQ3DA1UopIHJlZqdYU6VxIxzZ9J3rsDukCGivdqUiLNyKsMAEeQIYR6MYsJuW7bpxfyi
        cooJqNhA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o7Ppi-007Nyc-9W; Fri, 01 Jul 2022 23:13:54 +0000
Date:   Fri, 1 Jul 2022 16:13:54 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Zorro Lang <zlang@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: sharing fstests results (Was: [PATCH 5.15 CANDIDATE v2 0/8] xfs
 stable candidate patches for 5.15.y (part 1))
Message-ID: <Yr9/sk4KqKlbKu8o@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
 <YrVMZ7/rJn11HH92@mit.edu>
 <YrZAtOqQERpYbBXg@bombadil.infradead.org>
 <CAOQ4uxi-KVMWb4nvNCriPdjMcZkPut7x6LA6aHJz_hVMeBxvOA@mail.gmail.com>
 <YrdjluHoj9xAz3Op@bombadil.infradead.org>
 <YreDIk2FMMPQDpLL@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YreDIk2FMMPQDpLL@mit.edu>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 25, 2022 at 05:50:26PM -0400, Theodore Ts'o wrote:
> On Sat, Jun 25, 2022 at 12:35:50PM -0700, Luis Chamberlain wrote:
> > Here's the thing though. Not all developers have incentives to share.
> 
> Part of this is the amount of *time* that it takes to share this
> information.

There's many reasons. In the end we keep digressing, but I see no
expressed interest to share, and so we can just keep on moving
with how things are.

  Luis
