Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DE4B7CA6
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 04:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2BFE6304039
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 02:35:37 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 201MH3stRpSCSvJf (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 02:35:34 -0700 (PDT)
Date: Tue, 9 Aug 2016 02:35:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: Propagate dentry down to inode_change_ok()
Message-ID: <20160809093531.GA3937@infradead.org>
References: <1470223689-17783-1-git-send-email-jack@suse.cz>
	<1470223689-17783-2-git-send-email-jack@suse.cz>
	<20160809082756.GA11657@infradead.org>
	<20160809093246.GB5107@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809093246.GB5107@quack2.suse.cz>
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
Cc: "Yan, Zheng" <zyan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org

On Tue, Aug 09, 2016 at 11:32:46AM +0200, Jan Kara wrote:
> So do you suggest xfs_iop_change_ok and xfs_iop_setattr_nonsize? I don't
> really care, I just remember Dave had some ideas how names should be
> consistent and this naming was his idea...

Nah, just skip the prefix entirely, and maybe also already adopt to
the new setattr_prepare naming.  But if Dave already had an opinions
let's just keep it as-is and sort the naming out later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
