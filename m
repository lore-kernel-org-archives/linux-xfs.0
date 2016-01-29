Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75A787CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 17:40:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01364AC002
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 15:40:41 -0800 (PST)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	VFgTlbPEFdZ8sOV1 for <xfs@oss.sgi.com>;
	Fri, 29 Jan 2016 15:40:41 -0800 (PST)
Date: Fri, 29 Jan 2016 16:40:36 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: real-time device BUG
Message-ID: <20160129234036.GA24929@linux.intel.com>
References: <20160129230531.GA29895@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160129230531.GA29895@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jan 29, 2016 at 04:05:31PM -0700, Ross Zwisler wrote:
> Today I was trying to get real-time devices working with XFS, and both a
> manual pwrite() to a real-time device and xfs_rtcp end up with a lockdep spat
> followed by a kernel BUG.  This behavior is consistent between kernel versions
> v4.4 and v4.5-rc1.  I initially found this using some pmem block devices, but
> it also happens with BRD.

This also happens with an mmap on the real-time file followed by a write.
Essentially I think that any path that tries to allocate a block for the real
time file his this same BUG.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
