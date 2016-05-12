Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 917DA7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 12:06:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13BF7AC001
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 10:06:42 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id EMWqXZpzcUneVX3F for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 10:06:41 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v7 4/6] dax: export a low-level __dax_zero_page_range
	helper
Date: Thu, 12 May 2016 17:06:39 +0000
Message-ID: <1463072787.29294.38.camel@intel.com>
References: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
	<1463000932-31680-5-git-send-email-vishal.l.verma@intel.com>
	<20160512084138.GC10306@quack2.suse.cz>
In-Reply-To: <20160512084138.GC10306@quack2.suse.cz>
Content-Language: en-US
Content-ID: <9CB344B4DD27584EAD3C45DE3E6E0947@intel.com>
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
To: "jack@suse.cz" <jack@suse.cz>
Cc: "hch@infradead.org" <hch@infradead.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "axboe@fb.com" <axboe@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "boaz@plexistor.com" <boaz@plexistor.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "hch@lst.de" <hch@lst.de>

On Thu, 2016-05-12 at 10:41 +0200, Jan Kara wrote:
> On Wed 11-05-16 15:08:50, Vishal Verma wrote:
> > 
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > This allows XFS to perform zeroing using the iomap infrastructure
> > and
> > avoid buffer heads.
> > 
> > [vishal: fix conflicts with dax-error-handling]
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> BTW: You are supposed to add your Signed-off-by when forwarding
> patches
> like this...

Ah I didn't know. I'll add it when making the stable topic branch for
this. Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
