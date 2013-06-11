Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AEBA229DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 16:47:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7202E304043
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:47:29 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Vs82ZEmsFtsBjCaj for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 14:47:27 -0700 (PDT)
Date: Wed, 12 Jun 2013 07:47:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS
Message-ID: <20130611214725.GO29338@dastard>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75E42.4070105@sandeen.net>
	<CAO9HMNFj4Y8bEg3xZct0PTk_4wmGCtuNgFf4m4TR-PnZR_BrNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAO9HMNFj4Y8bEg3xZct0PTk_4wmGCtuNgFf4m4TR-PnZR_BrNQ@mail.gmail.com>
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
To: Steve Bergman <sbergman27@gmail.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Jun 11, 2013 at 02:17:16PM -0500, Steve Bergman wrote:
> Now about ext3 behavior. (Sorry, I know this is an XFS list, but I've
> been dying to have this clarified. And this does kind of relate to
> XFS.) Not only does data get flushed more frequently. But it gets
> careful treatment. It gets written out immediately before the
> metadata.

That's not careful treatment, that's just ordering. XFS has "careful
treatment", too, but it orders data and metadata differently.

XFS doesn't actually update the inode size until after
the data is written i.e. the size is still zero until the data is
written. That's how XFS orders data vs metadata updates - metadata
that is oly valid after data IO completes is not modified until
after the data IO completes...

Hence if you create a file, write some data and then crash before
the data is written, you'll get the create replayed but nothing else.
i.e. a zero length file. Often it is just the inode size transaction
that is missing from the log - the data is actually on disk and *can
be recovered* if you know what you are doing...

IOWs, the thing that causes people to complain about XFS and zero
length files is that XFS leaves *observable evidence* of data loss
behind, while ext3 and ext4 don't. Hence when people switch to XFS
they actually notice (maybe for the first time!) that running their
laptop battery dead leads to data loss and that their applications
are not behaving safely. They then shoot the messenger (i.e XFS)
for losing data as ext3/ext4 don't "lose data" as they don't leave
any observable evidence of partial file states...

Filesystems behave differently, but those observable differences in
behaviour don't mean one filesystem loses more data than another.
Some filesystems just makes it easier to find evidence of such data
loss and hence make it easier to recover from, not to mention make
it obvious which applications write data unsafely and hence
shouldn't be trusted....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
