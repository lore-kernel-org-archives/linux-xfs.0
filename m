Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6EFC47F83
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2014 03:53:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EBA78AC001
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2014 01:53:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QBeoMARfOtmAHEOZ for <xfs@oss.sgi.com>;
	Sat, 22 Mar 2014 01:53:28 -0700 (PDT)
Date: Sat, 22 Mar 2014 19:53:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20140322085323.GC18572@destitution>
References: <20131106213635.GC24712@redacted.bos.redhat.com>
	<52A72930.4020404@sandeen.net>
	<20140322051205.GB8095@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140322051205.GB8095@redacted.bos.redhat.com>
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
To: Kyle McMartin <kmcmarti@redhat.com>
Cc: sandeen@redhat.com, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sat, Mar 22, 2014 at 01:12:05AM -0400, Kyle McMartin wrote:
> On Tue, Dec 10, 2013 at 08:46:08AM -0600, Eric Sandeen wrote:
> > Hey Kyle - were you going to do a V2 of this one?
> > 
> > Just checking, thanks - 
> 
> i've got a pair of somewhat more substantial patches to fix the ifdef
> hell in this file, clean things up so it works on both getdents64 only
> and not, and then rips out the pre-2.4.1 getdents code.
> 
> https://github.com/jkkm/xfsdump/commit/e156bcf06effbf5f2e26c53efb0ce028c4281f9e
> https://github.com/jkkm/xfsdump/commit/fff56b471220a8fa305b9158c4f8f0c7344c8fe6
> 
> the latter looks quite a bit better... care to take a quick look and if
> they're decent, i'll submit them both.

Please just post the patches. People will comment on them on them
once you post them to the list...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
