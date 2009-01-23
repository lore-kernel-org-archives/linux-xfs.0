Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0N6M62j169004 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 00:22:06 -0600
In-Reply-To: <20090123000617.GB4970@infradead.org>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice>
	<20090121035703.GH10158@disturbed>
	<200901211503.07308.nickpiggin@yahoo.com.au>
	<20090122043747.GU10158@disturbed>
	<20090122061158.GA31104@infradead.org>
	<20090123000203.GC32390@disturbed>
	<20090123000617.GB4970@infradead.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <287917FE-424B-4DAD-B957-6B37C171E888@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Date: Fri, 23 Jan 2009 00:20:44 -0600
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
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Pavel Machek <pavel@suse.cz>, npiggin@yahoo.com.au, Chris Mason <chris.mason@oracle.com>


On Jan 22, 2009, at 6:06 PM, Christoph Hellwig wrote:

>> [XFS] Check buffer lengths in log recovery
>>
>> Before trying to obtain, read or write a buffer,
>> check that the buffer length is actually valid. If
>> it is not valid, then something read in the recovery
>> process has been corrupted and we should abort
>> recovery.
>>
>> Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
>> Signed-off-by: Dave Chinner <david@fromorbit.com>
>> Tested-by: Eric Sesterhenn <snakebyte@gmx.de>
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
