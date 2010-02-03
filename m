Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13AteTc223873 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 04:55:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CA5813732FD
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 02:56:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9pF9Q0xBJySYqe0A for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 02:56:49 -0800 (PST)
Date: Wed, 3 Feb 2010 05:56:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] xfstests: filter selinux output in _acl_ls etc
Message-ID: <20100203105649.GB1047@infradead.org>
References: <4B61C1BC.4050800@sandeen.net> <4B626697.3080006@sandeen.net>
	<4B68B007.1020705@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B68B007.1020705@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 02, 2010 at 05:06:47PM -0600, Eric Sandeen wrote:
> When selinux is on, ls -l gives us a "." to indicate selinux
> attrs, which breaks some tests:
> 
>  === Test minimal ACE ===
>  Setup file
> --rwxrw-r-- id1 id2 file1
> +-rwxrw-r--. id1 id2 file1
> 
> so make an _ls_l helper to filter that out.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
