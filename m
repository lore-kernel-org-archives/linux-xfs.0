Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1NAsM5P098220 for <xfs@oss.sgi.com>; Thu, 23 Feb 2012 04:54:22 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id PjTbh3RaMvQceOP9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Feb 2012 02:54:20 -0800 (PST)
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id AA70490B96
	for <xfs@oss.sgi.com>; Thu, 23 Feb 2012 11:54:19 +0100 (CET)
Date: Thu, 23 Feb 2012 11:54:18 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: xlog_space_left: head behind tail
Message-ID: <20120223105418.GB24638@quack.suse.cz>
References: <20120223104853.GA24638@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120223104853.GA24638@quack.suse.cz>
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
To: xfs@oss.sgi.com

On Thu 23-02-12 11:48:53, Jan Kara wrote:
>   Hello,
> 
>   when I run:
> while true; do ~/tests/xfstests-dev/ltp/fsstress -d /mnt -n 10000 -p 4; done
> 
> and in parallel
> 
> while true; do ./fsfreeze /mnt; sync; ./fsfreeze -u /mnt; sleep 3; done
> 
> where fsfreeze is a small utility freezing and unfreezing filesystem. I get
> warnings like:
  BTW, the first message is:
[ 1626.278347] XFS (vdb1): xlog_space_left: head behind tail
[ 1626.278349]   tail_cycle = 7, tail_bytes = 12907008
[ 1626.278351]   GH   cycle = 7, GH   bytes = 12907000

								Honza

> [ 2029.103193] XFS (vdb1): xlog_space_left: head behind tail
> [ 2029.103195]   tail_cycle = 10, tail_bytes = 6036480
> [ 2029.103197]   GH   cycle = 10, GH   bytes = 6035728
> [ 2029.103218] XFS (vdb1): xlog_space_left: head behind tail
> [ 2029.103219]   tail_cycle = 10, tail_bytes = 6036480
> [ 2029.103220]   GH   cycle = 10, GH   bytes = 6035728
> [ 2033.269796] XFS (vdb1): xlog_space_left: head behind tail
> [ 2033.269800]   tail_cycle = 10, tail_bytes = 6400512
> [ 2033.269803]   GH   cycle = 10, GH   bytes = 6399752
> [ 2033.269830] XFS (vdb1): xlog_space_left: head behind tail
> [ 2033.269835]   tail_cycle = 10, tail_bytes = 6400512
> [ 2033.269838]   GH   cycle = 10, GH   bytes = 6399752
> [ 2033.269847] XFS (vdb1): xlog_space_left: head behind tail
> [ 2033.269850]   tail_cycle = 10, tail_bytes = 6400512
> [ 2033.269852]   GH   cycle = 10, GH   bytes = 6399752
> [ 2033.269892] XFS (vdb1): xlog_space_left: head behind tail
> [ 2033.269894]   tail_cycle = 10, tail_bytes = 6400512
> [ 2033.269896]   GH   cycle = 10, GH   bytes = 6399752
> [ 2033.269915] XFS (vdb1): xlog_space_left: head behind tail
> [ 2033.269918]   tail_cycle = 10, tail_bytes = 6400512
> [ 2033.269920]   GH   cycle = 10, GH   bytes = 6399752
> 
> They usually start to appear like 20 minutes after starting the tests and
> when they start to appear they happen every couple of seconds (as you can
> see from the timestamps). Is it a real problem or just annoyance?
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
