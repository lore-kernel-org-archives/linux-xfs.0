Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EE997F3F
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 09:22:52 -0500 (CDT)
Message-ID: <52307CB6.3060506@sgi.com>
Date: Wed, 11 Sep 2013 09:22:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: change the immutable in xfs_open_by_handle
References: <20130910184724.726933044@sgi.com>
	<20130911135502.GA21898@infradead.org>
In-Reply-To: <20130911135502.GA21898@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg Banks <gbanks@sgi.com>, xfs@oss.sgi.com

On 09/11/13 08:55, Christoph Hellwig wrote:
> On Tue, Sep 10, 2013 at 01:47:20PM -0500, Mark Tinguely wrote:
>> This patch allows clients like DMF to modify an immutable file
>> without changing the immutable capability on the file, which
>> would expose the file to change.
>>
>> This patch is restricted to holders of the CAP_LINUX_IMMUTABLE,
>> so no addition security risk has been introduced.
>
> The immutable flag means that the file can't be modified, and
> CAP_LINUX_IMMUTABLE allows setting/removing that restriction, but not
> ignoring it.
>
> So: NAK, this is a change in semantics and long-standing behaviour.
>

As you said, the CAP_LINUX_IMMUTABLE allows the holder of the capability 
to turn on/off the restriction. The holder of CAP_LINUX_IMMUTABLE could 
turn off immutability, modify it and then turn it back on, but during 
that window, others could modify it too which may be more undesirable 
than changing the behavior.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
