Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CH5YYj007603 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 11:05:34 -0600
Message-ID: <4F0F12DC.5020709@sgi.com>
Date: Thu, 12 Jan 2012 11:05:32 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 12/12] repair: cleanup inode record macros
References: <20111202174619.179530033@bombadil.infradead.org>	<20111202174743.697687824@bombadil.infradead.org>
	<20120111113020.GD10932@infradead.org>
In-Reply-To: <20120111113020.GD10932@infradead.org>
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

On 01/11/12 05:30, Christoph Hellwig wrote:
> ping?
>
> On Fri, Dec 02, 2011 at 12:46:31PM -0500, Christoph Hellwig wrote:
>> Remove indirections in the inode record bit manipulation macros and flatten
>> them to a single level of inlines.  Also use a common IREC_MASK define
>> instead of duplicating it for every bitmask.
>>
>>
>> Signed-off-by: Christoph Hellwig<hch@lst.de>
>>

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

The clean up looks good. I like the removal of the side effect that was 
in one of the ASSERT statement.

--Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
