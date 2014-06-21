Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 900CF7F3F
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2014 19:13:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8598430408A
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2014 17:13:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SeADf0wJLm3v1B1v for <xfs@oss.sgi.com>;
	Fri, 20 Jun 2014 17:13:51 -0700 (PDT)
Date: Sat, 21 Jun 2014 10:13:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] repair: support more than 25 ACLs
Message-ID: <20140621001348.GV9508@dastard>
References: <1403156032-18525-1-git-send-email-david@fromorbit.com>
	<1403156032-18525-2-git-send-email-david@fromorbit.com>
	<20140619130144.GA9043@bfoster.bfoster>
	<20140619211414.GS9508@dastard>
	<20140620121425.GA47159@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140620121425.GA47159@bfoster.bfoster>
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
Cc: xfs@oss.sgi.com

On Fri, Jun 20, 2014 at 08:14:26AM -0400, Brian Foster wrote:
> On Fri, Jun 20, 2014 at 07:14:14AM +1000, Dave Chinner wrote:
> > On Thu, Jun 19, 2014 at 09:01:45AM -0400, Brian Foster wrote:
> > > On Thu, Jun 19, 2014 at 03:33:51PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > v5 superblock supports many more than 25 ACLs on an inode, but
> > > > xfs_repair still thinks that the maximum is 25. Fix it and update
> > > > the ACL definitions to match the kernel definitions. Also fix the
> > > > remote attr maximum size off-by-one that the maximum number of v5
> > > > ACLs tickles.
> > > > 
> > > > Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > 
> ...
> > 
> > > > @@ -1624,7 +1639,16 @@ xfs_acl_from_disk(struct xfs_acl **aclp, struct xfs_acl_disk *dacl)
> > > >  
> > > >  
> > > >  	end = &dacl->acl_entry[0] + count;
> > > > -	acl = malloc((int)((char *)end - (char *)dacl));
> > > > +	size = sizeof(dacl->acl_cnt) + (count * sizeof(struct xfs_acl_entry));
> > > > +	if (size != (int)((char *)end - (char *)dacl)) {
> > > > +		do_warn(_("ACL count (%d) does not match buffer size (%d/%d)\n"),
> > > > +			  count, size, (int)((char *)end - (char *)dacl));
> > > > +		*aclp = NULL;
> > > > +		return EINVAL;
> > > > +	}
> > > 
> > > This size check seems superfluous. In what scenario could it fail?
> > 
> > Kernel writes a corrupted ACL? Cosmic ray causes a single bit error
> > in a sector on a non-crc filesystem? We do checks like these on
> > variable size structures in many other places - not just ACLs - for
> > verifying internal consistency of the structure we are parsing....
> > 
> 
> Hmm, but what exactly are we checking for in this particular instance?
> end is calculated as the offset of the first entry in struct xfs_acl
> (constant) plus count * the entry structure size (variable * constant).
> size is calculated as the size of the non-entry bit of xfs_acl
> (constant) plus count * the entry structure size. The only variable
> between the two calculations is count, and it's used in both. It seems
> like these would always end up equivalent, regardless of what's on disk.

Ah, right, I see your point now. The old code used a fixed size
structure (i.e. with an array of 25 ACLs in it). Hence the check was
valid for that case, where a corrupted count could result in a
structure overrun.

> The only way I can see this fail is if we were to add a field to
> xfs_acl.

Actually, the old code did have a bug like this in it because the
structure repair defined had different sizes on 32 and 64 bit
machines. i.e. it didn't have the 4 bytes of padding the kernel
structure had...

> The end calculation will inherit the size of the field by
> virtue of using the entry offset at the end of the structure. The size
> calculation would end up wrong as it checks the non-entry field size
> explicitly. I'm not sure what that would tell us beyond the need to fix
> this particular bit of code, so this really just seems like a potential
> bug to me. Am I missing something else? (If so, I'd suggest a more
> informative error message or a comment).

No, I just misunderstood your comment. You are right, the code
doesn't provide any value now, so I'll remove it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
