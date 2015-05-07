Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFCD07F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 22:05:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6147304059
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 20:05:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UwT9DuVooACOaSak for <xfs@oss.sgi.com>;
	Wed, 06 May 2015 20:05:50 -0700 (PDT)
Message-ID: <554AD68D.7040901@sandeen.net>
Date: Wed, 06 May 2015 22:05:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: SGI Version 1 XFS on Linux
References: <2994A55DE0FBBE41B8FE47F9885D74221BC0569C@ARLEXCHMBX02.lst.link.l-3com.com>	<20150506171222.GA22744@sgi.com>	<2994A55DE0FBBE41B8FE47F9885D74221BC056F3@ARLEXCHMBX02.lst.link.l-3com.com>
	<20150506215816.GE4327@dastard>
In-Reply-To: <20150506215816.GE4327@dastard>
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
To: Dave Chinner <david@fromorbit.com>, "Scott, Edmund J @ SSG - Link" <edmund.scott@l-3com.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/6/15 4:58 PM, Dave Chinner wrote:
> On Wed, May 06, 2015 at 07:47:51PM +0000, Scott, Edmund J @ SSG -
> Link wrote:
>> Hi,
>>
>> We are in a thunderstorm right now so we had to shut down, be a
>> while until we get things back up. We're in Utah with a rolling
>> t-storm coming through. 
>>
>> We did find documentation that XFS version 1 was pulled out of the
>> linux kernel around or after kernel 2.4. and the messages kind of
>> support that. I'm looking into digging up an old Red Hat OS to see
>> if it is old enough to have the version 1 XFS in it.
> 
> You'd be talking about the directory version, then, not the version
> of the filesystem? Irix 6.2 introduced Version 4 filesystems, but
> version 2 directories didn't come along until a couple of years
> later. See Slides 6-7 here:
> 
> http://events.linuxfoundation.org/sites/events/files/slides/dchinner-xfs-there-and-back.pdf
> 
> As it is, the dirv1 removal commit says "Never functioned on Linux,
> just pure bloat".
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=b84149405b9c2ecbc445d2684053e4acc03342ee
> 
> So I suspect that the only way you are going to be able to read
> those filesystems is with an Irix machine....

IIRC it worked, FSVO "worked" - I forget the issues, but you will
at least be able to mount it and get some data, I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
