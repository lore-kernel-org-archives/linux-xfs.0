Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:45957 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbfDFNMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Apr 2019 09:12:06 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so7273670iom.12
        for <linux-xfs@vger.kernel.org>; Sat, 06 Apr 2019 06:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <1554042273-3307-1-git-send-email-alex@zadara.com> <20190403140822.GH8633@kroah.com>
In-Reply-To: <20190403140822.GH8633@kroah.com>
From: Alex Lyakas <alex@zadara.com>
Date: Sat, 6 Apr 2019 16:11:53 +0300
Message-ID: <CAOcd+r23YiLOZWoWVkuF3U4EJGiEOFM-1MgZiBgMJA4apavH8w@mail.gmail.com>
Subject: Re: [STABLE PATCH 0/2] Fix in-memory metadata corruption at xfs_attr3_leaf_write_verify()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <greg@kroah.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, hch@lst.de, Shyam Kaushik <shyam@zadara.com>

Hi Greg,

The relevant commits in the Linus's tree are:

b7b2846fe26f2c0d7f317c874a13d3ecf22670ff
xfs: add the ability to join a held buffer to a defer_ops

6e643cd094de3bd0f97edcc1db0089afa24d909f
xfs: hold xfs_buf locked between shortform->leaf conversion and the
addition of an attribute

They were pulled by Linus in commit:

fca0e39b2bd2fcfea2027845df28757943d9f561
Merge tag 'xfs-4.15-fixes-8' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux

Thanks,
Alex.

On Wed, Apr 3, 2019 at 5:08 PM Greg KH <greg@kroah.com> wrote:
>
> On Sun, Mar 31, 2019 at 05:24:33PM +0300, Alex Lyakas wrote:
> > This is a partial backport of original Darrick's series "xfs: logging fixes" to kernel 4.14.
> > It fixes the in-memory metadata corruption error, which happens
> > when a partially initialized attribute buffer is attemped to be written to disk.
> > This issue is reproducible with kernel 4.14, when adding a 1-sec sleep in xfs_attr_set(),
> > between the call to  xfs_attr_shortform_to_leaf() and the call to xfs_attr_leaf_addname().
> >
> > Darrick J. Wong (2):
> >   xfs: add the ability to join a held buffer to a defer_ops
> >   xfs: hold xfs_buf locked between shortform->leaf conversion and the
> >     addition of an attribute
>
> What are the git commit ids of these patches in Linus's tree?
>
> thanks,
>
> greg k-h
