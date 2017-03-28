Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754487AbdC1Mkf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 08:40:35 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxhipk2anBVUh9eKL1A1RqDUMRci5rpYbrjQPo9voab5ZA@mail.gmail.com>
References: <CAOQ4uxhipk2anBVUh9eKL1A1RqDUMRci5rpYbrjQPo9voab5ZA@mail.gmail.com> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <22058.1490696551@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfs_io: changes to statx interface
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23773.1490704285.1@warthog.procyon.org.uk>
Date: Tue, 28 Mar 2017 13:31:25 +0100
Message-ID: <23774.1490704285@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> xfs_io -c "statx -c /dev/null"
> 
> is what you want

That doesn't produce any output.  Did you mean:

	xfs_io -c "statx -c" /dev/null

Further, this should work:

	warthog>xfs_io -c "statx -c" /dev/sda
	/dev/sda: Permission denied

but doesn't.

> See the output of 'file' command or the global var filetable.

So I would have to make "-d dirfd" take an entry in the global var filetable
rather than an actual fd number?

David
