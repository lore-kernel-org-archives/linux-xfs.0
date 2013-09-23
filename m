Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B63CC7F58
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 09:04:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 96FBE8F8049
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 07:04:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ASiVp576UTmu9day for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 07:04:30 -0700 (PDT)
Message-ID: <52404A6E.4070306@sandeen.net>
Date: Mon, 23 Sep 2013 09:04:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: update version for 3.2.0-alpha1
References: <20130916205637.GD1935@sgi.com> <20130916223855.GF19103@dastard>
	<20130923122623.GA2199@infradead.org>
In-Reply-To: <20130923122623.GA2199@infradead.org>
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
Cc: rjohnston@sgi.com, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 9/23/13 7:26 AM, Christoph Hellwig wrote:
> On Tue, Sep 17, 2013 at 08:38:55AM +1000, Dave Chinner wrote:
>> On Mon, Sep 16, 2013 at 03:56:37PM -0500, Ben Myers wrote:
>>> xfsprogs: update version for 3.2.0-alpha1
>>
>> I'd say this is a major feature and infrastructure
>> update across the entire xfsprogs package, and in that case a
>> PKG_MAJOR bump is warranted, not PKG_MINOR.
>>
>> i.e. We're shooting for a 4.0 release, not 3.2...
> 
> I tend to disagree with the 4.0 bump.
> 
> 2.0 was when the new xattr ABI was introduced, and 3.0 was when we
> pulled fsr over from xfsdump to xfsprogs as well as drastically reducing
> the amount of installed headers.
> 
> While the v5 support is a major internal change I think 3.2 would fit
> better for this.

*shrug* TBH I Don't care a whole lot.  Externally for old users in theory
it shouldn't be a big change.  But internally it's huge, and it enables
a new disk format, so ... well, I don't want to bikeshed it too much.

I'd mostly like to see _something_ w/ a version number on it so distros
can easily start to pick it up in testing repos.

> I'd also be tempted to just cut 3.2.0 instead of an alpha version - just
> keep the v5 support experimental, maybe under a configure option.

But so many changes are already made throughout the codebase, I think firing
off a point release with half-baked V5 support seems weird at this point.

IOWs, aside from the V5 work I'm not sure anything merits a point release.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
