Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:42174 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932957AbdCURva (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Mar 2017 13:51:30 -0400
Date: Tue, 21 Mar 2017 13:51:29 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170321175129.GC17872@fieldses.org>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
 <20161222084549.GA8833@infradead.org>
 <1482417724.3924.39.camel@redhat.com>
 <20170320214327.GA5098@fieldses.org>
 <20170321134500.GA1318@infradead.org>
 <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com>
 <20170321173704.GA17872@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170321173704.GA17872@fieldses.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Mar 21, 2017 at 01:37:04PM -0400, J. Bruce Fields wrote:
> On Tue, Mar 21, 2017 at 01:23:24PM -0400, Jeff Layton wrote:
> > On Tue, 2017-03-21 at 12:30 -0400, J. Bruce Fields wrote:
> > > 	- NFS doesn't actually require that it increases, but I think it
> > > 	  should.  I assume 64 bits means we don't need a discussion of
> > > 	  wraparound.
> > 
> > I thought NFS spec required that you be able to recognize old change
> > attributes so that they can be discarded. I could be wrong here though.
> > I'd have to go back and look through the spec to be sure.
> 
> https://tools.ietf.org/html/rfc7862#section-10

So, I'm suggesting we implement this one:

	NFS4_CHANGE_TYPE_IS_MONOTONIC_INCR:  The change attribute value
	  MUST monotonically increase for every atomic change to the file
	  attributes, data, or directory contents.

It may be a slight lie--after your patches we wouldn't actually increase
"for every atomic change".  I think that's OK.

--b.
