Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 19D7F7F99
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 14:13:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 025CA304043
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:13:48 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id MTNbk7nikpdgRAGE for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 12:13:47 -0800 (PST)
Date: Tue, 12 Nov 2013 21:13:43 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfstests: stop special casing nfs and udf
Message-ID: <20131112201343.GA31763@quack.suse.cz>
References: <20131107204635.GA22954@infradead.org>
	<52827113.3080609@sandeen.net> <52827239.9060307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52827239.9060307@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 12-11-13 12:23:53, Eric Sandeen wrote:
> On 11/12/13, 12:18 PM, Eric Sandeen wrote:
> > On 11/7/13, 2:46 PM, Christoph Hellwig wrote:
> >> For historical reasons beyond my knowledge xfstests tries to abuse the
> >> scratch device as test device for nfs and udf.  Because not all test
> >> have inherited the right usage of the _setup_testdir and _cleanup_testdir
> >> helpers this leads to lots of unessecary test failures.
> >>
> >> Remove the special casing, which gets nfs down to a minimal number of
> >> failures.
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > 
> > Oof, that was a lot of cruft.  Were you able to run UDF tests with
> > these changes?  I wonder if Jan is using this for UDF?
> > 
> > (I don't have the UDF verifier that many(/all?) of the UDF tests
> > require).
  No, I don't run xfstests for udf since there are only minimal changes
to udf these days and the problems tend to be more in compatibility with
various udf formats (since udf has about four ways how to do each thing and
you can decide which way your implementation does it which gets hairy when
you have to read all these combinations). But it's an interesting idea to
try running xfstests on UDF. I actually have the verifier so I should be
able to make it run...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
