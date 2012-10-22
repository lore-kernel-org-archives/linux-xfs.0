Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9MK9ojb135951 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 15:09:51 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SkcL84Y4EUyyAvxz for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 13:11:32 -0700 (PDT)
Message-ID: <5085A873.9030402@sandeen.net>
Date: Mon, 22 Oct 2012 15:11:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfsdump: more projid32bit fixes
References: <50788C50.40600@redhat.com>
In-Reply-To: <50788C50.40600@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/12/12 4:32 PM, Eric Sandeen wrote:
> I recently sent a patch for 32-bit project IDs for xfsdump, to properly
> restore the top 16 bits, which otherwise get lost.  This forced a new
> dump format version 4 (we were currently at 3).
> 
> One thing missing is that we should not restore a dump with 32-bit
> project IDs onto a filesystem w/o that format; the restore will fail
> to restore the top 16 bits (but otherwise it returns success; attribute
> setting failures are not fatal (!?))
> 
> Also, 32-bit project ID is a bit uncommon; bumping the format (and making
> older restore incompatible) is a bit draconian.
> 
> 3 patches here:
> 
> 1/3: extend fs info call to get fs flags as well
> 2/3: default back to V3 and go to V4 only if the projid32 flag is set
> 3/3: fail restore if the target XFS fs doesn't have projid32 set

I think I should self-NAK this patchset, after a bit more thought.

Because the PROJID32BIT feature flag isn't available via the GEOM
ioctl for almost every kernel in existence (it'll be in what, 3.8?),

2/3) we'll fall back to V3 even if projid32bit is actually in use, and/or
3/3) we'll refuse to restore perfectly valid V4 dumps with 32-bit
     projids to older kernels just because they don't report the feature.

I think this'd cause more confusion/trouble than it's worth, since we've
been lacking the GEOM flag for so long.

-Eric

> I have to say, I'm not super happy with this.  I have nagging fear
> of feature-flag-itis, and I'm not sure how extensible this is as newer
> versions may appear.  But anyway, here's a place to start.
> 
> (p.s. anybody have wkendall's new email?)  ;)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
