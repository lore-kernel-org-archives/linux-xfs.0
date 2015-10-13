Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 325947F37
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 19:35:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5931AC006
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 17:35:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	riTFzFIwBI7kKsAP for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 17:35:50 -0700 (PDT)
Date: Tue, 13 Oct 2015 11:35:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs_repair: fix unaligned accesses
Message-ID: <20151013003507.GK27164@dastard>
References: <56181A17.9080503@sandeen.net> <56181AAD.9080505@sandeen.net>
	<20151009200822.GG27982@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151009200822.GG27982@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Oct 09, 2015 at 04:08:22PM -0400, Brian Foster wrote:
> On Fri, Oct 09, 2015 at 02:51:09PM -0500, Eric Sandeen wrote:
> > This fixes some unaligned accesses spotted by libubsan in repair.
> > 
> > See Documentation/unaligned-memory-access.txt in the kernel
> > tree for why these can be a problem.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
....
> > @@ -960,15 +960,17 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
> >  		 * btree, we'd do it right here.  For now, if there's a
> >  		 * problem, we'll bail out and presumably clear the inode.
> >  		 */
> > -		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
> > -			do_warn(_("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
> > -			       (unsigned long long) be64_to_cpu(pp[i]), lino);
> > +		if (!verify_dfsbno(mp, get_unaligned_be64(&pp[i])))  {
> > +			do_warn(
> > +("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
> > +				get_unaligned_be64(&pp[i]), lino);

drops the "_" from the translation string. I'll fix it on commit.

/me can't help but think that a local variable or two would make
this code so much more readable....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
