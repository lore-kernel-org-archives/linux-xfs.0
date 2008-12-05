Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB53xAxd031855 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 21:59:10 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2849B16B0F0F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 19:59:09 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id hm7MI54X8BItTJHS for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 19:59:09 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 73F6DAC6272
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 21:59:09 -0600 (CST)
Message-ID: <4938A70D.8090502@sandeen.net>
Date: Thu, 04 Dec 2008 21:59:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - set b_error from bio error in xfs_buf_bio_end_io
References: <4938A4C1.9010401@sandeen.net>
In-Reply-To: <4938A4C1.9010401@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Tim mentioned something about the code in xfs_buf_iodone_work()
> which detects barrier failures post-mount, as added in commit
> 0bfefc46dc028df60120acdb92062169c9328769,
> [XFS] Barriers need to be dynamically checked and switched off
> 
>         if ((bp->b_error == EOPNOTSUPP) &&
>             (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
>                 XB_TRACE(bp, "ordered_retry", bp->b_iodone);
>                 bp->b_flags &= ~XBF_ORDERED;
>                 bp->b_flags |= _XFS_BARRIER_FAILED;
> ...
> 
> but it seems that nothing ever sets EOPNOTSUPP on b_error, so
> this path would never be hit.
> 
> I think that we need to do something like below, totally untested,
> to ensure that bio errors get set on b_error, if we're looking
> for them by name, no?

oh, heh, Tim had mentioned that Lachlan suggested this same thing on irc
yesterday, but somehow I had forgotten or totally missed that... didn't
mean to usurp Lachlan :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
