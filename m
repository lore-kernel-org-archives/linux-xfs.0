Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9MEYNV7098392 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 09:34:23 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id h63TE6cQfESP8YBw for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 07:36:05 -0700 (PDT)
Message-ID: <508559DE.3060203@sandeen.net>
Date: Mon, 22 Oct 2012 09:36:14 -0500
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
> 
> I have to say, I'm not super happy with this.  I have nagging fear
> of feature-flag-itis, and I'm not sure how extensible this is as newer
> versions may appear.  But anyway, here's a place to start.
> 
> (p.s. anybody have wkendall's new email?)  ;)

I spoke with Bill, and he actually didn't feel that a new version was
needed for the projid32 fix.  I'd like to get some discussion here,
and reach an agreement.  *NOT* bumping the version simplifies a whole
lot of things.

Here's what I'd said to Bill:

>> If we restore old dumps w/ new xfsdump, nothing special is needed;
>> 0 gets restored for the top 16 bits (vs. garbage, which WOULD be
>> bad).
>> 
>> So bumping the version really only prevents old restore from
>> restoring newer dumps.
>> 
>> If I *didn't* bump the version, then old restore would work, and
>> would simply not restore the top 16 bits - just like an old
>> dump+restore option did.

And Bill replied:

> Had a look at xfsdump, and I agree, there's no need to bump the format
> version. Nice of someone to leave some zeroed pad bytes next to the
> project id. 

so what are people's thoughts?  Moving to a new version has complexity
& compatibility consequences...

Thanks,
-Eric


> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
