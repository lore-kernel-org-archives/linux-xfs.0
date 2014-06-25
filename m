Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D77327F5A
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 18:53:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A724B8F8039
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 16:53:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4IO1UwRJMEBzLFu9 for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 16:53:00 -0700 (PDT)
Date: Thu, 26 Jun 2014 09:52:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata CRC error upon unclean unmount
Message-ID: <20140625235246.GP9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard>
	<CA+o=1OXY8Ay8CSgsdiAOTacBa9800FiMKGbr0DdkE_YVpewqBw@mail.gmail.com>
	<20140625220336.GN9508@dastard>
	<CA+o=1OWptqFq87E0ncmYH2T6yEzeGheefE-o_VAm7-E_0Z+NJA@mail.gmail.com>
	<20140625232222.GS4453@dastard>
	<CA+o=1OXeRSs7ZXhnTdNrsuu+ozN0k=KmGa068=HqsMQ13XnRYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OXeRSs7ZXhnTdNrsuu+ozN0k=KmGa068=HqsMQ13XnRYQ@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 26, 2014 at 01:32:56AM +0200, Fanael Linithien wrote:
> 2014-06-26 1:22 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> > The before-mount image shows the CRC error, so it didn't come from
> > log recovery. It may have come from recovery in the previous
> > iteration, - do you still have the pre-mount images from the prior
> > iteration before the crash error was detected?
> 
> I don't have anything from between that log CRC eror and these. Should
> I try again?

It would be aprreciated if you could - I'm trying to reproduce it
here but I'm having no luck. I've been crashing CRC enabled
filesystems for the past 18 months and I can count on one hand the
number of times I've had a CRC error of any time during/after
recovery, so I'm not really surprised that...

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
