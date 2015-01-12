Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 327967F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 06:46:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1DEC5304048
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 04:46:39 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id cpQJBYX6Uqhc1tVo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2015 04:46:37 -0800 (PST)
Date: Mon, 12 Jan 2015 13:46:35 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/18] nfsd: pNFS block layout driver
Message-ID: <20150112124635.GB29681@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-15-git-send-email-hch@lst.de>
	<20150112061419.GB107426@slacker.internal.excfb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150112061419.GB107426@slacker.internal.excfb.com>
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
To: Tom Haynes <thomas.haynes@primarydata.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Mon, Jan 12, 2015 at 01:14:19AM -0500, Tom Haynes wrote:
> 
> > +file system must sit on shared storage (typically iSCSI) that is accessible
> > +to the clients as well as the server.  The file system needs to either sit
> > +directly on the exported volume, or on a RAID 0 using the MD software RAID
> 
> a RAID 0 what?

I don't quite understand that comment.  But I'll have to revise that
text anyway as the RAID0/1 support isn't part of this submission yet,
as it needs a little more work and involves two more subsystems.

For those who are curious about the md support, it is available at:

	git://git.infradead.org/users/hch/pnfs.git pnfsd-block-md-support


> What reclaims bex in both error cases??
> 
> The call flow seems to be:
> 
> nfsd4_proc_compound -> nfsd4_layoutget -> nfsd4_block_proc_layoutget
> 
> lg_content gets freed in nfsd4_encode_layoutget() in all paths.
> 
> nfsd4_encode_operation() calls nfsd4_encode_layoutget().
> 
> But nfsd4_encode_layoutget() is not called in all paths:
> 
>         p = xdr_reserve_space(xdr, 8);
>         if (!p) {
>                 WARN_ON_ONCE(1);
>                 return;  // leak
>         }
> ...
>         if (op->opnum == OP_ILLEGAL)
>                 goto status;  // Not really a leak, if we hit this, bigger issues apply.
> 
> So bex is correctly accounted for, but in general
> nfsd4_encode_operation() can leak any operation
> specific memory.

I guess we need to fix properly in the nfsd core eventually.  For
example by adding a new method called for successful and error completions
that can free all ressources.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
