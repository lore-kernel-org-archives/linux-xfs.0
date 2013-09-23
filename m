Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61B7B7F37
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 07:26:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E601EAC003
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 05:26:27 -0700 (PDT)
Date: Mon, 23 Sep 2013 05:26:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs: update version for 3.2.0-alpha1
Message-ID: <20130923122623.GA2199@infradead.org>
References: <20130916205637.GD1935@sgi.com>
 <20130916223855.GF19103@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130916223855.GF19103@dastard>
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
Cc: sandeen@sandeen.net, Ben Myers <bpm@sgi.com>, rjohnston@sgi.com, xfs@oss.sgi.com

On Tue, Sep 17, 2013 at 08:38:55AM +1000, Dave Chinner wrote:
> On Mon, Sep 16, 2013 at 03:56:37PM -0500, Ben Myers wrote:
> > xfsprogs: update version for 3.2.0-alpha1
> 
> I'd say this is a major feature and infrastructure
> update across the entire xfsprogs package, and in that case a
> PKG_MAJOR bump is warranted, not PKG_MINOR.
> 
> i.e. We're shooting for a 4.0 release, not 3.2...

I tend to disagree with the 4.0 bump.

2.0 was when the new xattr ABI was introduced, and 3.0 was when we
pulled fsr over from xfsdump to xfsprogs as well as drastically reducing
the amount of installed headers.

While the v5 support is a major internal change I think 3.2 would fit
better for this.

I'd also be tempted to just cut 3.2.0 instead of an alpha version - just
keep the v5 support experimental, maybe under a configure option.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
