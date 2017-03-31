Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933182AbdCaQsU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 12:48:20 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170331162723.GA1693@infradead.org>
References: <20170331162723.GA1693@infradead.org> <149097291264.20089.7010494679305716312.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 1/2] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5898.1490978897.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Fri, 31 Mar 2017 17:48:17 +0100
Message-ID: <5899.1490978897@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> stat_test.c: In function 'main':
> stat_test.c:557:3: warning: 'sval' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    check(sval == scheck,
>    ^
> ...

I don't see any of these.  gcc is actually wrong about this.  What gcc are you
using?

> +nc: invalid option -- 'U'
> +/bin/nc: invalid option -- 'U'
> +nc -h for helpnc -h for help

Sounds like I need to add my own helper to create AF_UNIX sockets rather than
using netcat.  What version of nc do you have?  Mine is 7.40.

David
