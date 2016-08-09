Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 855A57CA6
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 03:28:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4624D304039
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 01:28:00 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gLaikkWDCg9sjo2s (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 01:27:58 -0700 (PDT)
Date: Tue, 9 Aug 2016 01:27:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: Propagate dentry down to inode_change_ok()
Message-ID: <20160809082756.GA11657@infradead.org>
References: <1470223689-17783-1-git-send-email-jack@suse.cz>
	<1470223689-17783-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470223689-17783-2-git-send-email-jack@suse.cz>
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

> +static int
> +xfs_vn_change_ok(
> +	struct dentry	*dentry,
> +	struct iattr	*iattr)

Please don't use the _vn prefix for something that's not an
actual inode operation (and we should do a mess rename to 
_iop one day as well.)

> +int
> +xfs_vn_setattr_nonsize(
> +	struct dentry		*dentry,
> +	struct iattr		*iattr)

Same here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
