Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 132F27F47
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 08:34:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E90F8304032
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 06:34:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 47b9HoufAGMzYbDA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 May 2015 06:34:47 -0700 (PDT)
Date: Mon, 18 May 2015 09:34:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfsprogs/mkfs: what's the relationship between max trans res and
	min log size
Message-ID: <20150518133439.GA43596@bfoster.bfoster>
References: <555987A2.3050604@foxmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <555987A2.3050604@foxmail.com>
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
To: Wang Sheng-Hui <shhuiw@foxmail.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs <xfs@oss.sgi.com>

On Mon, May 18, 2015 at 02:33:06PM +0800, Wang Sheng-Hui wrote:
> Hi guys,
> 
> 
> In maxtrres.c/max_trans_res, it calls xfs_log_calc_minimum_size to compute the
>               maximum transaction reservation
> 
> But for xfs_log_calc_minimum_size, it's used to calculate the
>               minimum valid log size
> 
> 
> The naming max/minimum seems confusing.
> 
> Why are they named in such way? What's the relationship between max trans res
> and minimun log size, (max trans res) <= (minimun log size)?
> 
> 
> Any explanations are welcomed!
> 

>From the comment in xfs_log_calc_minimum_size():

        /*
         * Two factors should be taken into account for calculating the minimum
         * log space.
         * 1) The fundamental limitation is that no single transaction can be
         *    larger than half size of the log.
         *
         *    From mkfs.xfs, this is considered by the XFS_MIN_LOG_FACTOR
         *    define, which is set to 3. That means we can definitely fit
         *    maximally sized 2 transactions in the log. We'll use this same
         *    value here.
	 ...
	 */

So the log must be at least the size of two single transactions (it
looks like the code is conservative and uses a factor of 3). This is a
limitation on the minimum allowable log size for the fs. Transactions
are of variable size, so to determine what that means in terms of actual
size we must calculate the maximum possible (i.e., worst case)
transaction size for the particular fs geometry and then use that to
calculate the minimum total log size.

Brian

> 
> Thanks,
> Sheng-Hui
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
