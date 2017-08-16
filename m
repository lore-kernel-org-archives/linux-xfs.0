Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34709 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751841AbdHPTbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 15:31:06 -0400
Received: by mail-qk0-f194.google.com with SMTP id q66so4261783qki.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 12:31:06 -0700 (PDT)
Date: Wed, 16 Aug 2017 16:31:01 -0300
From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170816193100.GA1216@debian.home>
References: <20170814081806.GA3924@debian.home>
 <20170815020018.GF21024@dastard>
 <20170815061857.GA2803@debian.home>
 <20170815084430.GK21024@dastard>
 <20170815192938.GA1247@debian.home>
 <20170816002511.GM21024@dastard>
 <20170816071649.GA4143@debian.home>
 <20170816133502.GN21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170816133502.GN21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>, Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?= <ernesto.mnd.fernandez@gmail.com>

On Wed, Aug 16, 2017 at 11:35:02PM +1000, Dave Chinner wrote:
> On Wed, Aug 16, 2017 at 04:16:53AM -0300, Ernesto A. Fernández wrote:
> > On Wed, Aug 16, 2017 at 10:25:11AM +1000, Dave Chinner wrote:
> > > With that in mind, here's waht I suggested above: set the mode after
> > > the xattr. I haven't tested it - can you check it solves the problem
> > > case you are testing?
> > 
> > It does. Of course the test still fails, as I said before, now claiming that
> > the filesystem is inconsistent. But that's a separate issue.
> 
> It shouldn't be - what's the error that is being reported?

xfs_repair, phase 3:
bad magic number febe in block 512 (14452) for directory inode 131
problem with attribute contents in inode 131
would clear attr fork
bad nblocks 11900 for inode 131, would reset to 11274
bad anextents 1 for inode 131, would reset to 0


This is not a result of your patch, it was already happening before.
It seems to be caused by setting too many extended attributes to a
file.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
