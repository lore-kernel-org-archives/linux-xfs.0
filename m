Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9AFD67F61
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 18:47:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28293AC001
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 16:47:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0VY6tSBQ3eXT60oI for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 16:47:09 -0700 (PDT)
Date: Wed, 30 Jul 2014 09:46:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Is jdm_delete_filehandle part of a public API?
Message-ID: <20140729234655.GK26465@dastard>
References: <53D7DA7F.2040706@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53D7DA7F.2040706@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 29, 2014 at 12:31:43PM -0500, Eric Sandeen wrote:
> I was cleaning up xfsprogs to plug some leaks, and wanted to use
> jdm_delete_filehandle().  I noticed that it has an "hlen" argument which
> is unused.
> 
> Can we remove that, or is this part of a public API?  It's not in any
> manpage (or even called anywhere in xfsprogs/xfstests/xfsdump/dmapi)
> but it is in a public header...

Which means it is part of the published API, regardless of whether
it is documented in the man page or not.

As it is, we've never really cared about ABI stability for these
libraries - I don't think we've ever guaranteed stability in any
way. If you want to change it, though, I suspect we'll need to bump
the library version....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
