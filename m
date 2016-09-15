Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 313947CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 03:26:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C288B304039
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 01:26:21 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id D3CREgitE7n3ALam (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Sep 2016 01:26:17 -0700 (PDT)
Date: Thu, 15 Sep 2016 10:26:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
Message-ID: <20160915082615.GA9772@lst.de>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
	<147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, npiggin@gmail.com, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de

On Wed, Sep 14, 2016 at 11:54:38PM -0700, Dan Williams wrote:
> The DAX property, page cache bypass, of a VMA is only detectable via the
> vma_is_dax() helper to check the S_DAX inode flag.  However, this is
> only available internal to the kernel and is a property that userspace
> applications would like to interrogate.

They have absolutely no business knowing such an implementation detail.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
