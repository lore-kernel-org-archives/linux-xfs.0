Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0943E29E11
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 16:35:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8B1E304032
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:35:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IoiUMWVfRQ55k8gt for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 14:35:36 -0700 (PDT)
Message-ID: <523A1CA6.3020302@sandeen.net>
Date: Wed, 18 Sep 2013 16:35:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: update version for 3.2.0-alpha1
References: <20130916205637.GD1935@sgi.com> <20130916223855.GF19103@dastard>
In-Reply-To: <20130916223855.GF19103@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, rjohnston@sgi.com, xfs@oss.sgi.com

On 9/16/13 5:38 PM, Dave Chinner wrote:
> On Mon, Sep 16, 2013 at 03:56:37PM -0500, Ben Myers wrote:
>> xfsprogs: update version for 3.2.0-alpha1
> 
> I'd say this is a major feature and infrastructure
> update across the entire xfsprogs package, and in that case a
> PKG_MAJOR bump is warranted, not PKG_MINOR.
> 
> i.e. We're shooting for a 4.0 release, not 3.2...

Yeah good point.  I'm fine with 4.0.  It smells like Progress!  ;)

Dave also pointed out offline that maybe a 3.99 might be easier
on some package managers; for Fedora it's no problem, I can just
do some sort of 

4.0-0.1.alpha1
4.0-0.2.alpha2
4.0-0.3.alpha3
4.0-0.4.rc1
...
4.0-1

type progression.  But if people like 3.99 *shrug* let's not paint
this bike shed too many times.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
