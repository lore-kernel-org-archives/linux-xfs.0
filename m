Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48001 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755202AbdCTRo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2017 13:44:29 -0400
Date: Mon, 20 Mar 2017 10:44:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] statx: reject unknown flags when using NULL path
Message-ID: <20170320174422.GA9304@infradead.org>
References: <20170311065823.4415-1-ebiggers3@gmail.com>
 <20170320171142.GA26906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170320171142.GA26906@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, mtk.manpages@gmail.com, Christoph Hellwig <hch@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

On Mon, Mar 20, 2017 at 10:11:42AM -0700, Eric Biggers wrote:
> On Fri, Mar 10, 2017 at 10:58:23PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The statx() system call currently accepts unknown flags when called with
> > a NULL path to operate on a file descriptor.  Left unchanged, this could
> > make it hard to introduce new query flags in the future, since
> > applications may not be able to tell whether a given flag is supported.
> > 
> > Fix this by failing the system call with EINVAL if any flags other than
> > KSTAT_QUERY_FLAGS are specified in combination with a NULL path.
> > 
> 
> Does anyone have comments on this patch?

Looks good to me.

> I really think we need to get this in before v4.11 is released, since it deals
> with the API.

Yes.  And we really need test for all of this.  Or just revert the
patches.  Shipping with untested syscalls is just a desaster.
