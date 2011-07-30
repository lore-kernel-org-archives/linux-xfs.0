Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6UEPcUj138058 for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 09:25:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1712C15F7F08
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 07:26:00 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	w0tVs8hlPBTJLR3n for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2011 07:26:00 -0700 (PDT)
Date: Sat, 30 Jul 2011 10:25:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/4] xfstests: Changed test 062 to be generic for all
	filesystems
Message-ID: <20110730142530.GA31200@infradead.org>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
	<95dfa968c48d2bd1095876a6db3369672e76db5f.1311953979.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <95dfa968c48d2bd1095876a6db3369672e76db5f.1311953979.git.sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 29, 2011 at 06:06:58PM +0200, Stefan Behrens wrote:
> Changed the test 062 to be generic for all filesystems and to be
> executed for all filesystems.
> Remove output of mkfs since this is specific to mkfs.xfs and now
> filtered out.

The first three patches look good, but can you please merge them into
on.  And maybe make the subject description a bit less verbose, e.g.

xfstests: make more tests generic

Use _scratch_mkfs / _scratch_mkfs_sized instead of _scratch_mkfs_xfs
where possible. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
