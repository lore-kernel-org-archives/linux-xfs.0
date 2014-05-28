Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C982F7F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 00:32:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B46D930404E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 22:32:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id m3JwzvEvCCqDWNY9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 22:32:41 -0700 (PDT)
Date: Tue, 27 May 2014 22:32:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: xfs_copy: fix data corruption of target
Message-ID: <20140528053241.GC3816@infradead.org>
References: <1401247687-6444-1-git-send-email-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401247687-6444-1-git-send-email-junxiao.bi@oracle.com>
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
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: hch@infradead.org, joe.jin@oracle.com, xfs@oss.sgi.com

On Wed, May 28, 2014 at 11:28:07AM +0800, Junxiao Bi wrote:
> The unit of XFS_AGFL_DADDR(mp) is "basic block" whose size is "BBSIZE"
> (512 bytes), so when "source_sectorsize" is not 512, it will cause the
> target a corrupted filesystem.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Looks good.  Any chance you could create a testcase for this as well?


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
