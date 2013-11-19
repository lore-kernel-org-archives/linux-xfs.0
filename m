Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E80057F50
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 06:16:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B972E8F8054
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 04:16:03 -0800 (PST)
Received: from mail-pa0-f48.google.com (mail-pa0-f48.google.com
	[209.85.220.48]) by cuda.sgi.com with ESMTP id g1ht9WNnBkLQa7NB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Nov 2013 04:16:02 -0800 (PST)
Received: by mail-pa0-f48.google.com with SMTP id rd3so999334pab.35
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 04:16:02 -0800 (PST)
Date: Tue, 19 Nov 2013 20:18:43 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
	writes
Message-ID: <20131119121843.GA5339@gmail.com>
References: <20131119095302.GA4534@gmail.com>
	<20131119102235.GA5010@infradead.org>
	<20131119104508.GA4630@gmail.com>
	<20131119110147.GA3323@infradead.org>
	<20131119111947.GA4782@gmail.com>
	<20131119111826.GA20485@infradead.org>
	<20131119115122.GC4782@gmail.com> <20131119120929.GO11434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131119120929.GO11434@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 19, 2013 at 11:09:29PM +1100, Dave Chinner wrote:
> On Tue, Nov 19, 2013 at 07:51:22PM +0800, Zheng Liu wrote:
> > On Tue, Nov 19, 2013 at 03:18:26AM -0800, Christoph Hellwig wrote:
> > > On Tue, Nov 19, 2013 at 07:19:47PM +0800, Zheng Liu wrote:
> > > > Yes, I know that XFS has a shared/exclusive lock.  I guess that is why
> > > > it can pass the test.  But another question is why xfs fails when we do
> > > > some append dio writes with doing buffered read.
> > > 
> > > Can you provide a test case for that issue?
> > 
> > Simple.  Reader just need to open this file without O_DIRECT flag.  I
> > paste the full code snippet below.  Please take care of this line:
> > 	readfd = open(argv[1], /*O_DIRECT|*/O_RDONLY, S_IRWXU);
> > 
> > The result of this program on my own sand box looks like below:
> >         encounter an error: offset 0
> ....
> > 		if (ret >= 0) {
> > 			for (j = 0; j < ret; j++) {
> > 				if (rbuf[i] != 'a') {
> > 					fprintf(stderr, "encounter an error: offset %ld\n",
> > 						i);
> > 					goto err;
> 
> Should be checking rbuf[j], perhaps?

Oops, it's my fault.  Yes. it should check rbuf[j].

Thanks,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
