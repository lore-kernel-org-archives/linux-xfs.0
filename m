Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89A957F5D
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 20:38:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6AF32304039
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 18:38:23 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id plNFQ6AclRUkkVrY for
	<xfs@oss.sgi.com>; Tue, 26 Nov 2013 18:38:22 -0800 (PST)
Date: Tue, 26 Nov 2013 21:38:20 -0500 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1428728255.17190956.1385519900454.JavaMail.root@redhat.com>
In-Reply-To: <20131127023119.GB13101@boogeyman>
References: <20131127023119.GB13101@boogeyman>
Subject: Re: Problem with mkfs.xfs on a regular file
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
To: Phil White <cerise-xfs@littlegreenmen.armory.com>
Cc: xfs@oss.sgi.com



----- Original Message -----
> ...
> It's trying to read/write 512 bytes at the beginning of the file which seems
> reasonably innocuous.  I double checked the man page which says that under
> 2.6, O_DIRECT writes can be aligned to 512 bytes without a problem.  sbp
> comes
> out with 4096 in blocksize and 512 in sectsize when zero_old_xfs_structures()
> is called and the first error comes up, so I'm at a loss for what's going
> wrong.

The filesystem backing the new /root/image file doesn't support direct I/O?

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
