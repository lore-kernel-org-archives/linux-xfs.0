Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4ED247F63
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 07:05:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3EBCE8F806F
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:05:08 -0800 (PST)
Date: Fri, 13 Dec 2013 05:04:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: return ENOSPC when trying to set more ACLs than
	XFS_ACL_MAX_ENTRIES
Message-ID: <20131213130432.GB22594@infradead.org>
References: <52921D12.7040104@oracle.com> <5292C557.9020008@sandeen.net>
	<5292D8AB.5080003@oracle.com> <20131211193622.GG1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211193622.GG1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Dec 11, 2013 at 01:36:22PM -0600, Ben Myers wrote:
> > > (I guess looking at ext4, it uses ENOSPC for some similar constraints,
> > > so maybe three is precedent for this)
> > Btrfs also uses ENOSPC, but JFS would return something like "Argument list too long"
> > in this case.

I think ENOSPC is a really bad idea in this case, but I also think we
should make sure Linux filesystems behave unfiformly.

Jeff, can you write a summary of the errors returned by all common
filesystems and post it to -fsdevel for comment?  We should have a
common error for this, and I'd be a happier man if it weren't ENOSPC,
but that's secondary.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
