Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932706AbdDELaN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 07:30:13 -0400
Date: Wed, 5 Apr 2017 19:30:09 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by
 chattr [ver #5]
Message-ID: <20170405113009.GC22845@eguan.usersys.redhat.com>
References: <20170405105226.GA22845@eguan.usersys.redhat.com>
 <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132133562.18980.13032775360715592290.stgit@warthog.procyon.org.uk>
 <3176.1491390698@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3176.1491390698@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Apr 05, 2017 at 12:11:38PM +0100, David Howells wrote:
> Eryu Guan <eguan@redhat.com> wrote:
> 
> > Need a "Silence is golden" output to indicate this test expects no
> > output.
> 
> But why is it needed?  You have an exit code.  Further, it's not in the .out
> file, so you can see just by looking at that that there's no output expected.

Yes, it's not a must-have from the test's point of view. But it's kind
of xfstests' convention. xfstests takes it as a clear indication that
this test expects no output, so anyone who's familiar with xfstests
knows the test has no output and isn't surprised. Without this message
people just get confused and wonder what's the expected result.

As Amir pointed out, not all tests with empty output print this message
(mostly some really old tests), but most of such tests do print.

> 
> Actually, how do I *prevent* the output comparator from comparing?  I really
> want to print out what chattr+statx tests I'm actually running (as opposed to
> the ones I'm skipping), but I can't do that because the output comparator
> would bark.

You could dump & append any debug message to $seqres.full file, it's for
debug purpose and it defaults to <xfstests>/result/generic/421.full

e.g.
echo "a=$a_supported d=$d_supported c=$c_supported i=$i_supported" >>$seqres.full

Thanks,
Eryu
