Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4TGsYM0254285 for <xfs@oss.sgi.com>; Tue, 29 May 2012 11:54:34 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id HbUX00WVOWVsF95Z for <xfs@oss.sgi.com>;
	Tue, 29 May 2012 09:54:32 -0700 (PDT)
Message-ID: <4FC4FF47.50606@sandeen.net>
Date: Tue, 29 May 2012 11:54:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 016: Do not discard blocks at the mkfs time,
	more verbose version
References: <1319625983.3074.28.camel@dhcp-26-208.brq.redhat.com>
	<be02ada1-aee5-406d-84cd-d54dde7ae871@zmail16.collab.prod.int.phx2.redhat.com>
	<20111028095354.GA1062@infradead.org>
In-Reply-To: <20111028095354.GA1062@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Boris Ranto <branto@redhat.com>, xfs <xfs@oss.sgi.com>

On 10/28/11 4:53 AM, Christoph Hellwig wrote:
> On Fri, Oct 28, 2011 at 05:38:06AM -0400, Boris Ranto wrote:
>> The test 016 fills scratch device with some data and then creates xfs fs
>> on the scratch device. Later, the test assumes that the previously
>> written data are still written there and checks for them at specific
>> locations. On ssd drive this will lead to a failure since the blocks are
>> discarded by default when the mkfs command is run.
>> This is a more verbose version of the previous patch.
>> This simple patch that adds -K to stop the discarding (if the mkfs
>> command supports it) fixed the issue for me:
>>
>> Signed-off-by: Boris Ranto <branto@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Seems this one got lost; we should still merge it, yes?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
