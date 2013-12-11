Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EDCC27F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 13:36:26 -0600 (CST)
Date: Wed, 11 Dec 2013 13:36:22 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: return ENOSPC when trying to set more ACLs than
	XFS_ACL_MAX_ENTRIES
Message-ID: <20131211193622.GG1935@sgi.com>
References: <52921D12.7040104@oracle.com> <5292C557.9020008@sandeen.net>
	<5292D8AB.5080003@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5292D8AB.5080003@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hey Jeff,

On Mon, Nov 25, 2013 at 12:57:15PM +0800, Jeff Liu wrote:
> 
> On 11/25 2013 11:34 AM, Eric Sandeen wrote:
> > On 11/24/13, 9:36 AM, Jeff Liu wrote:
> >> From: Jie Liu <jeff.liu@oracle.com>
> >>
> >> We currently return EINVAL when trying to set more ACL entries than
> >> XFS_ACL_MAX_ENTRIES(), but it would be a bit more meaningful to return
> >> ENOSPC in this situation, because the later is used to indicate there
> >> is no more space to store new ACLs IMHO.
> > 
> > I'm not quite convinced that it's better; the user will get an
> > error string of "no space left on device" which is misleading too,
> I admit that both looks misleading...
> > and I'd argue that it's no better than "invalid argument."
> > 
> > To me, I think it's not worth changing, but others may disagree.
> > 
> > (I guess looking at ext4, it uses ENOSPC for some similar constraints,
> > so maybe three is precedent for this)
> Btrfs also uses ENOSPC, but JFS would return something like "Argument list too long"
> in this case.

I tend to agree with Eric on this one, but if Dave or Christoph want to weigh
in that's cool.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
