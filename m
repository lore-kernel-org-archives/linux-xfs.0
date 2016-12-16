Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34457 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759834AbcLPMqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2016 07:46:43 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [DEBUG PATCH 0/2] debug explicit GFP_NO{FS,IO} usage from the scope context
Date: Fri, 16 Dec 2016 13:46:26 +0100
Message-Id: <20161216124628.26846-1-mhocko@kernel.org>
In-Reply-To: <20161215140715.12732-1-mhocko@kernel.org>
References: <20161215140715.12732-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>

Hi,
I've forgot to add the following two patches which should help to
identify explicit GFP_NO{FS,IO} usage from withing a scope context. Such
a usage can be changed to the full GFP_KERNEL because all the calls
from within the NO{FS,IO} scope will drop the __GFP_FS resp. __GFP_IO
automatically and if the function is called outside of the scope then
we do not need to restrict it to NOFS/NOIO as long as all the reclaim
recursion unsafe contexts are marked properly. This means that each
such a reported allocation site has to be checked before converted.

The debugging has to be enabled explicitly by a kernel command line
parameter and then it reports the stack trace of the allocation and
also the function which has started the current scope.

These two patches are _not_ intended to be merged and they are only
aimed at debugging.

