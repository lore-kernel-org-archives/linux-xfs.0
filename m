Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB26C46467
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Jan 2023 05:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjATFec (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjATFeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2023 00:34:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF9572C1C;
        Thu, 19 Jan 2023 21:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0630B825E2;
        Thu, 19 Jan 2023 16:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E34C433EF;
        Thu, 19 Jan 2023 16:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674145190;
        bh=c9ILNmGa9MRZfKvq8xWS1ut15XYxgjlRiyzMznhLzQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JKmwFoB5CUKWc1NCgBSb00eMZbzwZCzztxWih3JwPArBJcZSQ46c3NVeietVa/pJo
         uQd9qaKxtPk0wWNSmuicLCgYIV3g/FivXuy7uYvNlHZ+mkJdV6u6Adoum5c3aAfVRe
         +ZVkp+faXhxT7unVyB/Ipub39rRIvvpSo2T0WOA9dCPpz2kHK5zqz/WdSGgyixQkMk
         MUDF5dnpSJkeUwwRpXaJsmc6y6DV4ZkmMPZfEdl0zpUCUIEguhonRd17FRJCmTa9Mg
         Z0v1QM/L+lhImYR2l2lcZbmt8/mUnpZzWa4PlQDrIRd5g5/evIB1e8WlCJEeZKjEBI
         sPzwkO6aCsVAg==
Date:   Thu, 19 Jan 2023 08:19:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] populate: improve runtime of __populate_fill_fs
Message-ID: <Y8ltpg4WKZQrRMHE@magnolia>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
 <167400103096.1915094.8399897640768588035.stgit@magnolia>
 <20230118155403.pg7aq3gtcks2ptdz@zlang-mailbox>
 <Y8hG59tdunKmATSw@magnolia>
 <20230119050406.fqtf55c737yc35ze@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119050406.fqtf55c737yc35ze@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 01:04:06PM +0800, Zorro Lang wrote:
> On Wed, Jan 18, 2023 at 11:22:15AM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 18, 2023 at 11:54:03PM +0800, Zorro Lang wrote:
> > > On Tue, Jan 17, 2023 at 04:44:33PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Run the copy loop in parallel to reduce runtime.  If filling the
> > > > populated fs is selected (which it isn't by default in xfs/349), this
> > > > reduces the runtime from ~18s to ~15s, since it's only making enough
> > > > copies to reduce the free space by 5%.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  common/populate |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > > diff --git a/common/populate b/common/populate
> > > > index f34551d272..1c3c28463f 100644
> > > > --- a/common/populate
> > > > +++ b/common/populate
> > > > @@ -151,8 +151,9 @@ __populate_fill_fs() {
> > > >  	echo "FILL FS"
> > > >  	echo "src_sz $SRC_SZ fs_sz $FS_SZ nr $NR"
> > > >  	seq 2 "${NR}" | while read nr; do
> > > > -		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}"
> > > > +		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}" &
> > > >  	done
> > > > +	wait
> > > 
> > > I'm thinking about what'll happen if we do "Ctrl+c" on a running test which
> > > is waiting for these cp operations.
> > 
> > Hmm.  In the context of fstests running on a system with systemd, we run
> > each test within a systemd scope and kill the scope when the test script
> > exits.  That will tear down unclaimed background processes, but it's not
> > a hard and fast guarantee that everyone has systemd.
> > 
> > As for *general* bashisms, I guess the only solution is:
> > 
> > trap 'pkill -P $$' INT TERM QUIT EXIT
> > 
> > To kill all the children of the test script.  Maybe we want that?  But I
> > hate wrapping my brain around bash child process management, so yuck.
> > 
> > I'll drop the parallel populate work, it's creating a lot of problems
> > that I don't have time to solve while delivering only modest gains.
> 
> Yeah, that makes things become complex. So I think if above change can bring
> in big performance improvement, we can do that (or use another way to do that,
> e.g. an independent program which main process can deal with its children).
> If the improvement is not obvious, I'd like not to bring in too many
> multi-bash-processes in common helper. What do you think?

It's easier to drop the multi subprocess complexity, so I'll do that. :)

Most of the speedup was from algorithmic improvement, not throwing more
CPUs at the problem.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > >  }
> > > >  
> > > >  # For XFS, force on all the quota options if quota is enabled
> > > > 
> > > 
> > 
> 
