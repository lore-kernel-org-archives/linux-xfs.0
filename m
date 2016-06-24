Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E89CA7CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 02:31:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A871A8F8037
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:31:12 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 401sIY8mWBQaN2bQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:31:10 -0700 (PDT)
Date: Fri, 24 Jun 2016 09:31:09 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Message-ID: <20160624073109.GB22205@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard>
	<CAPcyv4iWVyJ3vb+_dtehGRxT9WXwAxNXoDMNeNtxO+=njHNAhg@mail.gmail.com>
	<20160624071318.GE12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160624071318.GE12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, XFS Developers <xfs@oss.sgi.com>

On Fri, Jun 24, 2016 at 05:13:18PM +1000, Dave Chinner wrote:
> This is a POSIX compliant fsync() implementation:
> 
> int fsync(int fd)
> {
> 	return 0;
> }

Depends on what you mean with "Posix".  Modern Posix which includex
XPG has the _POSIX_SYNCHRONIZED_IO option, which Linux implements.  For
that Posix says about fsync:

    [SIO] [Option Start] If _POSIX_SYNCHRONIZED_IO is defined, the fsync()
    function shall force all currently queued I/O operations associated with
    the file indicated by file descriptor fildes to the synchronized I/O
    completion state. All I/O operations shall be completed as defined for
    synchronized I/O file integrity completion. [Option End]


Whereas synchronized I/O file integrity completion is defined as:

     3.378 Synchronized I/O Data Integrity Completion

     For read, when the operation has been completed or diagnosed if
     unsuccessful. The read is complete only when an image of the data has been
     successfully transferred to the requesting process. If there were any
     pending write requests affecting the data to be read at the time that the
     synchronized read operation was requested, these write requests are
     successfully transferred prior to reading the data.

     For write, when the operation has been completed or diagnosed if
     unsuccessful. The write is complete only when the data specified in the
     write request is successfully transferred and all file system information
     required to retrieve the data is successfully transferred.

     File attributes that are not necessary for data retrieval (access time,
     modification time, status change time) need not be successfully
     transferred prior to returning to the calling process.

     3.379 Synchronized I/O File Integrity Completion

     Identical to a synchronized I/O data integrity completion with the
     addition that all file attributes relative to the I/O operation (including
     access time, modification time, status change time) are successfully
     transferred prior to returning to the calling process.


So in this case Posix very much requires data to be on a stable
medium.

> The POSIX exclusive write requirement is a different case. No linux
> filesystem except XFS has ever met that requirement (in 20 something
> years), yet I don't see applications falling over with corrupt data
> from non-exclusive writes all the time, nor do I see application
> developers shouting at us to provide it. i.e. reality tells us this
> isn't a POSIX behaviour that applications rely on because everyone
> implements it differently.

Every file system exludes writes from other writes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
