Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4AGPKf4190041 for <xfs@oss.sgi.com>; Sun, 10 May 2009 11:25:21 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F86E27640B
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 09:25:25 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id x7MCQtuHn4CAvUGH for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 09:25:25 -0700 (PDT)
Message-ID: <4A06FFF3.2090103@sandeen.net>
Date: Sun, 10 May 2009 11:25:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfs: remove ->write_super and stop maintaining
	->s_dirt
References: <20090426140305.113371000@bombadil.infradead.org>
	<20090426140707.533370000@bombadil.infradead.org>
In-Reply-To: <20090426140707.533370000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> the write_super method is used for
>
>  (1) writing back the superblock periodically from pdflush
>  (2) called just before ->sync_fs for data integerity syncs
>  (3) just before ->put_super
>
> We don't need (1) because we have our own peridoc writeout through xfssyncd,
> we don't need (2) because xfs_fs_sync_fs performs a proper synchronous
> superblock writeout after all other data and metadata has been written out,
> and we don't need (3) because we synchronously write the superblock in
> ->put_super once the filesystem is fully shut down.
>
> Also remove ->s_dirt tracking as it's only used to decide when too call
> ->write_super.
>
Just to double check, what about sync_filesystems():

                if (sb->s_root && (wait || sb->s_dirt))
                        sb->s_op->sync_fs(sb, wait);

if we lose s_dirt does that mean we are potentially doing one less ->sync_fs 
here when called with wait = 0, and is that ok?  (/me waves hands about
sync; sync; sync magic) :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
