Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24230 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbdCIHAw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2017 02:00:52 -0500
Date: Wed, 8 Mar 2017 22:59:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: statx manpage
Message-ID: <20170309065949.GI5281@birch.djwong.org>
References: <20170308034500.GY14226@eguan.usersys.redhat.com>
 <20170307050140.GA12946@infradead.org>
 <20170307000609.GG5280@birch.djwong.org>
 <10435.1488907375@warthog.procyon.org.uk>
 <21188.1489042008@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21188.1489042008@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 09, 2017 at 06:46:48AM +0000, David Howells wrote:
> Eryu Guan <eguan@redhat.com> wrote:
> 
> > There's a "ADDING TO THE FSQA SUITE" section in README file, basically
> > it's telling you to use './new' script to generate new test template. So
> > based on what type of new test you're going to create, you could run:
> > 
> > ./new generic	# new generic test
> > ./new xfs	# new xfs test
> > ./new ext4	# new ext4 test
> > ./new shared	# new shared test
> > ...
> > 
> > It finds the first free seq number and creates test template and a
> > default .out file in tests/<type> dir and add a new entry in
> > tests/<type>/group file.  You could just edit the template and update
> > the .out file with expected output from the test run.
> 
> Yes, I'd spotted the ./new script, but it's not as simple as that since shell
> scripts can't call system calls directly.

Probably best to place a program in src/ so that xfstests can make the
raw syscalls early while we wait for glibc to invent a wrapper.

--D

> 
> David
