Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34896 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbdDDG2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2017 02:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <9783.1491254227@warthog.procyon.org.uk>
References: <20170403163910.GD10881@birch.djwong.org> <149122078093.24821.17192375733082382807.stgit@warthog.procyon.org.uk>
 <149122081486.24821.15266397607503484126.stgit@warthog.procyon.org.uk>
 <9634.1491253516@warthog.procyon.org.uk> <9783.1491254227@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 4 Apr 2017 09:28:23 +0300
Message-ID: <CAOQ4uxg+-4Z4A-o=GktJqTqjrWzkMPBKoVvWCdG0yVdDqTPztg@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr
 [ver #3]
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 4, 2017 at 12:17 AM, David Howells <dhowells@redhat.com> wrote:
> David Howells <dhowells@redhat.com> wrote:
>
>> Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>
>> ...
>> > If so, perhaps there should be separate tests for each of the 4 attrs.
>>
>> They should also be tested in combination.  Hmmm...
>
> Hmmm...  It appears that that would require 16 separate test files, each with
> the appropriate combination of "_require_chattr <letter>".
>

I don't think that is necessary.

IMO, _require_chattr <letter> means test cannot run without this,
so no use in running it.
This is not true for this test.

Since this test is expecting empty output its not even hard to change the test.

First try silently all the 4 letters.
Then iterate of combination of supported subset.
