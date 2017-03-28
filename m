Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752457AbdC1OlH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 10:41:07 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29458.1490711932@warthog.procyon.org.uk>
References: <29458.1490711932@warthog.procyon.org.uk> <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29490.1490712064.1@warthog.procyon.org.uk>
Date: Tue, 28 Mar 2017 15:41:04 +0100
Message-ID: <29491.1490712064@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: dhowells@redhat.com, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

> Here are my current changes to Eric's statx interface patch.  I've made it
> analoguous to the stat command and so it only does statx-of-fd.
> 
> I've made the "-m" flag able to take the words "basic" and "all" in
> preference to a number and able to take an octal or hex number as an
> alternative too.
> 
> I've dropped the -A and -L flags since it no longer passes a path over.
> 
> Finally, I've added a -c flag that causes an fstat() to be done as well and
> the buffers compared as a consistency check.

Note that the intention is to put the testing of the syscall parameter
handling into LTP, along with testing of the symlink following and dirfd usage
since xfstests seems unsuitable for this.

David
