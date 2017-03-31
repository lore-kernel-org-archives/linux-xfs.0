Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932882AbdCaMFr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 08:05:47 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170331101941.GL22845@eguan.usersys.redhat.com>
References: <20170331101941.GL22845@eguan.usersys.redhat.com> <15267.1490891560@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14230.1490961943.1@warthog.procyon.org.uk>
Date: Fri, 31 Mar 2017 13:05:43 +0100
Message-ID: <14231.1490961943@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, fstests@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> _require_scratch is not called, but in the test $SCRATCH_MNT is used. So
> you need to either call "_require_scratch" here or use $TEST_DIR in the
> test. For this statx(2) test, I think test in $TEST_DIR would be
> sufficient.

SCRATCH is cleaned between runs of ./check, but not this isn't so for TEST,
right?

David
