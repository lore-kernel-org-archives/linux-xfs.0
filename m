Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34026 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932600AbdIFOuI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 10:50:08 -0400
Date: Wed, 6 Sep 2017 10:50:04 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: test the per-inode DAX flag
Message-ID: <20170906145004.hlkwta2a4bjlarin@thunk.org>
References: <20170903093325.GA16272@lst.de>
 <20170904072431.GW27835@eguan.usersys.redhat.com>
 <20170904154453.GA6771@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904154453.GA6771@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 04, 2017 at 05:44:53PM +0200, Christoph Hellwig wrote:
> > Does this test make sense when filesystem was mounted without dax
> > option? I saw these failures when testing on normal block device without
> > dax mount option.
> 
> And thinking about it - why would we not allow setting the flag,
> especially given that right now it doesn't have a meaning either
> with or without DAX..

At least for the ext4 patches that have been crossing my screen, the
claim from the commit description is that with the dax mount option,
all files are treated as if the DAX flag.  And the point of the DAX
flag is that if the file system is stored on DAX-capable hardware, and
you don't want DAX treatment for all files, that you would set the DAX
flag only for those files where having the file system actually using
the DAX codepaths would make sense --- as opposed to just using the
traditional block I/O paths against the /dev/pmem driver.

So I *think* the answer is that the tax makes sense when the file
system is mounted w/o the dax option, but we do need to check to see
whether the block device is DAX capable.

It also makes an interesting question how we should be testing DAX
capable file systems on /dev/pmem0.  Right now I force the use of
/dev/pmem0 *and* use the DAX mount options so that all of the other
tests will cause file I/O to use the DAX path.  But for the per-inode
DAX flag, we would want to mask out the DAX mount option so we can
test what happens when we toggle the DAX.

But I'm not a DAX expert, so I may have some of this wrong.

    	      	  	       	   	- Ted
