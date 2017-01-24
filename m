Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25805 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdAXS1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 13:27:25 -0500
Date: Tue, 24 Jan 2017 10:27:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: use per-AG reservations for the finobt
Message-ID: <20170124182717.GD9134@birch.djwong.org>
References: <1485194742-23185-1-git-send-email-hch@lst.de>
 <20170124140649.GC60234@bfoster.bfoster>
 <20170124144937.GA27261@lst.de>
 <20170124161917.GF60234@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124161917.GF60234@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 11:19:18AM -0500, Brian Foster wrote:
> On Tue, Jan 24, 2017 at 03:49:37PM +0100, Christoph Hellwig wrote:
> > On Tue, Jan 24, 2017 at 09:06:49AM -0500, Brian Foster wrote:
> > > Darrick called out in the previous version that this requires traversal
> > > of the entire tree at mount time. Do you have any test results on what
> > > kind of worst case mount delays we could be looking at here?
> > 
> > Even with pretty horribly fragmented file systems I've not seen
> > major delays.  But I don't have a setup with a lot of actual disks
> > but mostly SSDs these days, so this might not statistically significant.
> 
> Heh, I might have some systems with slow storage around. ;P It may take
> a little time to populate a large enough fs with inodes though..

<anecdote>

So on this laptop, we have:

$ df -i /storage/; df /storage/
Filesystem                     Inodes IUsed IFree IUse% Mounted on
/dev/mapper/birch_disk-storage   466M  1.8M  464M    1% /storage
Filesystem                      Size  Used Avail Use% Mounted on
/dev/mapper/birch_disk-storage  931G  525G  407G  57% /storage

$ sudo xfs_io -c 'fsmap -v -n 1024' . | grep 'inode btree' | \
	awk '{moo[$6] += $8}END{for (x=0;x<=255;x++) if (x in moo) print x, moo[x]}'
0	144
1	160
2	152
3	136
4	152
5	152
6	168
7	152

So on average we have ~160 sectors (or about 20 blocks) of inobt/finobt
in each of 8 AGs.

</anecdote>

--D

> 
> Brian
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
