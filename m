Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A02967F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 17:28:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 911C18F8035
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 15:28:20 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	b14dcWwcb5KwxnlV for <xfs@oss.sgi.com>;
	Fri, 28 Feb 2014 15:28:18 -0800 (PST)
Date: Sat, 1 Mar 2014 10:28:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] metadump: pathname obfuscation overruns symlink buffer
Message-ID: <20140228232816.GF13647@dastard>
References: <1393568723-982-1-git-send-email-david@fromorbit.com>
	<1393568723-982-4-git-send-email-david@fromorbit.com>
	<5310CAEB.8080503@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5310CAEB.8080503@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Fri, Feb 28, 2014 at 11:44:11AM -0600, Eric Sandeen wrote:
> On 2/28/14, 12:25 AM, Dave Chinner wrote:
> > diff --git a/db/metadump.c b/db/metadump.c
> > index 3248009..cd489a6 100644
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -1015,16 +1015,23 @@ obfuscate_sf_dir(
> >  	}
> >  }
> >  
> > +/*
> > + * The pathname may not be null terminated. It name be terminated by the end of
> 
> can you fix up the start of that 2nd sentence?

Done.

> 
> Otherwise,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks!

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
