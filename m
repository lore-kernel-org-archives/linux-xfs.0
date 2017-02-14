Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbdBNIAX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 03:00:23 -0500
Date: Tue, 14 Feb 2017 00:00:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: add inode helpers for fsuid and fsgid
Message-ID: <20170214080016.GB12767@infradead.org>
References: <1487008001.3125.41.camel@HansenPartnership.com>
 <20170213194337.GA9852@infradead.org>
 <20170213213416.GA15349@dastard>
 <20170214060809.GA21114@infradead.org>
 <1487053651.3125.72.camel@HansenPartnership.com>
 <1487053720.3125.73.camel@HansenPartnership.com>
 <87lgt9mcyv.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lgt9mcyv.fsf@xmission.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

On Tue, Feb 14, 2017 at 08:46:32PM +1300, Eric W. Biederman wrote:
> All of that said where are you getting sb->s_user_ns != &init_user_ns
> for an xfs filesystem?  There are quite a few xfs interfaces that are
> not ready for that.   xfs has a very wide userspace interface of ioctls
> that all needs to be looked at and addressed carefully if there is
> anything like this going on.

The only thing exposing uids/gid is the bulkstat code, and that's
easy to cover.

> > +/* return the current id in the filesystem view */
> > +#define i_fsuid(i) from_kuid((i)->i_sb->s_user_ns, current_fsuid())
> > +#define i_fsgid(i) from_kgid((i)->i_sb->s_user_ns, current_fsgid())
> 
> Could we please place these helpers in fs.h?
> That should allow them to become inline functions and live with the
> existing filesystem helpers in there.

And give them better names, i_* is rather cryptic.
