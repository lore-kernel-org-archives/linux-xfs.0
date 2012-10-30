Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UJqetw069024 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 14:52:41 -0500
Message-ID: <50903075.6060600@redhat.com>
Date: Tue, 30 Oct 2012 14:54:29 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump:fill in bs_forkoff
References: <5080D0BD.3000304@redhat.com> <20121030194718.GD405@sgi.com>
In-Reply-To: <20121030194718.GD405@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/30/12 2:47 PM, Ben Myers wrote:
> Hey Eric,
> 
> On Thu, Oct 18, 2012 at 11:02:05PM -0500, Eric Sandeen wrote:
>> Upstream, the structure containing bs_forkoff is actually zeroed
>> prior to these functions, but when pulling the patch back to an
>> older xfsdump, we got checksum errors due to an uninitialized
>> bs_forkoff not matching in dump vs. restore.
>>
>> So even though forkoff won't be explicitly restored from
>> a dump, do explicitly set it in these routines to keep checksums
>> happy.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Would you say that this is appropriate for the upcoming release?

Hm.

The zeroing isn't in a really obvious spot, IIRC, so explicitly
filling in all members leaves nothing to chance.

OTOH it's a member that (will/should) never get restored,
so filling it in is a little confusing.  What do you think?

I think it should be harmless to functionality either way.

-Eric

> Thanks,
> 	Ben
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
