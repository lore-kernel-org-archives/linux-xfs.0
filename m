Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C751CC38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 19:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjARTWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 14:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjARTWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 14:22:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D316253B33;
        Wed, 18 Jan 2023 11:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 796BAB81EC6;
        Wed, 18 Jan 2023 19:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FA9C433F0;
        Wed, 18 Jan 2023 19:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674069735;
        bh=yjQncDbJeENGWSOLDdWMhn5Bloim0J4tjTJOQeS/9ws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AhWorewOTLEA1Sz+viHSXw7GmLjrwI+CHP/jGeaPWfPN1Pm+4Euiryk2E7Rls1IzP
         AfOMutSQWdcEzk6oxAK3Ka6dK5UBH7PtWldoeS/CMkZz+9oWJFXDnQ23szfqh/PrLM
         W9tn/88zmGT74ZrsSzb6xx7I6pYtx1X1BJjuQt3pZHQVhwF5Q4+ViEaJUrOoVgzMv2
         Fzzs6NxaF1rLd4JM5E9dJK8Ko8fvkoZqGKMZMIqKYL0BGcW6xw5UVup3DbpLzjDp+3
         Llfg/J37Q7Lgsh3FCkKzyRYyqMfgqMapGfc0SvqDJwogEeNAuJ2OALug7MRtT5X0vg
         iUaenFUzGrRQw==
Date:   Wed, 18 Jan 2023 11:22:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] populate: improve runtime of __populate_fill_fs
Message-ID: <Y8hG59tdunKmATSw@magnolia>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
 <167400103096.1915094.8399897640768588035.stgit@magnolia>
 <20230118155403.pg7aq3gtcks2ptdz@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118155403.pg7aq3gtcks2ptdz@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 11:54:03PM +0800, Zorro Lang wrote:
> On Tue, Jan 17, 2023 at 04:44:33PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Run the copy loop in parallel to reduce runtime.  If filling the
> > populated fs is selected (which it isn't by default in xfs/349), this
> > reduces the runtime from ~18s to ~15s, since it's only making enough
> > copies to reduce the free space by 5%.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/populate |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index f34551d272..1c3c28463f 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -151,8 +151,9 @@ __populate_fill_fs() {
> >  	echo "FILL FS"
> >  	echo "src_sz $SRC_SZ fs_sz $FS_SZ nr $NR"
> >  	seq 2 "${NR}" | while read nr; do
> > -		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}"
> > +		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}" &
> >  	done
> > +	wait
> 
> I'm thinking about what'll happen if we do "Ctrl+c" on a running test which
> is waiting for these cp operations.

Hmm.  In the context of fstests running on a system with systemd, we run
each test within a systemd scope and kill the scope when the test script
exits.  That will tear down unclaimed background processes, but it's not
a hard and fast guarantee that everyone has systemd.

As for *general* bashisms, I guess the only solution is:

trap 'pkill -P $$' INT TERM QUIT EXIT

To kill all the children of the test script.  Maybe we want that?  But I
hate wrapping my brain around bash child process management, so yuck.

I'll drop the parallel populate work, it's creating a lot of problems
that I don't have time to solve while delivering only modest gains.

--D

> >  }
> >  
> >  # For XFS, force on all the quota options if quota is enabled
> > 
> 
