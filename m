Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34910 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbfE3P3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 May 2019 11:29:39 -0400
Date: Thu, 30 May 2019 08:28:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: How to package e2scrub
Message-ID: <20190530152855.GA5390@magnolia>
References: <20190529120603.xuet53xgs6ahfvpl@work>
 <20190529182111.GA5220@magnolia>
 <20190530060426.GA30438@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530060426.GA30438@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, May 29, 2019 at 11:04:26PM -0700, Christoph Hellwig wrote:
> On Wed, May 29, 2019 at 11:21:11AM -0700, Darrick J. Wong wrote:
> > Indeed.  Eric picked "xfsprogs-xfs_scrub" for Rawhide, though I find
> > that name to be very clunky and would have preferred "xfs_scrub".
> 
> Why not just xfs-scrub?

Slight preference for the package sharing a name with its key
ingredient:

# xfs_scrub /home
Bad command or file name
# apt install xfs_scrub
<stuff>
# xfs_scrub /home
WARNING: ALL DATA ON NON-REMOVABLE DISK
DRIVE C: WILL BE LOST!
Proceed with Format (Y/N)?

--D
