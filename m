Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C222D29DF5
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2015 06:27:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2D4F304032
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2015 04:27:04 -0800 (PST)
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	by cuda.sgi.com with ESMTP id fp6Y3m0cKW5G2lK6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Dec 2015 04:27:02 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: A blocksize problem about dax and ext4
Date: Thu, 24 Dec 2015 12:26:18 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEDCB5E@G9W0745.americas.hpqcorp.net>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
	<CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
	<CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
	<CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
	<20151224101111.GA6438@infradead.org>
In-Reply-To: <20151224101111.GA6438@infradead.org>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Ted Tso <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, Cholerae Hu <choleraehyq@gmail.com>, Dan Williams <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, December 24, 2015 4:11 AM
> Subject: Re: A blocksize problem about dax and ext4
> 
> On Thu, Dec 24, 2015 at 02:47:07AM +0000, Elliott, Robert (Persistent
> Memory) wrote:
> > > Did you mean that I should make the blocksize bigger until the mount
> > > command tell me that dax is enabled?
> >
> > To really use DAX, the filesystem block size must match the
> > system CPU's page size, which is probably 4096 bytes.
> 
> No, it doesn't.  File you use for DAX must be aligne at page size
> granularity.  For XFS you could do this with the per-inode extent
> size hint for example even if the overall block size is smaller.

I think that's a future goal.

Currently, the checks are like this:

	if (sb->s_blocksize != PAGE_SIZE) {
		xfs_alert(mp,
		"Filesystem block size invalid for DAX Turning DAX off.");


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
