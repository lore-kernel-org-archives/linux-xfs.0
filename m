Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39176 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751156AbdEBOrc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 May 2017 10:47:32 -0400
Date: Tue, 2 May 2017 16:47:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
Message-ID: <20170502144730.GA22578@lst.de>
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com> <20170502073019.GD11582@lst.de> <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com> <20170502141751.GA21564@lst.de> <CAOQ4uxgO64HhFq-xYOY4r1ob_qH1BQbkHyzBSpwmv0WPxX7A1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgO64HhFq-xYOY4r1ob_qH1BQbkHyzBSpwmv0WPxX7A1Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, May 02, 2017 at 05:27:36PM +0300, Amir Goldstein wrote:
> On Tue, May 2, 2017 at 5:17 PM, Christoph Hellwig <hch@lst.de> wrote:
> > On Tue, May 02, 2017 at 05:13:56PM +0300, Amir Goldstein wrote:
> >> How can it create problems if uniqueness is not guaranteed with
> >> Current s_uuid? Even if we did make the xfs uuid table code generic
> >> It couldn't be the vfs default. Filesystems will have to opt in.
> >
> > It creates problems if you e.g. mount an ext4 fs and a dm snaphot of
> > it.  The non-XFS file systems are simply buggy in this regard.
> >
> > Non-uniqueue uuids are an absolute no-go.
> 
> I'm not sure I follow your specific concern here.
> Surely you are not proposing to get rid of the nouuid
> mount option, are you? So what's the point of hiding
> the fact that there are 2 mounted filesystems with the
> same uuid from VFS?

Because it breaks people using s_uuid.  Take a look at cleancache,
which identifies a pool with it.  Once you have to snapshot with
the same uuid the pool concept is broken.  Same for any sort of
use in file handles.

The U in UUID stands for unique, and we must ensure that's actually
true.

> 
> Because that is the the only implication of exporting
> s_uuid regardless of nouuid mount option.
> 
> Whether or not ext4 and other fs should restrict
> multi mount of same uuid is a completely different
> issue.

It's not.  The whole point of exporting s_uuid is to have a uniqueue
identifier for a superblock.  If it's not actually uniqueue there is
no point in having or using it.
