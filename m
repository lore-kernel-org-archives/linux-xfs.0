Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A23C55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 21:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FCF722275
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 21:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505967AbgJ0VgB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 17:36:01 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41897 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2505925AbgJ0VgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 17:36:01 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 09RLWW2T017202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 17:32:32 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id F0E12420107; Tue, 27 Oct 2020 17:32:31 -0400 (EDT)
Date:   Tue, 27 Oct 2020 17:32:31 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 0/7] various: test xfs things fixed in 5.10
Message-ID: <20201027213231.GG5691@mit.edu>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382535113.1203387.16777876271740782481.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:02:31PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here are a bunch of new tests for problems that were fixed in 5.10.
> Er.... 5.10 and 5.9.  I have not been good at sending to fstests
> upstream lately. :( :(
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

Hey Darrick, on a slightly different topic, you had mentioned on last
week's ext4 video chat that you had been working on some patches to
allow specific blocks to be forced to return EIO, at specific times,
to test how a file system handles errors when writing to data blocks,
metadata blocks, journal, etc.

Are there early versions of those patches available for us to play
with?  I'm interesting in using that infrastructure for adding some
ext4 tests along those lines.

Thanks!!

					- Ted
