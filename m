Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40024 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdCBMZz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Mar 2017 07:25:55 -0500
Date: Thu, 2 Mar 2017 11:35:20 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: mm allocation failure and hang when running xfstests generic/269
 on xfs
Message-ID: <20170302103520.GC1404@dhcp22.suse.cz>
References: <20170301044634.rgidgdqqiiwsmfpj@XZHOUW.usersys.redhat.com>
 <20170302003731.GB24593@infradead.org>
 <20170302051900.ct3xbesn2ku7ezll@XZHOUW.usersys.redhat.com>
 <42eb5d53-5ceb-a9ce-791a-9469af30810c@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42eb5d53-5ceb-a9ce-791a-9469af30810c@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Xiong Zhou <xzhou@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu 02-03-17 19:04:48, Tetsuo Handa wrote:
[...]
> So, commit 5d17a73a2ebeb8d1("vmalloc: back off when the current task is
> killed") implemented __GFP_KILLABLE flag and automatically applied that
> flag. As a result, those who are not ready to fail upon SIGKILL are
> confused. ;-)

You are right! The function is documented it might fail but the code
doesn't really allow that. This seems like a bug to me. What do you
think about the following?
---
>From d02cb0285d8ce3344fd64dc7e2912e9a04bef80d Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Thu, 2 Mar 2017 11:31:11 +0100
Subject: [PATCH] xfs: allow kmem_zalloc_greedy to fail

Even though kmem_zalloc_greedy is documented it might fail the current
code doesn't really implement this properly and loops on the smallest
allowed size for ever. This is a problem because vzalloc might fail
permanently. Since 5d17a73a2ebe ("vmalloc: back off when the current
task is killed") such a failure is much more probable than it used to
be. Fix this by bailing out if the minimum size request failed.

This has been noticed by a hung generic/269 xfstest by Xiong Zhou.

Reported-by: Xiong Zhou <xzhou@redhat.com>
Analyzed-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/xfs/kmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 339c696bbc01..ee95f5c6db45 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -34,6 +34,8 @@ kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
 	size_t		kmsize = maxsize;
 
 	while (!(ptr = vzalloc(kmsize))) {
+		if (kmsize == minsize)
+			break;
 		if ((kmsize >>= 1) <= minsize)
 			kmsize = minsize;
 	}
-- 
2.11.0

-- 
Michal Hocko
SUSE Labs
