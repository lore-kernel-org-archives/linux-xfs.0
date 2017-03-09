Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751331AbdCIGzR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 01:55:17 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170308034500.GY14226@eguan.usersys.redhat.com>
References: <20170308034500.GY14226@eguan.usersys.redhat.com> <20170307050140.GA12946@infradead.org> <20170307000609.GG5280@birch.djwong.org> <10435.1488907375@warthog.procyon.org.uk>
Subject: Re: statx manpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21187.1489042008.1@warthog.procyon.org.uk>
Date: Thu, 09 Mar 2017 06:46:48 +0000
Message-ID: <21188.1489042008@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

Eryu Guan <eguan@redhat.com> wrote:

> There's a "ADDING TO THE FSQA SUITE" section in README file, basically
> it's telling you to use './new' script to generate new test template. So
> based on what type of new test you're going to create, you could run:
> 
> ./new generic	# new generic test
> ./new xfs	# new xfs test
> ./new ext4	# new ext4 test
> ./new shared	# new shared test
> ...
> 
> It finds the first free seq number and creates test template and a
> default .out file in tests/<type> dir and add a new entry in
> tests/<type>/group file.  You could just edit the template and update
> the .out file with expected output from the test run.

Yes, I'd spotted the ./new script, but it's not as simple as that since shell
scripts can't call system calls directly.

David
