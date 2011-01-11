Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BLS66L113890 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 15:28:07 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABDA4FDCAB8
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 13:30:19 -0800 (PST)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id UPlB5xhSnn6Kfq7Y for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 13:30:19 -0800 (PST)
Date: Tue, 11 Jan 2011 16:30:07 -0500
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20110111213007.GF2917@thunk.org>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<20101109011222.GD2715@dastard> <20101109033038.GF3099@thunk.org>
	<20101109044242.GH2715@dastard> <20101109214147.GK3099@thunk.org>
	<20101109234049.GQ2715@dastard>
	<AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lawrence Greenfield <leg@google.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Jan 11, 2011 at 04:13:42PM -0500, Lawrence Greenfield wrote:
> > IOWs, all they want to do is avoid the unwritten extent conversion
> > overhead. Time has shown that a bad security/performance tradeoff
> > decision was made 13 years ago in XFS, so I see little reason to
> > repeat it for ext4 today....

I suspect things may have changed somewhat; both in terms of
requirements and nature of cluter file systems, and the performance of
various storage systems (including PCIe-attached flash devices).  

> I'd make use of FALLOC_FL_EXPOSE_OLD_DATA. It's not the CPU overhead
> of extent conversion. It's that extent conversion causes more metadata
> operations than what you'd have otherwise, which means systems that
> want to use O_DIRECT and make sure the data doesn't go away either
> have to write O_DIRECT|O_DSYNC or need to call fdatasync().
> 
> cluster file system implementor,

One possibility might be to make it an optional feature which is only
enabled via a mount option.  That way someone would have to explicit
ask for this feature two ways (via a new flag to fallocate) and a
mount option.

It might not make sense for XFS, but for people who are using ext4 as
the local storage file system back-end, and are doing all sorts of
things to get the best performance, including disabling the journal, I
suspect it really would make sense.  So it could always be an
optional-to-implement flag, that not all file systems should feel
obliged to implement.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
