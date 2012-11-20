Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKACol2138276 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 04:12:50 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HjG5oGzXDHcTMuUo (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 02:14:58 -0800 (PST)
Date: Tue, 20 Nov 2012 05:14:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4][RFC] remove duplicated check from ext4, xfs, btrfs,
	and ocfs2
Message-ID: <20121120101452.GA692@infradead.org>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: xfs@oss.sgi.com, yan@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Nov 20, 2012 at 05:29:41PM +0800, Zheng Liu wrote:
> Hi all,
> 
> This patch series tries to remove a sanity check in fallocate from specific
> filesystems because vfs has already checked it.
> 
> I am not very familiar with why we need to do this duplicated check.  Please let
> me know if I miss something.

Each filesystem driver checks to see if a flag that it doesn't support
gets passed down.  This was done with the intention that we can add new
flags to the VFS without having to update every filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
