Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9MGKsl7109605 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 11:20:54 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XTQ2cHZbGfmGPMiP for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 09:22:36 -0700 (PDT)
Message-ID: <508572D4.7080101@sandeen.net>
Date: Mon, 22 Oct 2012 11:22:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfsdump: more projid32bit fixes
References: <50788C50.40600@redhat.com> <508559DE.3060203@sandeen.net>
	<20121022155604.GL1377@sgi.com>
In-Reply-To: <20121022155604.GL1377@sgi.com>
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

On 10/22/12 10:56 AM, Ben Myers wrote:
> Hey Eric,
> 
> On Mon, Oct 22, 2012 at 09:36:14AM -0500, Eric Sandeen wrote:
>> On 10/12/12 4:32 PM, Eric Sandeen wrote:
>>> I recently sent a patch for 32-bit project IDs for xfsdump, to properly
>>> restore the top 16 bits, which otherwise get lost.  This forced a new
>>> dump format version 4 (we were currently at 3).
>>>
>>> One thing missing is that we should not restore a dump with 32-bit
>>> project IDs onto a filesystem w/o that format; the restore will fail
>>> to restore the top 16 bits (but otherwise it returns success; attribute
>>> setting failures are not fatal (!?))
>>>
>>> Also, 32-bit project ID is a bit uncommon; bumping the format (and making
>>> older restore incompatible) is a bit draconian.
>>>
>>> 3 patches here:
>>>
>>> 1/3: extend fs info call to get fs flags as well
>>> 2/3: default back to V3 and go to V4 only if the projid32 flag is set
>>> 3/3: fail restore if the target XFS fs doesn't have projid32 set
>>>
>>> I have to say, I'm not super happy with this.  I have nagging fear
>>> of feature-flag-itis, and I'm not sure how extensible this is as newer
>>> versions may appear.  But anyway, here's a place to start.
>>>
>>> (p.s. anybody have wkendall's new email?)  ;)
>>
>> I spoke with Bill, and he actually didn't feel that a new version was
>> needed for the projid32 fix.  I'd like to get some discussion here,
>> and reach an agreement.  *NOT* bumping the version simplifies a whole
>> lot of things.
> 
> Can you post a list of things that it simplifies?  That would help with the
> discussion.
> 
>> Here's what I'd said to Bill:
>>
>>>> If we restore old dumps w/ new xfsdump, nothing special is needed;
>>>> 0 gets restored for the top 16 bits (vs. garbage, which WOULD be
>>>> bad).
>>>>
>>>> So bumping the version really only prevents old restore from
>>>> restoring newer dumps.
>>>>
>>>> If I *didn't* bump the version, then old restore would work, and
>>>> would simply not restore the top 16 bits - just like an old
>>>> dump+restore option did.
>>
>> And Bill replied:
>>
>>> Had a look at xfsdump, and I agree, there's no need to bump the format
>>> version. Nice of someone to leave some zeroed pad bytes next to the
>>> project id. 
>>
>> so what are people's thoughts?  Moving to a new version has complexity
>> & compatibility consequences...
> 
> Initially I think that moving to the new version was the right thing to do.
> It's good for users to have some warning when there are consequences of
> upgrading to a new release of xfsdump.
> 
> A new dump format version will make old xfs_restore fail with an error if a v4
> dump is encountered, rather than do the restore and chop off the top 16 bits of
> the project id silently.  I think that for a user it is reasonable to expect to
> be notified if project ids are going to be lost.  Looks like there is no way
> for an older xfsrestore to force an override, so if there is to be some level
> of compatability between versions, newer xfsdump would have to still be able to
> create v3 dumps.
> 
> What other complexity/compat issues are there?

Well, I started putting in some feature flag detection.  So in a super-perfect world
we could:

* Dump to to V4 only if the PROJID32 flag is set on the fs being dumped, else V3
* Refuse / warn if restoring a < V4 dump onto a fs w/ the PROJID32 set
* Refuse / warn if restoring a >= V4 dump onto a non-PROJID32 fs
* Extend the -K option to allow specifying/forcing arbitrary dump levels

But:

* No released kernel yet reports the feature flag, so we don't have guarantees
  about feature presence
 - So going to V4 only if flag found will silently fail prior to kernel 3.7,
   since no feature flag is available there.
 - so then we should default to V4 regardless of feature flag test
  ~ so then we can't make restore of V4 require the feature flag on the fs
* Older dump/restore already has the silent failure problem
* By the time you are restoring a <V4 dump onto a PROJID32 fs, it's unlikely
  that you have further options anyway (you're possibly in recovery, can't go
  back & make V4 dumps to restore from)
* Warning on >= V4 dump to non-PROJID32 fs only makes sense if V4 is contingent
  on feature set/recognized at dump time but we cant' reliably detect that.
* projid32bit is a non-default option today, so it's an infrequent case...

-Eric



> Regards,
> 	Ben
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
