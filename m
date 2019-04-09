Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57512 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfDIDSL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 23:18:11 -0400
Date: Mon, 8 Apr 2019 20:18:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: don't allow most setxattr to immutable files
Message-ID: <20190409031801.GD5147@magnolia>
References: <155466882175.633834.15261194784129614735.stgit@magnolia>
 <155466884962.633834.14320700092446721044.stgit@magnolia>
 <CAOQ4uxj4WLX8sWbnm11Ps+rmCNTPecV-w9YUzJfKDtDs+qTx3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj4WLX8sWbnm11Ps+rmCNTPecV-w9YUzJfKDtDs+qTx3Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>

On Mon, Apr 08, 2019 at 09:20:47AM +0300, Amir Goldstein wrote:
> On Sun, Apr 7, 2019 at 11:28 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > The chattr manpage has this to say about immutable files:
> >
> > "A file with the 'i' attribute cannot be modified: it cannot be deleted
> > or renamed, no link can be created to this file, most of the file's
> > metadata can not be modified, and the file can not be opened in write
> > mode."
> >
> > However, we don't actually check the immutable flag in the setattr code,
> > which means that we can update project ids and extent size hints on
> > supposedly immutable files.  Therefore, reject a setattr call on an
> > immutable file except for the case where we're trying to unset
> > IMMUTABLE.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Did you miss my comment on v1, or do you not think this use case
> is going to hurt any application that is not a rootkit?
> 
> chattr +i foo => OK
> chattr +i foo => -EPERM

Nah, I plain forgot to update the patch. :(

Will send v2 where you're allowed to +i multiple times so long as that's
the only thing you're changing.

--D

> Thanks,
> Amir.
