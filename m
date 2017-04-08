Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdDHPno (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Apr 2017 11:43:44 -0400
Date: Sat, 8 Apr 2017 23:43:40 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: Does btrfs get nlink on directories wrong? -- was Re: [PATCH
 2/4] xfstests: Add first statx test [ver #5]
Message-ID: <20170408154339.GZ22845@eguan.usersys.redhat.com>
References: <20170405103809.GY22845@eguan.usersys.redhat.com>
 <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132131706.18980.7074156386090748482.stgit@warthog.procyon.org.uk>
 <2600.1491389621@warthog.procyon.org.uk>
 <20170405123008.GB4781@twin.jikos.cz>
 <CAOQ4uxik1EbovazuEnMErR433Eh=Ls8h3LhQPEU2nJhigcR+Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxik1EbovazuEnMErR433Eh=Ls8h3LhQPEU2nJhigcR+Cw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>, dsterba@suse.cz
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>

On Wed, Apr 05, 2017 at 03:32:30PM +0300, Amir Goldstein wrote:
> On Wed, Apr 5, 2017 at 3:30 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Wed, Apr 05, 2017 at 11:53:41AM +0100, David Howells wrote:
> >> I've added a test to xfstests that exercises the new statx syscall.  However,
> >> it fails on btrfs:
> >>
> >>      Test statx on a directory
> >>     +[!] stx_nlink differs, 1 != 2
> >>     +Failed
> >>     +stat_test failed
> >>
> >> because a new directory it creates has an nlink of 1, not 2.  Is this a case
> >> of my making an incorrect assumption or is it an fs bug?
> >
> > Afaik nlink == 1 means that there's no accounting of subdirectories, and
> > it's a valid value. The 'find' utility can use nlink to optimize
> > directory traversal but otherwise I'm not aware of other usage.
> >
> > All directories in btrfs have nlink == 1.
> 
> FYI,
> 
> Overlayfs uses nlink = 1 for merge dirs to silence 'find' et al.
> Ext4 uses nlink = 1 for directories with more than 32K subdirs
> (EXT4_FEATURE_RO_COMPAT_DIR_NLINK).
> 
> But in both those fs newly created directories will have nlink = 2.

Is there a conclusion on this? Seems the test should be updated
accordingly?

Thanks,
Eryu
