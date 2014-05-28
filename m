Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F65C7F5D
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 08:50:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 601E88F8068
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 06:50:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zihaGvEZtEoUGiK9 for
	<xfs@oss.sgi.com>; Wed, 28 May 2014 06:50:39 -0700 (PDT)
Message-ID: <5385E996.30309@redhat.com>
Date: Wed, 28 May 2014 08:50:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2, RFC] xfsprogs: try to handle mkfs of a file on 4k
	sector device
References: <53852A05.5040006@redhat.com>
	<20140528054142.GC13166@infradead.org>
In-Reply-To: <20140528054142.GC13166@infradead.org>
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

On 5/28/14, 12:41 AM, Christoph Hellwig wrote:
>> We can modify platform_findsizes() to use the fsgeom call to get the
>> "sector size" which should be used here, and warn that mismatches
>> might exist if it fails.
>>
>> This does mean there'll be a new warning emitted on fs images hosted
>> on non-xfs filesystems; I'm not really quite sure it's worth it,
>> hence the RFC nature of this lightly tested 2-patch series...
> 
> Might be time to introduce some generic VFS-level ioctl for the sector
> size and dio alignment.  Any beer or chocolate that could motivate you
> to get this done? :)

Roses from you, Christoph.  ;)

Yeah, we do desperately need this.  Not sure why nobody's done it yet,
I'll see if I can get the time & motivation going, and launch into
the bike shed building.  :)

> Also it would be nice to have a test case that exercises this new code.

Hm yeah fair enough; I tested it w/ scsi-debug...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
