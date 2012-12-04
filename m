Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB4L6ApU057760 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 15:06:10 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id OpHl4xT4lrlOvqPU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Dec 2012 03:56:29 -0800 (PST)
Message-ID: <50BDE4DA.1080103@oracle.com>
Date: Tue, 04 Dec 2012 19:56:10 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/15] xfs: Add a new transaction for changing ag state
References: <50A5E0E7.7010002@oracle.com> <20121203012453.GF29399@dastard>
	<50BC1458.2000609@oracle.com> <20121203212809.GZ32450@dastard>
In-Reply-To: <20121203212809.GZ32450@dastard>
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

On 12/04/2012 05:28 AM, Dave Chinner wrote:
> On Mon, Dec 03, 2012 at 10:54:16AM +0800, Jeff Liu wrote:
>> On 12/03/2012 09:24 AM, Dave Chinner wrote:
>>> As such I'd like to see this sort of thing encoded in a macro or
>>> inline function so the above code becomes something like:
>>>
>>> 	return mp->m_sb.sb_sectsize + xfs_buf_log_overhead(mp);
>>>
>>>
>>> and
>>>
>>> /*
>>>  * A buffer has a format structure overhead in the log in addition
>>>  * to the data, so we need to take this into account when reserving
>>>  * space in a transaction for a buffer. Round the space required up
>>>  * to a multiple of 128 bytes so that we don't change the historical
>>>  * reservation that has ben used for this overhead.
>>>  */
>>> static inline int
>>> xfs_buf_log_overhead()
>>> {
>>> 	return round_up(sizeof(struct xlog_op_header) +
>>> 			sizeof(struct xfs_buf_log_format), 128);
>>> }
>> Thanks for your teaching!
>>
>> We hard-coded '128' in almost all of those transaction reservations,
>> is it time to get rid of it according to your comments above?
>>
>> I'd like to do it if you have no time to deal with such trivial things. 
> 
> Yes please!
> 
> It's been on my "clean-ups for a rainy day" list for a long time,
> but I've never managed to get around to it. So if you want to do
> this, it would make me very happy :)
Just done the changes, I will continue to run a comprehensive testing
tomorrow before posting those patches. :)

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
