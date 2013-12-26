Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0FD67F3F
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 03:24:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CDF398F8049
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 01:24:00 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Tu8BXBFrg3FcKIHM
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 01:23:59 -0800 (PST)
Message-ID: <52BBF5B0.8020206@hardwarefreak.com>
Date: Thu, 26 Dec 2013 03:24:00 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: md-RAID5/6 stripe_cache_size default value vs performance vs
	memory footprint
References: <52B102FF.8040404@pzystorm.de> <52B2FE9E.50307@hardwarefreak.com>
	<52B41B67.9030308@pzystorm.de> <201312202343.47895.arekm@maven.pl>
	<52B57912.5080000@hardwarefreak.com>
	<20131226085510.GB32660@infradead.org>
In-Reply-To: <20131226085510.GB32660@infradead.org>
Reply-To: stan@hardwarefreak.com
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
Cc: linux-raid@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/26/2013 2:55 AM, Christoph Hellwig wrote:
> On Sat, Dec 21, 2013 at 05:18:42AM -0600, Stan Hoeppner wrote:
>> The powers that be, Linus in particular, are not fond of default
>> settings that create a lot of kernel memory structures.  The default
>> md-RAID5/6 stripe_cache-size yields 1MB consumed per member device.
> 
> The default sizing is stupid as it basically makes RAID unusable out
> of the box, I always have to fix that up, as well as a somewhat
> reasonable chunk size for parity RAID to make it usable.  I'm also
> pretty sure I complained about it at least once a while ago, but never
> got a reply.

IIRC you Dave C. and myself all voiced criticism after the default chunk
size was changed from 64KB to 512KB.  I guess we didn't make a strong
enough case to have it reduced, or maybe didn't use the right approach.

Maybe Neil is waiting for patches to be submitted for changing these
defaults, and to argue the merits in that context instead of pure
discussion?  Dunno.  Just guessing.  Maybe he'll read this and jump in.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
