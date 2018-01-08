Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932324AbeAHNq3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 08:46:29 -0500
Message-ID: <1515419184.3486.21.camel@kernel.org>
Subject: Re: [PATCH v4 19/19] fs: handle inode->i_version more efficiently
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 08 Jan 2018 08:46:24 -0500
In-Reply-To: <20180108133025.GA31867@bombadil.infradead.org>
References: <20171222120556.7435-1-jlayton@kernel.org>
         <20171222120556.7435-20-jlayton@kernel.org>
         <20180108133025.GA31867@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Mon, 2018-01-08 at 05:30 -0800, Matthew Wilcox wrote:
> On Fri, Dec 22, 2017 at 07:05:56AM -0500, Jeff Layton wrote:
> > +	cur = inode_peek_iversion_raw(inode);
> > +	for (;;) {
> > +		/* If flag is clear then we needn't do anything */
> > +		if (!force && !(cur & I_VERSION_QUERIED))
> > +			return false;
> > +		/* Since lowest bit is flag, add 2 to avoid it */
> > +		new = (cur & ~I_VERSION_QUERIED) + I_VERSION_INCREMENT;
> 
> Isn't this an extraordinarily complicated way of spelling:
> 
> 		new = cur + 1;
> 
> We know 'cur' has I_VERSION_QUERIED set, so clearing that bit and adding
> two is going to be the same as adding 1 ... right?
> 

It would be, but if "force" is true, then I_VERSION_QUERIED may not be
set.
-- 
Jeff Layton <jlayton@kernel.org>
