Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE5887CA4
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 08:39:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ADFFD8F8033
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:39:32 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id fq8EJO6hcXy41eMp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:39:30 -0700 (PDT)
Date: Tue, 28 Jun 2016 15:39:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Message-ID: <20160628133928.GB31283@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
	<20160624230045.GG12670@dastard> <20160628131059.GA30475@lst.de>
	<57727B27.7060104@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57727B27.7060104@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jun 28, 2016 at 04:27:03PM +0300, Boaz Harrosh wrote:
> > Right.  And an existing application can get DAX turned on under its
> > back, and will now suddently get different synchronization behavior.
> > That is if it's writes happen to be aligned to the fs block size.
> > 
> 
> Is there an actual application that does that? or is this purely
> theoretical right now?

Lots of them.  The typical case is multithreaded (or preforked like old
apache) daemons that use O_APPEND to write to a common log file.  Then
again those log records will usually not be 4k aligned, so they'd still
accidentally get the exclusive locking even without this patch.  But
beware the case where a log record actually matches the alignment..

> 
> 
> Thanks
> Boaz
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
