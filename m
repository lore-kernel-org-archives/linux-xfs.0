Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34291 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729220AbfFRJgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 05:36:20 -0400
Date: Tue, 18 Jun 2019 17:36:11 +0800
From: Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Message-ID: <20190618093611.nq27tmcpjxpwxpw6@XZHOUW.usersys.redhat.com>
References: <20190611153916.13360-1-amir73il@gmail.com>
 <20190611153916.13360-2-amir73il@gmail.com>
 <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
 <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 18, 2019 at 12:16:45PM +0300, Amir Goldstein wrote:
> On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > On Tue, Jun 11, 2019 at 06:39:16PM +0300, Amir Goldstein wrote:
> > > Depending on filesystem, copying from active swapfile may be allowed,
> > > just as read from swapfile may be allowed.
> >
> > ...snip..
> >
> > > +# This is a regression test for kernel commit:
> > > +#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
> >
> > Would you mind updating sha1 after it get merged to Linus tree?
> >
> > That would be helpful for people tracking this issue.
> >
> 
> This is the commit id in linux-next and expected to stay the same
> when the fix is merged to Linus tree for 5.3.

That's perfect. :)

> 
> Thanks,
> Amir.
