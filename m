Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0510C7CA3
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 03:03:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC0F88F8035
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 01:03:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id i30ZpFMWbJC5Njme (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 01:03:29 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 33E6D8F232
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:03:29 +0000 (UTC)
Received: from redhat.com (unused [10.10.51.227] (may be forged))
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5M83PTV029362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 04:03:28 -0400
Date: Wed, 22 Jun 2016 10:03:24 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs_check: process sparse inode chunks correctly
Message-ID: <20160622080324.GG28212@redhat.com>
References: <1466441562-12317-1-git-send-email-bfoster@redhat.com>
	<1466441562-12317-3-git-send-email-bfoster@redhat.com>
	<20160621090153.GB28212@redhat.com>
	<de32a39e-864d-bd4d-8d5d-7a019b8e445f@sandeen.net>
	<20160621232940.GQ12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160621232940.GQ12670@dastard>
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
To: xfs@oss.sgi.com

On Wed, Jun 22, 2016 at 09:29:40AM +1000, Dave Chinner wrote:
> On Tue, Jun 21, 2016 at 08:54:04AM -0500, Eric Sandeen wrote:
> > 
> > 
> > On 6/21/16 4:01 AM, Carlos Maiolino wrote:
> > > On Mon, Jun 20, 2016 at 12:52:42PM -0400, Brian Foster wrote:
> > >> Update the inode btree scanning functions to process sparse inode chunks
> > >> correctly. For filesystems with sparse inode support enabled, process
> > >> each chunk a cluster at a time. Each cluster is checked against the
> > >> inobt record to determine if it is a hole and skipped if so.
> > >>
> > >> Note that since xfs_check is deprecated in favor of xfs_repair,  this
> > >> adds the minimum support necessary to process sparse inode enabled
> > >> filesystems. In other words, this adds no sparse inode specific checks
> > >> or verifications. We only update the inobt scanning functions to extend
> > >> the existing level of verification to sparse inode enabled filesystems
> > >> (e.g., avoid incorrectly tracking sparse regions as inodes). Problems
> > >> or corruptions associated with sparse inode records must be detected and
> > >> recovered via xfs_repair.
> > >>
> > > 
> > > Hi,
> > > 
> > > I'm not quite sure, but a while ago, I thought I've heard some rumors about
> > > deprecating xfs_check, is this true or something that my mind made up for some
> > > weird reason?
> > 
> > Yes, like Brian said above.  ;)
> > 
> > bfc541e xfsprogs: remove xfs_check
> > 12a48f5 xfsprogs: remove xfs_check references from fsck.xfs script & manpage
> > 
> > However, we still run check inside xfs_db in xfstests as an independent
> > verification step:
> > 
> > 187bccd xfstests: Remove dependence of xfs_check script
> > 
> > +# xfs_check script is planned to be deprecated. But, we want to
> > +# be able to invoke "xfs_check" behavior in xfstests in order to
> > +# maintain the current verification levels.
> > +_xfs_check()
> 
> Right - it's a secondary set of code that effectively tells us
> whether repair is detecting all the problems it should. i.e. if
> check fails and repair doesn't, then we've got a bug in repair that
> needs fixing.
> 

Just out of curiosity here, have we hit any case like that for the past few
versions?

> Also, the check code is really just an "addon" to other
> functionality in xfs_db (e.g. blockget) that we have to keep, so
> removing check doesn't really gain us all that much in terms of
> reduced maintenance overhead. So long as we can easily keep check up
> to date with new features I think we shoul dbe keeping it...
> 

Good to know.

Cheers o/

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
