Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D79AB7F73
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:55:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 950E8AC004
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 10:55:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ANFETHK1DXLCfI7t for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 10:55:54 -0700 (PDT)
Message-ID: <534EC42D.1080704@sandeen.net>
Date: Wed, 16 Apr 2014 12:55:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
References: <534EC073.8090006@sandeen.net> <534EC282.7010905@sandeen.net>
	<20140416175117.GA23643@infradead.org>
In-Reply-To: <20140416175117.GA23643@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/16/14, 12:51 PM, Christoph Hellwig wrote:
> On Wed, Apr 16, 2014 at 12:48:50PM -0500, Eric Sandeen wrote:
>> XFS_ERROR was designed long ago to trap return values,
>> but it's not runtime configurable, it's not consistently used,
>> and we can do the same thing today with systemtap, using
>> something like:
>>
>> probe module("xfs").function("xfs_*").return { if (@defined($return) && $return == VALUE) { ... } }
> 
> Gives me a version just using ftrace, or at least a kprobes based module
> that we can merged in the kernel tree and this would be fine for me.
> 
> Requiring a massive blob of questionable out of tree module code and a
> compiler is an absolute no-go.

Ok, fair point.
 
> NAK for now.

Even if we don't have a replacement, I have yet to find anyone who has
ever used it...

Anyway, I'll look into options besides systemtap.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
