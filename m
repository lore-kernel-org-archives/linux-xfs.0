Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 592FA7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 14:22:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2833F8F8040
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 12:22:50 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id fy2P9sqzyNMeMUiY (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 12:22:48 -0700 (PDT)
Date: Thu, 24 Jul 2014 21:22:45 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
Message-ID: <20140724192245.GG1553@suse.cz>
References: <cover.1386778302.git.dsterba@suse.cz>
	<4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
	<20131212232443.GL31386@dastard>
	<9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
	<B58DEEA8-561A-4173-B9F5-528B73E06C6D@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <B58DEEA8-561A-4173-B9F5-528B73E06C6D@dilger.ca>
Reply-To: dsterba@suse.cz
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, Btrfs Developer List <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Thu, Jul 17, 2014 at 12:07:57AM -0600, Andreas Dilger wrote:
> any progress on this patch series?

I'm sorry I got distracted at the end of year and did not finish the
series.

> I never saw an updated version of this patch series after the last round of
> reviews, but it would be great to move it forward.  I have filefrag patches
> in my e2fsprogs tree waiting for an updated version of your patch.
> 
> I recall the main changes were:
> - add FIEMAP_EXTENT_PHYS_LENGTH flag to indicate if fe_phys_length was valid

fe_phys_length will be always valid, so other the flags are set only if it's
not equal to the logical length.

> - rename fe_length to fe_logi_length and #define fe_length fe_logi_length
> - always fill in fe_phys_length (= fe_logi_length for uncompressed files)
>   and set FIEMAP_EXTENT_PHYS_LENGTH whether the extent is compressed or not

This is my understanding and contradicts the first point.

> - add WARN_ONCE() in fiemap_fill_next_extent() as described below
>
> I don't know if there was any clear statement about whether there should be
> separate FIEMAP_EXTENT_PHYS_LENGTH and FIEMAP_EXTENT_DATA_COMPRESSED flags,
> or if the latter should be implicit?  Probably makes sense to have separate
> flags.  It should be fine to use:
>
> #define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010
> 
> since this flag was never used.

I've kept only FIEMAP_EXTENT_DATA_COMPRESSED, I don't see a need for
FIEMAP_EXTENT_PHYS_LENGTH and this would be yet another flag because the
FIEMAP_EXTENT_DATA_ENCODED is also implied.

I'll send V4, we can discuss the PHYS_LENGTH flag then.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
