Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752491AbdCaJON (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 05:14:13 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxj6eOQ+XukToULq3-y3gv18qMW+dphXBqqZYyiVgeqxwA@mail.gmail.com>
References: <CAOQ4uxj6eOQ+XukToULq3-y3gv18qMW+dphXBqqZYyiVgeqxwA@mail.gmail.com> <15267.1490891560@warthog.procyon.org.uk> <CAOQ4uxiEzYvbAOdsJLOMKESUEVJuC57PPbYHvo-HtDZEiihb3A@mail.gmail.com>
Subject: Re: [PATCH] xfstests: Add first statx test
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8600.1490951650.1@warthog.procyon.org.uk>
Date: Fri, 31 Mar 2017 10:14:10 +0100
Message-ID: <8601.1490951650@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> And maybe use the flag "stx_<field>" (without =<val>) to indicate
> 'compare statx field
> with that of the cmp file'.
> So instead of having an all on nothing 'check that the specified file
> has identical stats'
> tests could be more specific than that.
> And maybe a '-a' flag for 'compare all stats'.

Would comparing anything other than everything or just timestamps actually be
of use, I wonder?

David
