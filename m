Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E1F97F4E
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 02:17:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6E9728F8035
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 00:16:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FwEDMqwnRir03Tl6 for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 00:16:57 -0700 (PDT)
Date: Mon, 11 Aug 2014 17:16:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Verifier fixes backported to stable kernels?
Message-ID: <20140811071629.GK26465@dastard>
References: <CA+o=1OVY0pV18XMKz98dT5LGwE500DQQb5B1wh=HaGTAGuP+oQ@mail.gmail.com>
	<20140809005404.GG26465@dastard>
	<CA+o=1OX+Qq4Scq=su1MDDknRXJGL8F=7WV8P0PCeDjYep7rLnA@mail.gmail.com>
	<CA+o=1OXmM+WsFh-ipS4d8hn6RKvOuv3Zga+66PF4DBehuH-5-A@mail.gmail.com>
	<20140811043219.GJ26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140811043219.GJ26465@dastard>
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

On Mon, Aug 11, 2014 at 02:32:19PM +1000, Dave Chinner wrote:
> On Sat, Aug 09, 2014 at 05:55:19PM +0200, Fanael Linithien wrote:
> > 2014-08-09 2:54 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> > > What fixes are you talking about? List of commits, please, noting
> > > whether the commit already has a "cc: <stable@vger.kernel.org>" in
> > > it or not.
> > 
> > These are the commits:
> > 
> > 400b9d88757c0bfbdfa97014e090ec40a31c1282
> > 67dc288c21064b31a98a53dc64f6b9714b819fd6 (this is the only one with the cc)
> > 5fd364fee81a7888af806e42ed8a91c845894f2d
> > ad3714b82c631a34724da09a7daa53afcab952fa
> 
> Ok, but please use the "one-line format" when quoting commits.
> 
> I.e. this:
> 
> $ git log --oneline -n 4 ad3714b
> ad3714b xfs: dquot recovery needs verifiers
> 5fd364f xfs: quotacheck leaves dquot buffers without verifiers
> 67dc288 xfs: ensure verifiers are attached to recovered buffers
> 400b9d8 xfs: catch buffers written without verifiers attached

Actually, I'm not going to send this last patch back to older,
stable kernels. I really don't want to have to port random patches
back to older kernels to avoid it generating false positives.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
