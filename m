Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934741AbdC3TcG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 15:32:06 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxiEzYvbAOdsJLOMKESUEVJuC57PPbYHvo-HtDZEiihb3A@mail.gmail.com>
References: <CAOQ4uxiEzYvbAOdsJLOMKESUEVJuC57PPbYHvo-HtDZEiihb3A@mail.gmail.com> <15267.1490891560@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23330.1490902318.1@warthog.procyon.org.uk>
Date: Thu, 30 Mar 2017 20:31:58 +0100
Message-ID: <23331.1490902318@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> >  (2) Optionally compares the timestamps to see that they're sensibly
> >      ordered with respect to the saved clock time[**] and each other.
> 
> I suggest that instead of comparing to absolute timestamp value
> compare to a timestamp of the cmp file.
> This will also solve you the problem of gettimeofday() vs. kernel_time
> and will also open up the possibility of adding more interesting tests
> later on (e.g. make sure that mtime of file A >= atime of file B).

The whole point was to compare to a preceding time to make sure the timestamp
didn't go backwards - exactly as it can do:-/.  Comparing to a reference file
doesn't prove that unless you've checked the reference file...

Making use of more of a reference file's timestamps could be useful for other
checks, though.

> > +420 other
> 
> Since your test takes a few seconds, you should add it to auto, quick groups
> I don't know what this 'other' group is about.

I don't know either.  Ask the 'new' script.

David
