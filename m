Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 174F47CA0
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 08:27:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BCE4A304048
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 06:27:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hCkYCkJIBBhQx0yF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 Jun 2016 06:27:44 -0700 (PDT)
Date: Sat, 18 Jun 2016 09:27:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: on-disk free blocks B-Tree update
Message-ID: <20160618132742.GB47303@bfoster.bfoster>
References: <97A4F433DEE099488FE21C1718A641D213A0320A@wmsexchsvr02.winmagic.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <97A4F433DEE099488FE21C1718A641D213A0320A@wmsexchsvr02.winmagic.local>
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
To: Benjamin Wirth <Benjamin.Wirth@winmagic.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jun 17, 2016 at 08:02:59PM +0000, Benjamin Wirth wrote:
> Hello XFS community,
> 
> I have code that parses the free blocks B-Tree from the disk but it seems to me that the on-disk version of the B-Tree is not updated even when sync() is called, so that the disk version of the B-Tree becomes outdated. Is that correct?
> 
> I have debug information from the kernel BIO layer where I see sectors/blocks being flushed out by the sync but the B-Tree on disk still lists those blocks as free. At what time is the on-disk B-Tree updated, only at umount?
> 

Calling sync() will first flush out all cached user data. This, in turn,
may result in block allocation transactions, etc. sync() then calls into
the fs superblock ->sync_fs() handler, which on XFS forces the log to
disk. This means the metadata changes associated with the user data are
persistent in the log, but not necessarily written back to disk. This
occurs some time later according to the internal state of the fs.

> Is there any way to force the in-memory B-Tree to be flushed to disk?
> 

The only thing that comes to mind is to freeze ('fsfreeze -f <mnt>') the
fs, which appears to push the AIL. This is really the only way to get a
coherent view of the fs on disk while mounted, anyways. I also assume
you're using direct I/O, as the underlying disk buffer/page cache is not
coherent with XFS I/O.

Brian

> Thanks for any help,
> Ben
> 
> Benjamin Wirth | Senior Software Developer
> WinMagic Inc.
> 5600A Cancross Court
> Mississauga, ON  |  L5R 3E9 |  Canada
> 

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
