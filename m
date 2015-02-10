Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C9947FBE
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 04:06:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C85E304043
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 02:06:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AmeJsEq0a7UZYYk6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2015 02:06:54 -0800 (PST)
Date: Tue, 10 Feb 2015 08:06:47 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/2] xfs: pass mp to XFS_WANT_CORRUPTED_*
Message-ID: <20150210100647.GB1735@hades.maiolino.org>
References: <54D53E8C.8070207@redhat.com> <20150208213502.GA4251@dastard>
	<20150209130926.GA18336@laptop.bfoster>
	<20150209211744.GT12722@dastard>
	<20150209214359.GN18336@laptop.bfoster>
	<20150209215827.GW12722@dastard> <54D94A2A.8020906@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54D94A2A.8020906@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 09, 2015 at 06:00:42PM -0600, Eric Sandeen wrote:
> On 2/9/15 3:58 PM, Dave Chinner wrote:
> > On Mon, Feb 09, 2015 at 04:43:59PM -0500, Brian Foster wrote:
> >> On Tue, Feb 10, 2015 at 08:17:44AM +1100, Dave Chinner wrote:
> 
> ...
> 
> >> Sure, but ASSERT_CORRUPT_RET() is the same length as the example above.
> >> ASSERT_CORRUPT_GOTO() is only a few chars longer than the associated
> >> example. We could still use WANT over ASSERT I suppose to shorten it up
> >> further. Either of those are at least still self-explanatory in my
> >> opinion.
> > 
> > Thinking on it a bit further, the XFS_WANT_CORRUPTED macros have an
> > internal ASSERT in them, so they are effectively an ASSERT
> > statement. I could live with those names, especially as ASSERT is
> > something that can be compiled into production kernels via
> > CONFIG_XFS_WARN=y to turn them into error messages...
> 
> Sooooo you all want "ASSERT_CORRUPTED_RET / ASSERT_CORRUPTED_GOTO" ?
> 
> In a light mauve? ;)
> 

I could live with that, better a relative big macro's name than a shorter
abbreviated one that you should buy a crystal ball to really understand what it
means :)

> -Eric
> 
> > Cheers,
> > 
> > Dave.
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
