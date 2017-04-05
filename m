Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58061 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755138AbdDEMaz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 08:30:55 -0400
Date: Wed, 5 Apr 2017 14:30:09 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: Does btrfs get nlink on directories wrong? -- was Re: [PATCH
 2/4] xfstests: Add first statx test [ver #5]
Message-ID: <20170405123008.GB4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170405103809.GY22845@eguan.usersys.redhat.com>
 <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132131706.18980.7074156386090748482.stgit@warthog.procyon.org.uk>
 <2600.1491389621@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2600.1491389621@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Wed, Apr 05, 2017 at 11:53:41AM +0100, David Howells wrote:
> I've added a test to xfstests that exercises the new statx syscall.  However,
> it fails on btrfs:
> 
>      Test statx on a directory
>     +[!] stx_nlink differs, 1 != 2
>     +Failed
>     +stat_test failed
> 
> because a new directory it creates has an nlink of 1, not 2.  Is this a case
> of my making an incorrect assumption or is it an fs bug?

Afaik nlink == 1 means that there's no accounting of subdirectories, and
it's a valid value. The 'find' utility can use nlink to optimize
directory traversal but otherwise I'm not aware of other usage.

All directories in btrfs have nlink == 1.
