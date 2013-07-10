Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 01D947F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 17:01:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D58D58F8040
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 15:01:38 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id AE3y9EyCnReFFEiJ for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 15:01:38 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fix O_SYNC AIO DIO
Date: Thu, 11 Jul 2013 00:01:27 +0200
Message-Id: <1373493689-2168-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org, hch@lst.de

  Hello,

  so now that necessary patches for ext4 writeback code are merged, I've ported
Christoph's patches to fix handling of O_SYNC AIO DIO to current kernel. The
patchset survives xfstests run for ext4 & xfs so it should be sane. Since this
touches several filesystems (although only ext4 & xfs are non-trivial), the
question is who should carry these patches. Maybe Al? But since xfs and ext4
changes are non-trivial, I'd like to have a review from their developers...

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
