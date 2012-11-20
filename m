Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKAVtGx141303 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 04:31:55 -0600
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id SGMNrbFTXgNHvNcH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Nov 2012 02:34:04 -0800 (PST)
Received: by mail-pb0-f53.google.com with SMTP id jt11so4790599pbb.26
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 02:34:04 -0800 (PST)
Date: Tue, 20 Nov 2012 18:46:46 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/4][RFC] remove duplicated check from ext4, xfs, btrfs,
	and ocfs2
Message-ID: <20121120104646.GA3726@gmail.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
	<20121120101452.GA692@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120101452.GA692@infradead.org>
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
Cc: xfs@oss.sgi.com, yan@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Nov 20, 2012 at 05:14:53AM -0500, Christoph Hellwig wrote:
> On Tue, Nov 20, 2012 at 05:29:41PM +0800, Zheng Liu wrote:
> > Hi all,
> > 
> > This patch series tries to remove a sanity check in fallocate from specific
> > filesystems because vfs has already checked it.
> > 
> > I am not very familiar with why we need to do this duplicated check.  Please let
> > me know if I miss something.
> 
> Each filesystem driver checks to see if a flag that it doesn't support
> gets passed down.  This was done with the intention that we can add new
> flags to the VFS without having to update every filesystem.

Thanks for your explanation.

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
