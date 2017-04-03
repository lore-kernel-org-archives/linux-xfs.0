Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752062AbdDCLS6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 07:18:58 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxhBgQ6q5GMe=G14Swvxto+y2_rZucZzK521Z4mCryOrZg@mail.gmail.com>
References: <CAOQ4uxhBgQ6q5GMe=G14Swvxto+y2_rZucZzK521Z4mCryOrZg@mail.gmail.com> <149121523070.22344.187602366514567082.stgit@warthog.procyon.org.uk> <149121524183.22344.1748203777026246762.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23053.1491218325.1@warthog.procyon.org.uk>
Date: Mon, 03 Apr 2017 12:18:45 +0100
Message-ID: <23054.1491218325@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

Amir Goldstein <amir73il@gmail.com> wrote:

> I know Eryu told you that you can change the default of status to success,
> ... what's the benefit of doing that.

Simple: All the tests should be carried out, even if one or more fail.  The
script should not simply abort at that point, but should rather give the
cumulative error at the end.

This means the default should be success and this altered to failure on the
failure of any subtest (ie. we're OR'ing them).

There should needs to be a way to report any subtest that was skipped because
the kernel or the fs doesn't support it.

> A simple way to deal with this is to do
> 
> function check_stat () {
>     $here/src/stat_test $* || exit
> }

No.  This is the wrong thing to do (see above).  Better would be to either set
status=1 here (but we're inside a function, so I'm not sure that'll work) or
to replace the exit above with "|| echo stat_test failed" and let the output
comparator handle it.

David
