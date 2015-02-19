Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5AEDC7F6C
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 16:35:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE257AC003
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 14:35:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id daEkneBv7CnBFRxc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 14:35:17 -0800 (PST)
Message-ID: <54E66520.7000102@redhat.com>
Date: Thu, 19 Feb 2015 17:35:12 -0500
From: Don Dutile <ddutile@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] fs: xfs: Fix xfs_trans_read_buf event tracing
References: <7fb3278485ca5d8b48cd1ba980be6cc11dafc11b.1424352124.git.panand@redhat.com>
	<20150219172028.GC2291@laptop.bfoster>
	<20150219213746.GV12722@dastard>
In-Reply-To: <20150219213746.GV12722@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: Pratyush Anand <panand@redhat.com>, jbastian@redhat.com, xfs@oss.sgi.com

On 02/19/2015 04:37 PM, Dave Chinner wrote:
> On Thu, Feb 19, 2015 at 12:20:28PM -0500, Brian Foster wrote:
>> On Thu, Feb 19, 2015 at 06:54:33PM +0530, Pratyush Anand wrote:
>>> My root file system is xfs. As soon as I enable event for
>>> xfs_trans_read_buf `echo xfs:xfs_trans_read_buf >>
>>> /sys/kernel/debug/tracing/set_event`, I see a kernel panic.
>>>
>>> A little bit of debugging shows that bp->b_fspriv is NULL many a time
>>> when trace_xfs_trans_read_buf(bp->b_fspriv) is called.
>>>
>>> I do not have any idea about xfs filesystem. So, I am not sure, if it
>>> is expected to have bp->b_fspriv = NULL at this location.
>>>
>>> This patch fixes the issue, until we have a better fix.
>>>
>>> Signed-off-by: Pratyush Anand <panand@redhat.com>
>>> ---
>>
>> A fix for this has been posted here:
>>
>> http://oss.sgi.com/archives/xfs/2015-02/msg00101.html
>
> It's already in the 3.20-rc0 kernel, and it was marked as a stable
> patch so should be fixed in the next 3.19 stable kernel.
>
We (RHELSA) are not tracking 3.19 stable; just rebased to 3.19-final (from -rc5).
But, you make me think we *should* track 3.19 stable now (our Beta kernel base).

> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
