Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4223E7F59
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 03:39:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D7E9304070
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 01:39:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id d2jMabPj8RGJqQnX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 01:39:46 -0800 (PST)
Date: Tue, 3 Dec 2013 01:39:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: fix iversion handling
Message-ID: <20131203093944.GA4906@infradead.org>
References: <20131119151707.GA13412@infradead.org>
	<20131202173636.GA17724@infradead.org>
	<8E57B1B6-E650-4A1A-AF78-0A9C9593A3E3@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8E57B1B6-E650-4A1A-AF78-0A9C9593A3E3@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Dec 02, 2013 at 03:05:07PM -0700, Andreas Dilger wrote:
> >> 	 */
> >> -	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME))))
> >> -		inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
> >> +	if (newsize != oldsize) {
> >> +		inode_inc_iversion(inode);
> 
> Should this be conditional on IS_I_VERSION(inode)?

btrfs sets MS_I_VERSION unconditionally.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
