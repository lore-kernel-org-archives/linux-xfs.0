Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DC807F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 08:45:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E4DEAC001
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 06:45:41 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id qG3szGro0F77ZLqC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jan 2013 06:45:39 -0800 (PST)
Date: Wed, 30 Jan 2013 14:45:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/4 v2] Fix possible use after free with AIO
Message-ID: <20130130144535.GK4503@ZenIV.linux.org.uk>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359502081-20240-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Wed, Jan 30, 2013 at 12:27:57AM +0100, Jan Kara wrote:
> 
>   Hi,
> 
>   since nobody seem to have picked up any of the patches (at least
> nobody told me so), I've added acks I received to the patches and I'm
> sending them to Al for merging. Al, can you please merge these? Thanks.

VFS part (4/4) picked; IMO at least ext* and xfs should go through the
filesystem trees.  If ocfs2 folks don't pick fs/ocfs2 part, I'll grab
it as well - not sure how active their tree is these days...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
