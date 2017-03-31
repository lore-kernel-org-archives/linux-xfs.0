Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933334AbdCaPv2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 11:51:28 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170331154315.GB29622@ZenIV.linux.org.uk>
References: <20170331154315.GB29622@ZenIV.linux.org.uk> <20170311065823.4415-1-ebiggers3@gmail.com> <20170320171142.GA26906@gmail.com> <20170320174422.GA9304@infradead.org> <20170331153952.GA32460@infradead.org>
Subject: Re: [PATCH] statx: reject unknown flags when using NULL path
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21300.1490975484.1@warthog.procyon.org.uk>
Date: Fri, 31 Mar 2017 16:51:24 +0100
Message-ID: <21301.1490975484@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers3@gmail.com>, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, "Darrick J . Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> > can we get this in please?  It would be sad to grow another syscall
> > with an unchecked flags argument..
> 
> Applied, will be in tonight pull request...

I'm not convinced that this is right.  I'm more inclined to let any flag be
passed that is available to statx() with a filename and just mask off the
bits before handing them on.

David
