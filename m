Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5R8Mq7I058450 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 03:22:52 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC3493064C
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 01:22:50 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id yfwylY1rL8mlH4yF
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 01:22:50 -0700 (PDT)
Message-ID: <4E083DDA.1000101@hardwarefreak.com>
Date: Mon, 27 Jun 2011 03:22:50 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: question on new feature complexity/possibility/sensibility? (^
	Alternate)
References: <4E067D81.4070605@tlinx.org>
	<20110627003209.GD32466@dastard>	<4E080249.9060903@tlinx.org>
	<20110627060240.GF32466@dastard>
In-Reply-To: <20110627060240.GF32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/27/2011 1:02 AM, Dave Chinner wrote:
> On Sun, Jun 26, 2011 at 09:08:41PM -0700, Linda Walsh wrote:
>>
>>
>> Dave Chinner wrote:
>>> So use a filesystem that supports them natively ;)
>> ---
>> 	Got any in in mind that also support acls, extended attrs
>> and has the reliability and performance of xfs?  ;-)
> 
> For most "normal" workloads, ZFS would probably be your only
> production ready option. But that's not something you could use on
> Linux, is it? :/

It is apparently usable on Linux for those willing to build and maintain
it themselves.  But that level of administrative burden in itself is the
opposite of production ready.

> Until btrfs is a completely baked cake, you won't be able to tick
> all those boxes, and even then there will be questions about
> performance...

Or until Oracle releases ZFS under GPL, or a compatible license, which
probably isn't going to happen.  Apparently Oracle believes their SPARC
and x86 hardware won't sell if ZFS is free on Linux.  Now that Oracle
owns Solaris and ZFS I'd bet they wish they could put the BTRFS genie
back in the bottle, as well as OCFS, etc.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
