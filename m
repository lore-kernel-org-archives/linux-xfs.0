Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5011F7FC7
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 08:28:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C74D304051
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 06:28:33 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id xu0FfnEuIDRRN1CE for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 06:28:32 -0800 (PST)
Date: Mon, 2 Feb 2015 09:28:32 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 10/20] nfsd: implement pNFS operations
Message-ID: <20150202142832.GC22301@fieldses.org>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-11-git-send-email-hch@lst.de>
	<20150129203346.GA11064@fieldses.org>
	<20150202124349.GA15598@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202124349.GA15598@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Mon, Feb 02, 2015 at 01:43:49PM +0100, Christoph Hellwig wrote:
> On Thu, Jan 29, 2015 at 03:33:46PM -0500, J. Bruce Fields wrote:
> > Is there no old_stateid case for layout stateids?  And is there any
> > chance of wraparound?  (I was comparing to check_stateid_generation and
> > expecting the only difference to be the handling of the generation-zero
> > case.)
> 
> 12.5.3. explicitly mentions that LAYOUTGET and LAYOUTRETURN might be
> outstading and processed in parallel, and sais that pNFS operations
> use special stateid rules.  It does not explicitly say that old stateids
> are ok, but the model described in there very much requires the server
> to not reject them.
> 
> > > +static inline u64
> > > +layout_end(struct nfsd4_layout_seg *seg)
> > > +{
> > > +	u64 end = seg->offset + seg->length;
> > > +	return end >= seg->offset ? seg->length : NFS4_MAX_UINT64;
> > 
> > Shouldn't that be
> > 
> > 	return end >= seg->offset ? end : NFS_MAX_UINT64;
> > 
> > ?
> 
> Yes.  This is an interesting one that sneaked in, and it turns out
> besides dislabling layout merging it didn't have adverse effects.
> 
> > > +}
> > > +
> > > +static void
> > > +layout_update_len(struct nfsd4_layout_seg *lo, u64 end)
> > > +{
> > > +	if (end == NFS4_MAX_UINT64)
> > > +		lo->length = NFS4_MAX_UINT64;
> > 
> > Is this case necessary?
> > 
> > > +	else
> > > +		lo->length = end - lo->offset;
> 
> 
> We use NFS4_MAX_UINT64 as a magic value for layouts until the
> field end, as specified in the standard.  But because we do all
> kinds of calculations using the end value we need to propagate
> that magic from and to it.
> 
> > Should any of these have OP_MODIFIES_SOMETHING set?  (Basically: would
> > we be in trouble if we succesfully completed one of these operations and
> > then weren't able to encode the result?)
> 
> All but GETDEVICEINFO should get it.
> 
> I've implemented all your suggested changes and will send out and update
> after doing a little more testing.

Thanks!

I didn't notice anything that looked like a big problem to me, so absent
any objections I'll commit the revised versions for 3.20 once we figure
out how to handle the xfs stuff.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
