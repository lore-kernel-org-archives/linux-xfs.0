Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751475AbdDHVCn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Apr 2017 17:02:43 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170408154339.GZ22845@eguan.usersys.redhat.com>
References: <20170408154339.GZ22845@eguan.usersys.redhat.com> <20170405103809.GY22845@eguan.usersys.redhat.com> <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk> <149132131706.18980.7074156386090748482.stgit@warthog.procyon.org.uk> <2600.1491389621@warthog.procyon.org.uk> <20170405123008.GB4781@twin.jikos.cz> <CAOQ4uxik1EbovazuEnMErR433Eh=Ls8h3LhQPEU2nJhigcR+Cw@mail.gmail.com>
Subject: Re: Does btrfs get nlink on directories wrong? -- was Re: [PATCH 2/4] xfstests: Add first statx test [ver #5]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9145.1491685360.1@warthog.procyon.org.uk>
Date: Sat, 08 Apr 2017 22:02:40 +0100
Message-ID: <9146.1491685360@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, dsterba@suse.cz, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>

Eryu Guan <eguan@redhat.com> wrote:

> > Overlayfs uses nlink = 1 for merge dirs to silence 'find' et al.
> > Ext4 uses nlink = 1 for directories with more than 32K subdirs
> > (EXT4_FEATURE_RO_COMPAT_DIR_NLINK).
> > 
> > But in both those fs newly created directories will have nlink = 2.
> 
> Is there a conclusion on this? Seems the test should be updated
> accordingly?

I've dropped the nlink check on directories.

David
