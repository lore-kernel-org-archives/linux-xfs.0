Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48FA47FB9
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 04:11:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37D508F808F
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 02:11:13 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id L9OOwGkPz7eHIdEz for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 02:11:12 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] Fix O_SYNC AIO DIO
Date: Wed, 14 Aug 2013 11:10:54 +0200
Message-Id: <1376471456-11966-1-git-send-email-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>, xfs@oss.sgi.com

  Hello,

  this is second iteration of patches to fix handling of O_SYNC AIO DIO.
Since previous version I've addressed Dave's comments:
 - slightly expanded changelog of the first patch
 - workqueue is now created with parameters allowing paralelism
 - workqueue name contains sb->s_id
 - workqueue is created on demand (I decided to do this to reduce the overhead
   in unnecessary cases)

The patchset survives xfstests run for ext4 & xfs so it should be sane. Since
this touches several filesystems (although only ext4 & xfs are non-trivial),
the question is who should carry these patches. Maybe Al? But since xfs and
ext4 changes are non-trivial, I'd like to have a review from their
developers...

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
