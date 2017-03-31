Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933286AbdCaRTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 13:19:18 -0400
Date: Fri, 31 Mar 2017 10:19:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstests: Add first statx test
Message-ID: <20170331171917.GA28069@infradead.org>
References: <20170331162723.GA1693@infradead.org>
 <149097291264.20089.7010494679305716312.stgit@warthog.procyon.org.uk>
 <5899.1490978897@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5899.1490978897@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Mar 31, 2017 at 05:48:17PM +0100, David Howells wrote:
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > stat_test.c: In function 'main':
> > stat_test.c:557:3: warning: 'sval' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >    check(sval == scheck,
> >    ^
> > ...
> 
> I don't see any of these.  gcc is actually wrong about this.  What gcc are you
> using?

gcc version 4.9.2 (Debian 4.9.2-10) 


> > +nc: invalid option -- 'U'
> > +/bin/nc: invalid option -- 'U'
> > +nc -h for helpnc -h for help
> 
> Sounds like I need to add my own helper to create AF_UNIX sockets rather than
> using netcat.  What version of nc do you have?  Mine is 7.40.

netcat-traditional_1.10-41 from Debian stable.
