Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAHHtcZb062286 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 11:55:38 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 55F5A8F80BB
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 09:57:09 -0800 (PST)
Message-ID: <4CE41775.6080509@sgi.com>
Date: Wed, 17 Nov 2010 11:57:09 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/9] xfsrestore: mmap dirent names for faster lookups
References: <20101116150502.179825893@sgi.com>
	<20101116150704.454578811@sgi.com>
	<20101117093402.GG17317@infradead.org>
In-Reply-To: <20101117093402.GG17317@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/17/2010 03:34 AM, Christoph Hellwig wrote:
> On Tue, Nov 16, 2010 at 09:05:06AM -0600, wkendall@sgi.com wrote:
>> Pathname resolution in xfsrestore is about 4x faster if the file
>> containing dirent names ("namreg") is memory mapped.  If xfsrestore is
>> unable to map the file (e.g., due to virtual memory constraints)
>> fallback to the existing seek-and-read approach.
>>
>> The file is mapped after all directory entries have been written to
>> the "namreg" file. If the caller tries to add additional entries after
>> the file has been mapped, it will be unmapped and restore will resort
>> back to seek-and-read lookups.
>>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>>
>> Reviewed-by: Alex Elder<aelder@sgi.com>
>
> Generally looks good to me, but I really hate how namreg_map/unmap
> are hidden under namreg_add/flush.  As a start instead of adding the
> done_adding argument we can easily move the explicit map to the one
> caller wanting it, similarly namreg_unmap could be moved to namreg_add,
> that is manage to mapping/unmapping explicitly.

I'll rework this.

>
> In fact I'm not sure what the point of the unmap/map cycles is.  At
> least in Linux concurrent buffer writes and mmap reads are coherent.

Adding an entry extends the file beyond what is mapped. The unmap
code was merely defensive, in case namreg_add is called somewhere
after the file is mapped. I spent some time looking at the callers,
and all namreg_adds occur before the file is mapped. namreg_del is
called after the file is mapped, but as it doesn't do anything this
is not a problem. I'll remove the unmap code.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
