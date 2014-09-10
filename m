Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AD647F5F
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:43:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CF648F8052
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:43:11 -0700 (PDT)
Received: from mail04.lsn.net (mail04.lsn.net [66.90.130.138]) by cuda.sgi.com
	with ESMTP id 8vstn0KcJ354nJpy for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 18:43:10 -0700 (PDT)
Message-ID: <540FACAC.3010504@mygrande.net>
Date: Tue, 09 Sep 2014 20:43:08 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>
	<20140909220645.GH20518@dastard>	<540FA586.9090308@mygrande.net>
	<CAA43vkVYX+zJQcoTH2iSX7rS9B1D=mnTeyS0QqP+fbKxVY0YZA@mail.gmail.com>
In-Reply-To: <CAA43vkVYX+zJQcoTH2iSX7rS9B1D=mnTeyS0QqP+fbKxVY0YZA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/9/2014 8:25 PM, Sean Caron wrote:
> Hi Leslie,
>
> You really don't want to be running "green" anything in an array... that
> is a ticking time bomb just waiting to go off... let me tell you... At
> my installation, a predecessor had procured a large number of green
> drives because they were very inexpensive and regrets were had by all.

	The alternative is nothing at all.  I am not a company, just a guy with 
a couple of arrays at his house.  'Not a rich guy, either.

	I've had these arrays since 2001 with only one other mass drive 
failure, and that was not unrecoverable, nor were they "green" drives. 
(Four Seagate drives all suddenly decided they did not want to be part 
of the array, so md kicked all four simultaneously.  After that, they 
would not stay up as part of the array long enough to be mounted.  I was 
able to read all four with dd_rescue, and get the array back online 
without a single lost file.

	Note also these arrays are not usually under any sort of massive load. 
  The bulk of the data is video files which are written once at about 
80MBps and then read one-by-one at about 4MBps.

> Lousy performance, lots of spurious ejection/RAID gremlins and the
> failure rate on the WDC Greens is just appalling...

	None of the failed drives were WD green.  All three and the previous 
four were Seagate.  I realize that is not a large statistical sample.

> BBWC stands for Battery Backed Write Cache; this is a feature of
> hardware RAID cards

	Ah, yes.  This array does not have a BBWC controller.  The backup array 
does, actually, but the battery backup is disabled.

> it is just like it says on the tin; a bit (usually
> half a gig, or a gig, or two...) of nonvolatile cache that retains
> writes to the array in case of power failure, etc. If you have BBWC
> enabled but your battery is dead, bad things can happen. Not applicable
> for JBOD software RAID.

	Exactly.  All the arrays are JBOD / mdadm.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
