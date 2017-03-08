Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbdCHFuh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 00:50:37 -0500
Date: Wed, 8 Mar 2017 11:45:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: statx manpage
Message-ID: <20170308034500.GY14226@eguan.usersys.redhat.com>
References: <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10435.1488907375@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 07, 2017 at 05:22:55PM +0000, David Howells wrote:
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > This would be great to have in 4.11 together with the initial statx
> > implementation.  But until I see documentation and testcases for statx
> > I don't really feel comfortable reviewing anything related to it.
> 
> Well, since you asked for documentation, here's a manual page for you to
> review:-)
> 
> Note that as it isn't in glibc yet, I've left out all the
> set-this-and-that-#define-to-make-it-appear stuff except where it is pertinent
> to particular constants.
> 
> I don't suppose you know where the documentation on writing xfstests tests is?
> xfstests-dev/doc/ only contains an old and out of date changelog.

There's a "ADDING TO THE FSQA SUITE" section in README file, basically
it's telling you to use './new' script to generate new test template. So
based on what type of new test you're going to create, you could run:

./new generic	# new generic test
./new xfs	# new xfs test
./new ext4	# new ext4 test
./new shared	# new shared test
...

It finds the first free seq number and creates test template and a
default .out file in tests/<type> dir and add a new entry in
tests/<type>/group file.  You could just edit the template and update
the .out file with expected output from the test run.

E.g. currently 416 is the first free seq number in generic tests,
./new generic will create

./tests/generic/416
./tests/generic/416.out

I think statx test should be a new generic test.

Thanks,
Eryu
