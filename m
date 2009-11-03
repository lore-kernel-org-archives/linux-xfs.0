Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3JFTJG181000 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 13:15:29 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: Wrapped journal record corruption on read at recovery
Date: Tue, 3 Nov 2009 13:15:39 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE66@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE64@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Andy Poling <andy@realbig.com>
Cc: John Quigley <jquigley@cleversafe.com>, xfs@oss.sgi.com

Alex Elder wrote:
> Andy Poling wrote:
>> On Wed, 14 Oct 2009, Christoph Hellwig wrote:
>>>> It seems like the more elegant approach would be to set offset before the
>>>> first read, and then update it if the first read takes place (in case it was
>>>> unaligned).  That also gets rid of bufaddr, and seems like it might read
...


Andy, can you tell me the log sector
size of a file system that exhibits
this failure condition?

You can just send the output of:
    xfs_info /dev/<whatever>
if you like.  I have a suspicion
that there may still be a problem,
even with your proposed fix, and
would like to rule that possibility
out.  Basically, if log sectsz is
is > 1024 your fix is probably OK.

Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
