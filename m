Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E37E67F37
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2015 04:11:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D89EAC001
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2015 02:11:18 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id RY4KHPqJBMqbqQfG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Dec 2015 02:11:16 -0800 (PST)
Date: Thu, 24 Dec 2015 02:11:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: A blocksize problem about dax and ext4
Message-ID: <20151224101111.GA6438@infradead.org>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
	<CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
	<CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
	<CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Ted Tso <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, Cholerae Hu <choleraehyq@gmail.com>, Dan Williams <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Dec 24, 2015 at 02:47:07AM +0000, Elliott, Robert (Persistent Memory) wrote:
> > Did you mean that I should make the blocksize bigger until the mount
> > command tell me that dax is enabled?
> 
> To really use DAX, the filesystem block size must match the
> system CPU's page size, which is probably 4096 bytes.

No, it doesn't.  File you use for DAX must be aligne at page size
granularity.  For XFS you could do this with the per-inode extent size
hint for example even if the overall block size is smaller.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
