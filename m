Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6CAAF7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:50:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1B75AC002
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 10:50:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id oM2yGY3bZb0MxXpp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 10:50:33 -0700 (PDT)
Date: Tue, 15 Apr 2014 10:50:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/4] xfs: initialize inode security on tmpfile creation
Message-ID: <20140415175033.GB26404@infradead.org>
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
	<1397578706-5385-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397578706-5385-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 12:18:24PM -0400, Brian Foster wrote:
> +	error = xfs_init_security(inode, dir, &dentry->d_name);
> +	if (unlikely(error)) {
> +		iput(inode);
> +		return -error;
> +	}
> +
>  	d_tmpfile(dentry, inode);
>  

I'd really love to hear from the LSM people who they plan to deal with
O_TMPFILE inodes.    But given that this seems to fix a real life bug
let's go with it for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
