Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35266 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdDCLc4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 07:32:56 -0400
MIME-Version: 1.0
In-Reply-To: <23054.1491218325@warthog.procyon.org.uk>
References: <149121523070.22344.187602366514567082.stgit@warthog.procyon.org.uk>
 <149121524183.22344.1748203777026246762.stgit@warthog.procyon.org.uk>
 <CAOQ4uxhBgQ6q5GMe=G14Swvxto+y2_rZucZzK521Z4mCryOrZg@mail.gmail.com> <23054.1491218325@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Apr 2017 14:32:55 +0300
Message-ID: <CAOQ4uxg73bQzakiUoQnvLxOztO4z-1ro+LZcDKsMCbOXA0g-3g@mail.gmail.com>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Apr 3, 2017 at 2:18 PM, David Howells <dhowells@redhat.com> wrote:
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> I know Eryu told you that you can change the default of status to success,
>> ... what's the benefit of doing that.
>
> Simple: All the tests should be carried out, even if one or more fail.  The
> script should not simply abort at that point, but should rather give the
> cumulative error at the end.
>
> This means the default should be success and this altered to failure on the
> failure of any subtest (ie. we're OR'ing them).
>
> There should needs to be a way to report any subtest that was skipped because
> the kernel or the fs doesn't support it.
>
>> A simple way to deal with this is to do
>>
>> function check_stat () {
>>     $here/src/stat_test $* || exit
>> }
>
> No.  This is the wrong thing to do (see above).  Better would be to either set
> status=1 here (but we're inside a function, so I'm not sure that'll work) or
> to replace the exit above with "|| echo stat_test failed" and let the output
> comparator handle it.
>

Fair enough. Both options will work. Bash variables are global by default.

I am a bit concerned about setting status=0 to begin with because
of 'exit' inside common helpers.

How about handling the errors with "|| echo stat_test failed"
and sticking to standard wrt status?
