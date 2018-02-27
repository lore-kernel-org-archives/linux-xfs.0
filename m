Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58690 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751530AbeB0DSO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 22:18:14 -0500
Date: Mon, 26 Feb 2018 22:17:57 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] mkfs config file bikeshed now!
Message-ID: <20180227031757.GB24294@thunk.org>
References: <20180226224224.GE19312@magnolia>
 <20180227000122.GR14069@wotan.suse.de>
 <3e239e61-bc79-c594-c1fd-44fa3efe779d@sandeen.net>
 <CAB=NE6U+7hmRhrkkd1v=rEKrcY+NNf61jL9B4nm=kDbTPvy--w@mail.gmail.com>
 <20180227002550.GH19312@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180227002550.GH19312@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

So number one, unlike everyone else, I didn't reinvent the wheel.  I
grabbed the same wheel I wrote for MIT Kerberos years before.  :-)

Number two, for examples for I wanted the nesting, from MIT Kerberos:

[realms]
         ATHENA.MIT.EDU = {
             kdc = kerberos.mit.edu
             kdc = kerberos-1.mit.edu
             kdc = kerberos-2.mit.edu:750
             admin_server = kerberos.mit.edu
             master_kdc = kerberos.mit.edu
             default_domain = mit.edu
         }
         EXAMPLE.COM = {
             kdc = kerberos.example.com
             kdc = kerberos-1.example.com
             admin_server = kerberos.example.com
         }

And from the file system world, from /etc/mke2fs.conf:

[fs_types]
	ext3 = {
		features = has_journal
	}
	ext4 = {
		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize
		inode_size = 256
	}
	small = {
		blocksize = 1024
		inode_size = 128
		inode_ratio = 4096
	}
	...


It's been handy inside Google since we have different file system
configs for different use cases, so we do things like:

	mke2fs -T foo-use /dev/sdX

and
	mke2fs -T bar-use /dev/sdX


... where foo-use and bar-use would be subsections under fs_types.

But hey, to be clear, I'm not the one trying to claim everyone should
use my library (even though it's the best looking and above-average,
ala Lake Wobegon. :-)

       	       	     	    	     	  - Ted
