Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0DA27CB0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 03:28:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 340B7AC002
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 01:28:32 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id XSM179W4BpaBMhSy (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 01:28:30 -0700 (PDT)
Date: Tue, 9 Aug 2016 01:28:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] fs: Give dentry to inode_change_ok() instead of inode
Message-ID: <20160809082828.GB11657@infradead.org>
References: <1470223689-17783-1-git-send-email-jack@suse.cz>
	<1470223689-17783-5-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470223689-17783-5-git-send-email-jack@suse.cz>
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
Cc: Miklos Szeredi <miklos@szeredi.hu>, xfs@oss.sgi.com, "Yan,
	Zheng" <zyan@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org

On Wed, Aug 03, 2016 at 01:28:08PM +0200, Jan Kara wrote:
> inode_change_ok() will be resposible for clearing capabilities and IMA
> extended attributes and as such will need dentry. Give it as an argument
> to inode_change_ok() instead of an inode. Also rename inode_change_ok()
> to setattr_prepare() to better relect that it does also some
> modifications in addition to checks.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
