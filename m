Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 813FF29DF5
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 20:48:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67AA88F8039
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 18:48:20 -0800 (PST)
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
	by cuda.sgi.com with ESMTP id 2hnJ2utobnam6ePx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2015 18:48:18 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: A blocksize problem about dax and ext4
Date: Thu, 24 Dec 2015 02:47:07 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
	<CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
	<CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
	<CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
In-Reply-To: <CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
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
To: Cholerae Hu <choleraehyq@gmail.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Ted Tso <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

> -----Original Message-----
> From: Cholerae Hu [mailto:choleraehyq@gmail.com]
> Sent: Wednesday, December 23, 2015 8:36 PM
> Subject: Re: A blocksize problem about dax and ext4
...
> xfs will silently disable dax when the fs block size is too small,
> i.e. your mmap() operations are backed by page cache in this case.
> Currently the only indication of whether a mapping is DAX backed or
> not is the presence of the VM_MIXEDMAP flag ("mm" in the VmFlags field
> of /proc/<pid>/smaps)
> 
> Did you mean that I should make the blocksize bigger until the mount
> command tell me that dax is enabled?

To really use DAX, the filesystem block size must match the
system CPU's page size, which is probably 4096 bytes.

---
Robert Elliott, HPE Persistent Memory

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
