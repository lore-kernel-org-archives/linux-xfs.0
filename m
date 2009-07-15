Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6FLTcfh222647 for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 16:29:38 -0500
Received: from sca-es-mail-1.sun.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31A8BA6B869
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 14:37:47 -0700 (PDT)
Received: from sca-es-mail-1.sun.com (sca-es-mail-1.Sun.COM [192.18.43.132])
	by cuda.sgi.com with ESMTP id FFhOEKBtNYpV7Aji for
	<xfs@oss.sgi.com>; Wed, 15 Jul 2009 14:37:47 -0700 (PDT)
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id
	n6FLU5Pu028426
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 14:30:09 -0700 (PDT)
MIME-version: 1.0
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
	(Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16
	2009))
	id <0KMU00E00EAHGW00@fe-sfbay-09.sun.com> for xfs@oss.sgi.com; Wed,
	15 Jul 2009 14:30:05 -0700 (PDT)
Date: Wed, 15 Jul 2009 17:30:01 -0400
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] xfstests: very basic defragmentation testing for xfs
	&	ext4
In-reply-to: <4A5E3A37.5050306@redhat.com>
Message-id: <20090715213001.GH14175@webber.adilger.int>
References: <4A5E3A37.5050306@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Jul 15, 2009  15:21 -0500, Eric Sandeen wrote:
> This test creates some files, runs defrag on them,
> and compares the before/after fragmentation as well
> as file md5sums and timestamps.
> 
> (md5sums may just be reading buffered data though,
> suggestions?)

(umount; mount)?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
