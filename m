Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753902AbdDELLl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 07:11:41 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170405105226.GA22845@eguan.usersys.redhat.com>
References: <20170405105226.GA22845@eguan.usersys.redhat.com> <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk> <149132133562.18980.13032775360715592290.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr [ver #5]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3175.1491390698.1@warthog.procyon.org.uk>
Date: Wed, 05 Apr 2017 12:11:38 +0100
Message-ID: <3176.1491390698@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> Need a "Silence is golden" output to indicate this test expects no
> output.

But why is it needed?  You have an exit code.  Further, it's not in the .out
file, so you can see just by looking at that that there's no output expected.

Actually, how do I *prevent* the output comparator from comparing?  I really
want to print out what chattr+statx tests I'm actually running (as opposed to
the ones I'm skipping), but I can't do that because the output comparator
would bark.

David
