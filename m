Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9DFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 14:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350846AbiDZO45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 10:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244221AbiDZO45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 10:56:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4C664726
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 07:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2830618A9
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 14:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A24C385AA;
        Tue, 26 Apr 2022 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650984828;
        bh=d/KNHjuJmhlf1XTw0QU0YXKAgxNU9iUMbwwDCRjyp2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PI1FXltVzJbBwlzDzvFz4sg4x1T/cpNVp+pDoIZeLZWD7ch9o9VfG+vWgyxHgxs9Q
         YPDQ6CIimbz5mEkp0jVnwomX5iBsT2jUPgqhUWUG6lP7gLutOYT3SjQ65XoBAhXjtp
         1D26sXKu7uDG33eKheZSdjANX5ejD3eCRm1gFzmgpEkNHE44nrLnxo5BhJWaDrrIfJ
         7oRFeB1mJUUIQqpWOL5hdwQFR/gTc9RD9y6gMUT4lAzBJFe49FS0h0VqxFxVokjaG4
         /NyJTMN6tLNAkuc5f8ZsEW/NV67db0XCcdd3GMFxNzIUcX/mLzq0Si4KJMp92pRLOM
         F2QjcFoi22KQg==
Date:   Tue, 26 Apr 2022 07:53:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
Message-ID: <20220426145347.GV17025@magnolia>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
 <20220425222140.GI1544202@dread.disaster.area>
 <20220426024331.GR17025@magnolia>
 <Ymf+k9EA2bY/af4Y@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymf+k9EA2bY/af4Y@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 10:15:47AM -0400, Brian Foster wrote:
> On Mon, Apr 25, 2022 at 07:43:31PM -0700, Darrick J. Wong wrote:
> ...
> > 
> > The biggest problem right now is that the pagecache is broken in 5.18
> > and apparently I'm the only person who can trigger this.  It's the same
> > problem willy and I have been working on since -rc1 (where the
> > filemap/iomap debug asserts trip on generic/068 and generic/475) that's
> > documented on the fsdevel list.  Unfortunately, I don't have much time
> > to work on this, because as team lead:
> > 
> 
> I seem to be able to reproduce this fairly reliably with generic/068.
> I've started a bisect if it's of any use...

Thank you!  Matthew has hinted that he suspects this is a case of the
page cache returning the wrong folio in certain cases, but neither of us
have been able to narrow it down to a specific commit, or even a range.

--D

> Brian
> 
