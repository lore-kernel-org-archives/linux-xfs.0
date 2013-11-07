Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93F9F7FDF
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 07:27:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2161AAC00B
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 05:27:41 -0800 (PST)
Date: Thu, 7 Nov 2013 05:27:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstest failures
Message-ID: <20131107132739.GA16608@infradead.org>
References: <20131106105451.GA31283@infradead.org>
	<20131106161825.GU1935@sgi.com> <527A887F.2030807@sandeen.net>
	<20131107081710.GC25157@infradead.org>
	<527B948C.9060905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <527B948C.9060905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 07:24:28AM -0600, Eric Sandeen wrote:
> On 11/7/13, 2:17 AM, Christoph Hellwig wrote:
> > On Wed, Nov 06, 2013 at 12:20:47PM -0600, Eric Sandeen wrote:
> >> that's right, it's a known bug w/ a testcase but no fix yet.
> >>
> >> I looked a bit, but ugh, xfsdump.
> > 
> > Maybe it's time you come up with an xfail mechanism at least?
> 
> What's the proposal there, a "fail" group for things known to still
> fail everywhere?
> 
> so i.e. ./check -x fail ?  I can easily send a patch for that if
> that's what folks want.

A mechnism to annotate a test as xfail, so that check would output them
at the end ala:

Expected failures:  common/263
Unexpected successes: reiser4/001

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
