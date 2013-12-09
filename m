Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EDB667F9D
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 17:30:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD866304059
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 15:30:15 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9sjaYTzRQkj8XVCD for <xfs@oss.sgi.com>;
	Mon, 09 Dec 2013 15:30:11 -0800 (PST)
Date: Tue, 10 Dec 2013 10:30:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131209233002.GV31386@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
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
To: Kees Cook <keescook@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Brian Foster <bfoster@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Gao feng <gaofeng@cn.fujitsu.com>, Dave Chinner <dchinner@redhat.com>

[CC the xfs list. Kees - I shouldn't have to remind you to do this. ]

On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
> Hi,
> 
> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
> capability check to free eofblocks ioctl") is a security fix that was
> never sent to -stable? From what I can see, it was introduced in 3.8
> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
> XFS_IOC_FREE_EOFBLOCKS ioctl").
> 
> I don't see this in the 3.8.y tree. Should it be added there and newer?

Well, it's not really a security problem at all, given that it only
affects speculative preallocation beyond EOF. i.e. it affects
filesystem metadata that does not yet index any user data.

Indeed, the kernel already does exactly what this ioctl does every 5
minutes without user intervention. i.e. it's simply a maintenance
task we need to execute periodically or on demand as a result of
other events (e.g. from a userspace daemon that is listen to quota
exhaustion messages).

So apart from allowing a user to burn some CPU with the ioctl doing
nothing but scanning, there's little in way of a security problem
being exposed on kernels prior to 3.12 here.

The reason for the cap check? Turning off this ioctl in containers
restricted by user name spaces. i.e. new functionality added to XFS
in 3.12 introduced curiously vague and difficult to explain new
inode access restrictions, so we took the "be safe by default" route
and only allowed the init namespace access to the ioctl....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
