Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B68E17F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 16:29:12 -0500 (CDT)
Message-ID: <52699128.8070306@sgi.com>
Date: Thu, 24 Oct 2013 16:29:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/4] xfsprog: add mkfs.xfs sb v4 support for dirent
	filetype field
References: <20131017152804.204045257@sgi.com>
	<20131017152955.689963160@sgi.com>
	<20131024161514.GA14558@infradead.org>
	<20131024211708.GU2797@dastard>
In-Reply-To: <20131024211708.GU2797@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 10/24/13 16:17, Dave Chinner wrote:
> On Thu, Oct 24, 2013 at 09:15:14AM -0700, Christoph Hellwig wrote:
>> On Thu, Oct 17, 2013 at 10:28:08AM -0500, Mark Tinguely wrote:
>>> Add directory inode type feature to mkfs.xfs and its manual page.
>>>
>>> In sb v4, "mkfs.xfs -n ftype=1" turns on the feature.
>>>
>>> The feature is automatically turned on for "-m crc=1", but reject
>>> the use of the "-n ftype=0|1" with the "-m crc=1" option.
>>
>> Seems like this causes a spurious failure in xfs/206:
>
> Yes, it will. the xfstests repair filter needs to be updated every
> time a new option is added to the output.
>
> Cheers,
>
> Dave.

Thanks for the heads up.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
