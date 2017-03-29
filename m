Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752175AbdC2PYV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 11:24:21 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170328231821.GK17542@dastard>
References: <20170328231821.GK17542@dastard> <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <29458.1490711932@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7000.1490801058.1@warthog.procyon.org.uk>
Date: Wed, 29 Mar 2017 16:24:18 +0100
Message-ID: <7001.1490801058@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: dhowells@redhat.com, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Dave Chinner <david@fromorbit.com> wrote:

> Running "compare" tests like this is not a function that xfs_io
> should perform. Have it run and output the statx information,
> and use xfstests to compare that against a golden output and/or
> the output of the xfs_io stat command.

A golden output that covers timestamps isn't possible.

Also comparing the output of Eric's statx command with the output of the stat
command as it stands isn't practical.  I guess I can add another parameter to
the stat command to produce something that looks the same.

I'm tempted to write C-based python3 module that gives raw access to the
system calls (something I want for the unionmount testsuite) and then script
this in python.

David
