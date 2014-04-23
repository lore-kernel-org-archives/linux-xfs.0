Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C447F7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 00:54:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C489AC00A
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 22:54:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iBCspkjgM1fEbpW8 for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 22:54:19 -0700 (PDT)
Date: Wed, 23 Apr 2014 15:54:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remote attribute overwrite causes transaction overrun
Message-ID: <20140423055417.GK15995@dastard>
References: <1398149949-11324-1-git-send-email-david@fromorbit.com>
	<535659F7.4060702@oracle.com> <20140422234628.GN18672@dastard>
	<20140423000042.GO18672@dastard> <53572DDA.8080302@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53572DDA.8080302@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On Tue, Apr 22, 2014 at 10:04:58PM -0500, Eric Sandeen wrote:
> On 4/22/14, 7:00 PM, Dave Chinner wrote:
> > On Wed, Apr 23, 2014 at 09:46:28AM +1000, Dave Chinner wrote:
> >> On Tue, Apr 22, 2014 at 08:00:55PM +0800, Jeff Liu wrote:
> >>>
> >>> On 04/22 2014 14:59 PM, Dave Chinner wrote:
....
> >>>> +	/* remote value might be different size to the buffer supplied. */
> >>>> +	if (args->rmtvaluelen = args->valuelen)
> >>> 			     ^^^
> >>> Here is a typo...
> >>
> >> Oh, well spotted.
> >>
> >> But, hold on a minute, shouldn't gcc be catching those sorts of
> >> typos?
....
> > Time to add ccflags-y += -Werror to the makefile....
> 
> Probably only under a couple specific arches...?  How are we for i.e.
> stupid printf format warnings about long vs. longlong on 32/64 arches...?
> 
> Or maybe you can -Werror, -Wno$FOO?

Personally, if other arches are throwing warnings that we don't know
about, they need to be fixed. The only way I'll get to know about
them is to have somebody else's build break, because nobody is
reporting warnings to us right now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
