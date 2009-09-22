Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8MFKRrp199484 for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 10:20:27 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3770D16B5763
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 08:21:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XKzVDhIKB5WeZGdf for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2009 08:21:44 -0700 (PDT)
Message-ID: <4AB8EB80.80707@sandeen.net>
Date: Tue, 22 Sep 2009 10:21:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_repair: fix record_allocation list manipulation
References: <4AB300CC.5020707@sandeen.net> <4AB4EDBC.9050609@sandeen.net>
	<20090922120231.GB8143@infradead.org>
In-Reply-To: <20090922120231.GB8143@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Sat, Sep 19, 2009 at 09:42:04AM -0500, Eric Sandeen wrote:
>> clang found this one too as a "Dead assignment"
>>
>> Unless my pointer-fu is totally messed up, this function
>> was never actually updating the list head.
>>
>> This would mean that the later free_allocations() calls in
>> incore_ext_teardown() and free_rt_dup_extent_tree() don't
>> actually free any items, and therefore leak memory.
>>
>> V2: now with correct pointer-fu.
> 
> Barry already had this in his repair speedups patchkit, but I left it
> out for now because I wasn't too sure how this could work at all.

Hm, the patch as reposted does indeed free the allocations; I double
checked .... on a fairly large filesystem I saw about 10MB of memory
that was lost otherwise; not huge.

> After reviewing it again I noticed that it can actually work 

the original code can work?

> because the
> addr pointer in the ba_rec_t is unused, and we make use of the fact that
> the ba_rec_t is the first field in the structure to be tacked.  Entirely
> to subtile for my taste.  Id' prefer to just put a list_head into the
> extent_alloc_rec_t and rt_extent_alloc_rec_t and openconde the
> tracking/freeing of the beast.  The list_head if just as large as the
> ba_rec_t and make sure the list handlinjg is right, and the openconding
> gets rid of the annoying assumption that the ba_rec_t is the first thing
> in the structure to be tracked.  It should also be a net-removal of
> code.

Yeah, that sounds better.

IF barry's speedups stuff obsoletes this work should I just put it on
the shelf for now?

Sorry; you're probably at linuxcon, I'm having a hard time parsing all
of the quick reply ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
