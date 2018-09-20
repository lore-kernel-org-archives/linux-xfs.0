Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388196AbeIUBsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 21:48:23 -0400
Date: Thu, 20 Sep 2018 13:03:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] mkfs: move 'mounted' check before 'existing fs' check
Message-ID: <20180920200308.GJ20086@magnolia>
References: <20180919125617.28048-1-jtulak@redhat.com>
 <20180919125617.28048-2-jtulak@redhat.com>
 <20180919144853.GI20086@magnolia>
 <CACj3i73ARZddDcCp9BJ626eo3v4N-dy535qSRLZUPT3==rdZjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73ARZddDcCp9BJ626eo3v4N-dy535qSRLZUPT3==rdZjA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

On Wed, Sep 19, 2018 at 05:05:38PM +0200, Jan Tulak wrote:
> On Wed, Sep 19, 2018 at 4:49 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Wed, Sep 19, 2018 at 02:56:17PM +0200, Jan Tulak wrote:
> > > Check if a device is mounted (and issue an error about that) before
> > > asking for -f flag.
> > >
> > > Example of the old behaviour I'm changing:
> > > $ mkfs.xfs /dev/sda1
> > > mkfs.xfs: /dev/sda1 appears to contain an existing filesystem (xfs).
> > > mkfs.xfs: Use the -f option to force overwrite.
> > >
> > > $ mkfs.xfs -f /dev/sda1
> > > mkfs.xfs: /dev/sda1 contains a mounted filesystem
> >
> > I'm confused by the commit message -- what is the new behavior?
> >
> > Is it this?
> >
> > $ mkfs.xfs /dev/sda1
> > mkfs.xfs: /dev/sda1 contains a mounted filesystem
> >
> > $ mkfs.xfs -f /dev/sda1
> > mkfs.xfs: /dev/sda1 contains a mounted filesystem
> 
> Yes. I should put it right into the commit message.

With that added,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Jan
> 
> -- 
> Jan Tulak
> jtulak@redhat.com / jan@tulak.me
