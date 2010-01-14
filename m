Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EN7dw4045529 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 17:07:39 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH V2] XFS: Don't wake xfsbufd when idle
Date: Thu, 14 Jan 2010 17:08:33 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6976@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100114224507.GZ17483@discord.disaster>
From: "Alex Elder" <aelder@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Thu, Jan 14, 2010 at 10:51:25AM -0600, Alex Elder wrote:
>> Dave Chinner wrote:
>>> The xfsbufd wakes every xfsbufd_centisecs (once per second by
>>> default) for each filesystem even when the filesystem is idle.
>>> If the xfsbufd has nothing to do, put it into a long term sleep
>>> and only wake it up when there is work pending (i.e. dirty
>>> buffers to flush soon). This will make laptop power misers happy.
>> 
>> Patch generally looks good but I have a question, below.
> 
>>>  	do {
>>> +		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
>>> +		long	tout = age;
>> 
>> Why do you switch from using xfs_buf_timer_centisecs to
>> using xfs_buf_age_centisecs for the timeout (in the non-empty
>> delwrite queue case)?
> 
> Because it's a bug? It should be xfs_buf_timer_centisecs
> here. Good catch, Alex. :)
> 
> Updated patch below
> 
> Cheers,
> 
> Dave.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
