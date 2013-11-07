Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 790297FE9
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 02:22:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5DA2F304051
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 00:22:36 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id MvGsRgnYGzWUg4v7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 00:22:35 -0800 (PST)
Date: Thu, 7 Nov 2013 00:22:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstest failures
Message-ID: <20131107082234.GA30243@infradead.org>
References: <20131106105451.GA31283@infradead.org>
	<20131106194417.GF6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106194417.GF6188@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 06:44:17AM +1100, Dave Chinner wrote:
> > 	xfs_Repair now aborts due to a verifier failure in
> > 	xfs_trans_read_buf.  I think this is a real bug introduced
> > 	in xfs_repair when new changes were brought in.  Output diff
> > 	attached.
> 
> It's an unexpected abort from the libxfs code from verifier detected
> corruption. There's a few of these, and I'm slowly working my way
> through them (e.g. the last patch in the lastest series).

Well, we realsly should have fixes this as part of the merge.  Merging
code that introduces regressions for the default config should not be
acceptable.

> > xfs/187
> > 
> > 	Echoes "Need to update test 187 so that initial subtests do not
> > 	use features2".  Why do we make this a fail rather than notrun?
> 
> The problem is that the 32 bit project ID bit is being set by
> default now, resulting in the sb_features2 field having a value set
> in it.
> 
> mkfs now needs to be explicit to use 16 bit project IDs, and a
> modified form of this patch needs to be added as well:
> 
> http://oss.sgi.com/archives/xfs/2013-06/msg00219.html
> 
> I need to update that patch and resend it.  I get this when I run
> with a current mkfs with CRCs enabled:
> 
> xfs/187 0s ... [not run] attr v1 not supported

But it still breaks the v4 config.  I have to say enabling the 32bit
projids on v4 filesystems by default as a side effect of the crc
changes sound worse and worse.  The people who needed it already do on
v4 manually, and others will get it with the v5 rollout.

But if we want to stick to v4 + 32bit projid we should at least make
sure it does not break the tests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
