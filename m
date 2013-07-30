Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 71A967CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 14:37:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09363AC005
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 12:37:19 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id DBMzA2hxmUtos3YB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Jul 2013 12:37:18 -0700 (PDT)
Message-ID: <51F815EB.9040000@profihost.ag>
Date: Tue, 30 Jul 2013 21:37:15 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [xfs-masters] how to use fstrim?
References: <51F2BD31.5060301@profihost.ag> <20130727015029.GT13468@dastard>
In-Reply-To: <20130727015029.GT13468@dastard>
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
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 27.07.2013 03:50, schrieb Dave Chinner:
> On Fri, Jul 26, 2013 at 08:17:21PM +0200, Stefan Priebe wrote:
>> Hi,
>>
>> what is the right way to use fstrim on top of XFS? just doing fstrim
>> -v -m 4194304 /
>>
>> results sometimes (might depend on disk i/o) to hanging tasks and
>> stack traces - fstrim needs > 5 min in these cases.
>
> It does indeed depend on disk IO. XFS walks all the free space and
> issues discards on it, so runtime is always O(freespace). And while
> it is walking an AG discarding the free space, it will hold the AG
> locked so that free space doesn't change. This can hang other
> operations for the length of time it takes to discard all the free
> space in the AG.
 > IOWs, the behaviour of fstrim on XFS is entirely dependent on the
 > speed of the block layer and hardware implementations of discards.

Yes OK i understand that but is there any way to prevent getting the 
whole server crash when I/O is too much?

For example splitting whole disk or even AGs into subparts? Or set a 
timeout for the fstrim command?

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
