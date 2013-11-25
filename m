Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC9E97F51
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 10:12:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BB4EB8F8078
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 08:12:18 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QHrMiys2FuSBJFfd (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 08:12:17 -0800 (PST)
Date: Mon, 25 Nov 2013 08:12:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstests: add generic/321 to test fsync() on
	directories V2
Message-ID: <20131125161216.GA5085@infradead.org>
References: <1384538464-7384-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384538464-7384-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 15, 2013 at 01:01:03PM -0500, Josef Bacik wrote:
> Btrfs had some issues with fsync()'ing directories and fsync()'ing after
> renames.  These three new tests cover the 3 different issues we were seeing.
> This breaks out the dmflakey stuff into a common helper to be shared between
> generic/311 and generic/321. Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

This doesn't seem to actually create the common/dmflakey file.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
