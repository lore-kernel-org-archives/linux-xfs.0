Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933149AbdCaQC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 12:02:27 -0400
Date: Fri, 31 Mar 2017 09:02:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] statx: reject unknown flags when using NULL path
Message-ID: <20170331160224.GA27791@infradead.org>
References: <20170331154315.GB29622@ZenIV.linux.org.uk>
 <20170311065823.4415-1-ebiggers3@gmail.com>
 <20170320171142.GA26906@gmail.com>
 <20170320174422.GA9304@infradead.org>
 <20170331153952.GA32460@infradead.org>
 <21301.1490975484@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21301.1490975484@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers3@gmail.com>, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, "Darrick J . Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

On Fri, Mar 31, 2017 at 04:51:24PM +0100, David Howells wrote:
> I'm not convinced that this is right.  I'm more inclined to let any flag be
> passed that is available to statx() with a filename and just mask off the
> bits before handing them on.

And what would these flags actually do?  Currently we verify that
the allowed flags are passed for the case where we have a filename.

We need to do the same for the non-filename case, and we should
also check that we don't pass flags that don't make sense for this case.

Eric's patch is doing exactly that.

The only thing he could do even better is to add a testcase to xfstests
to verify this :)
