Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06F317F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 17:46:56 -0500 (CDT)
Message-ID: <5269A35F.5080500@sgi.com>
Date: Thu, 24 Oct 2013 17:46:55 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstest: fix filtering in 206 for ftype and projid32bit
References: <20131024215652.413619467@sgi.com> <20131024221136.GZ2797@dastard>
In-Reply-To: <20131024221136.GZ2797@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Community <xfs@oss.sgi.com>

On 10/24/13 17:11, Dave Chinner wrote:
> On Thu, Oct 24, 2013 at 04:56:42PM -0500, Mark Tinguely wrote:
>> xfs/206 displays the output for mkfs.xfs, xfs_growfs and xfs_info.
>> Change the filtering to hide the new output for the field type
>> feature.
>>
>> While cleaning up the ftype output, also clean up the projid32bit
>> output in xfs_growfs and xfs_info.
>
> What about the _filter_mkfs function that other tests use?
>
> Cheers,
>
> Dave.

 From what I can tell, it does not need changing.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
