Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754245AbdIFQnD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 12:43:03 -0400
Date: Wed, 6 Sep 2017 12:43:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 00/12] xfs: more and better verifiers
Message-ID: <20170906164300.GC55280@bfoster.bfoster>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150394418979.24826.12970283067445908653.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 11:16:29AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This patch series combines all the random little fixes and improvements
> to the verifiers that we've been talking about for the past month or so
> into a single patch series!
> 
> We start by refactoring the long format btree block header verifier into
> a single helper functionn and de-macroing dir block verifiers to make
> them less shouty.  Next, we change verifier functions to return the
> approximate instruction pointer of the faulting test so that we can
> report more precise fault information to dmesg/tracepoints.  Then, we
> move on to creating verifiers for all the inline format fork formats,
> and create a helper function for _iget that can dispatch inline
> verification.  The ability to supply custom verifier functions will be
> used by xfs_repair to deal with corrupt inodes.  The last patch enables
> us to (re)check the structure of incore metadata buffers to try to
> detect memory corruption.
> 

This looks mostly sane to me on a first pass. I noticed that xfs/348 now
fails, though it looks like the test just needs an update for the
symlink verifier..? Otherwise some random questions to follow..

Brian


> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
