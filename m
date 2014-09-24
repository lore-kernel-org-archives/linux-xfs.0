Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 345CB7F51
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 11:26:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0478C8F8035
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 09:26:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id fBOcYX8odNweNGIt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 09:26:38 -0700 (PDT)
Date: Wed, 24 Sep 2014 09:26:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140924162634.GA16886@infradead.org>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140924162507.GC27000@quack.suse.cz>
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
Cc: adilger@dilger.ca, tytso@mit.edu, linux-api@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
> On Wed 24-09-14 22:04:30, Li Xi wrote:
> > This patch adds ioctl interface for setting/getting project of ext4.
>   The patch looks good to me. I was just wondering whether it won't be
> useful to add an ioctl() which isn't ext4 specific. We could just extend
> ->setattr() to allow setting of project ID (most filesystems would just
> return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
> ->setattr from the generic ioctl. That way userspace won't have to care
> about filesystem type when setting project ID... What do others think?

Absolutely.  In general I also wonder why this patch doesn't implement
the full XFS API.  Maybe there is a reason it was considered and
rejected, but it would be helpful to document why.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
