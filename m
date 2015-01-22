Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01D567F63
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 14:20:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4852304051
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 12:20:36 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id FcKj9Dlnid9twWoT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 12:20:35 -0800 (PST)
Date: Thu, 22 Jan 2015 21:20:34 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: a simple and scalable pNFS block layout server V2
Message-ID: <20150122202033.GA14817@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<20150122200618.GI898@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150122200618.GI898@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jan 22, 2015 at 03:06:18PM -0500, J. Bruce Fields wrote:
> By the way, Jeff, do you consider the lock changes are ready?  Would you
> mind if I pulled or cherry-picked them into the nfsd tree just to
> simplify merging this stuff for 3.20?  (Assuming it's going to be
> ready.)

I did the rebase because he mentioned he wanted to get it into 3.20.

Note that the conflicts were fairly trivial, so it's something we
could just ignore and let Linus handle the merge in the worst case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
