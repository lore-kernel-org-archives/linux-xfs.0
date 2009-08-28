Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SMdrNo181301 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 17:40:03 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DBAF58F80CA
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 15:40:47 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfsprogs: fix unaligned access in libxfs
Date: Fri, 28 Aug 2009 17:38:29 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF1@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090828221530.GB17666@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Gabriel Vlasiu <gabrielvlasiu@gmail.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Aug 28, 2009 at 04:39:49PM -0500, Alex Elder wrote:
>>> +static inline __uint32_t __get_unaligned_be32(const __uint8_t *p)
>> 
>> 
>> It would be nice for this interface (and others) to take a (void *)
>> argument, but that would also mean immediately casting it to do
>> pointer arithmetic portably.  Not a big deal.
> 
> the __ routines are internal implementation details, the kernel
> has non-__ prefixed versions that take void pointers, but I didn't
> bother to add them to xfsprogs as we only do unaligned access to
> 64bit values.
> 
> That beeing said I dislike the interface taking void pointers as
> it removes important error checking.  The actually visible interface
> should take __be16/32/64 types to enforce they are used on the right
> type.  Once I get some time I will push for that in the kernel again,
> but for xfsprogs I really do want to stick to the kernel interfaces so
> that we can share the code unmodified.

The results should be int types:  __be16, etc., I agree.  But
I'm saying the unaligned addresses--which we (now) make no
assumptions about and treat as character pointers--I think
the void pointer explicitly captures that unaligned quality
(and avoids any need for a cast).

In any event I think it's fine either way.  Really not a big
deal, just a tiny detail that only a geek could love to
argue about.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
