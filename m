Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1434564AbdDZB5m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 21:57:42 -0400
Date: Wed, 26 Apr 2017 03:57:41 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 1/2 v3] mkfs: unify numeric types of main variables in
 main()
Message-ID: <20170426015741.GW28800@wotan.suse.de>
References: <20170419153025.10368-1-jtulak@redhat.com>
 <20170420135839.22102-1-jtulak@redhat.com>
 <20170425013721.GE28800@wotan.suse.de>
 <CACj3i70Niht-0FJSyVp2iOpKssTnz=LmryJMLQKiX=hHm6d+-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i70Niht-0FJSyVp2iOpKssTnz=LmryJMLQKiX=hHm6d+-A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 02:07:02PM +0200, Jan Tulak wrote:
> Ehh, it is not really an issue.. cvtnum is called only on two places
> in the whole xfsprogs.

Huh, I count 46, and spread all over the place:

mcgrof@ergon ~/devel/xfsprogs-dev (git::libiniconfig-conf)$ git grep " cvtnum("| awk '{print $1}'| sort | uniq
include/input.h:extern
include/xfs_multidisk.h:extern
io/fadvise.c:
io/madvise.c:
io/mincore.c:
io/mmap.c:
io/pread.c:
io/prealloc.c:
io/pwrite.c:
io/readdir.c:
io/reflink.c:
io/resblks.c:
io/seek.c:
io/sendfile.c:
io/sync_file_range.c:
io/truncate.c:
mkfs/proto.c:
mkfs/xfs_mkfs.c:
quota/edit.c:

So 19 files.

> Changing mkfs/proto.c is just few lines added
> to this patch and the changes in xfs_mkfs.c do cause few conflicts,
> but it is nothing terrific, I rebased all my further changes in about
> three minutes. I pushed it into the git tree, check it now...

Will do...

> And thanks for this patch for the patch. :-)

My pleasure, on second thought if the wrap around change can be a separate
atomic change that might be worth it.

 Luis
