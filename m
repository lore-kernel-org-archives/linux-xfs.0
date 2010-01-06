Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06GrbVO095545 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 10:53:37 -0600
Date: Wed, 6 Jan 2010 11:54:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix timestamp handling in xfs_setattr
Message-ID: <20100106165427.GD25393@infradead.org>
References: <20091223160913.GA13039@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A6913@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6913@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jan 05, 2010 at 07:02:02PM -0600, Alex Elder wrote:
> This looks good to me, although I acknowledge I haven't worked through
> it 100%.  Another reviewer would be good.  But even better, I really
> want to see the gnulib timestamp unit tests into xfstests to verify
> the behavior either way (which you indicated you'd work on...).  In
> fact, if you've made any headway on it I'd like to run the tests against
> this patch before committing it.

I already have the original testcase wired up for xfstests, I just need
to send out the patch after fixing some more bits.  I haven't looked
at the whole gnulib timestamp tests yet.  Note that we'd need to look
for an older GPLv2 version to not create even more licencing mess.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
