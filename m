Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F0037FF9
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 07:03:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2CA4304053
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:03:48 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id iPIY87Wcw8F2KFfZ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 05:03:47 -0700 (PDT)
Date: Fri, 26 Sep 2014 08:01:28 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140926120128.GA21376@thunk.org>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
	<20140924162634.GA16886@infradead.org>
	<20140924170105.GE27000@quack.suse.cz>
	<20140925075912.GG4758@dastard>
	<20140925135213.GB15352@quack.suse.cz>
	<20140925224225.GJ4945@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925224225.GJ4945@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: adilger@dilger.ca, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Sep 26, 2014 at 08:42:25AM +1000, Dave Chinner wrote:
> Look, I have no problems with extending the existing quota
> interfaces to support project quotas, but that should be a
> *secondary* improvement as userspace tools are updated. The
> primary goal needs to be "works identically to XFS" and so it needs
> to implement the interfaces that are currently used for management
> so that we can actually test that it does work identically.

I think we're getting a bit too hung up on which is the "primary" and
which is the "secondary" interfaces.  The reality is that we should
make both interfaces work.  An example of this is how we handle the
xfs-specific ioctls that are also exposed via the fallocate(2) system
call.

It's not particularly important to me which is the "primary" interface
just because it's been around for 10 years.  Which should implement
*both* so that users are used to using xfs_io(8) or fallocate(1) can
do what they want.

Similarly, if some users are more used to the quotatools interface
(which has been around for quite a long time, BTW, if we're trying to
count primacy by years of availability to Linux users), and some users
that are used to using xfs_quota, both should work.

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
