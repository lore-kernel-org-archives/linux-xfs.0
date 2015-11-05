Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F40C97F4E
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 06:11:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E42568F8035
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 04:11:05 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id FoUCEhJQbzDzURNZ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Nov 2015 04:11:04 -0800 (PST)
Date: Thu, 5 Nov 2015 07:10:59 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH RFC] use WQ_MEM_RECLAIM for m_log_workqueue
Message-ID: <20151105121059.GJ5458@ret.masoncoding.com>
References: <20151104185103.GC5458@ret.masoncoding.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151104185103.GC5458@ret.masoncoding.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, Tejun Heo <htejun@fb.com>

On Wed, Nov 04, 2015 at 01:51:03PM -0500, Chris Mason wrote:
> I think we should be using WQ_MEM_RECLAIM to make sure this thread pool
> makes progress when we're not able to allocate new workers.

Thinking harder, it's probably best to just flag them all
WQ_MEM_RECLAIM.  This is what btrfs does, and it saves you from painful
discoveries about how different queues depend on each other.

Tejun did verify in the dump that progress on m_log_workqueue was stuck
waiting for more threads.

I'll start testing and send a v2.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
