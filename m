Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E4D27F53
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 12:01:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CB788F804C
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 10:01:09 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vrXixPsI33tdgqzc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 10:01:08 -0700 (PDT)
Date: Wed, 24 Sep 2014 19:01:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140924170105.GE27000@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
	<20140924162634.GA16886@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140924162634.GA16886@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: adilger@dilger.ca, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, xfs@oss.sgi.com, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org

On Wed 24-09-14 09:26:34, Christoph Hellwig wrote:
> On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
> > On Wed 24-09-14 22:04:30, Li Xi wrote:
> > > This patch adds ioctl interface for setting/getting project of ext4.
> >   The patch looks good to me. I was just wondering whether it won't be
> > useful to add an ioctl() which isn't ext4 specific. We could just extend
> > ->setattr() to allow setting of project ID (most filesystems would just
> > return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
> > ->setattr from the generic ioctl. That way userspace won't have to care
> > about filesystem type when setting project ID... What do others think?
> 
> Absolutely.  In general I also wonder why this patch doesn't implement
> the full XFS API.  Maybe there is a reason it was considered and
> rejected, but it would be helpful to document why.
  Do you mean full get/setfsxattr API? That basically contains project ID,
flags (those that are currently get/set with FS_IOC_GETFLAGS/SETFLAGS), and
extent size hint right? That seems workable and it would also make setting
of PROJINHERIT flag fs agnostic. Only we would have to create some generic
flags namespace and merge into that ext4 flags and have a translation
function for the old ext4 flags. Also I'm afraid we may quickly run out of
32 available flags in xflags so we'd need to extend that. But all this
seems to be doable.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
