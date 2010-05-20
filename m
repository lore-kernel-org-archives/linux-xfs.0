Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KHJ3xt217674 for <xfs@oss.sgi.com>; Thu, 20 May 2010 12:19:03 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33473141846C
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 10:21:22 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id OaVvmNO2lm1bNt1N for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 10:21:22 -0700 (PDT)
Date: Thu, 20 May 2010 19:21:15 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] Test basic quota enforcement
Message-ID: <20100520172114.GG3395@quack.suse.cz>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
	<1274276289-8839-4-git-send-email-jack@suse.cz>
	<20100520151130.GC27124@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20100520151130.GC27124@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4341500596184103416=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

--===============4341500596184103416==
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu 20-05-10 11:11:30, Christoph Hellwig wrote:
> The golden output contains "/local/test1/file5" which appaears
> to be in your test fs.  You need to do something like
> 
> 	sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
> 
> or
> 
> 	sed -e "s,$T“T_MNT,TEST_MNT,g"
> 
> to make the test portable.  This probably applies to the other tests
> as well.
  I have filter_scratch function for this in all tests. I just forgot to
filter output of touch(1) through it. It should be fixed now.
  BTW: What is the purpose of 'status' variable? I set it to 1 if I want
the test to fail because diff found differences between accounted and
real usage. Is this correct? Actually, diff will also print the differences
to stdout so setting status probably shouldn't be needed. So is it preferred
to set status to 1 or leave it 0?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR


--===============4341500596184103416==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4341500596184103416==--
