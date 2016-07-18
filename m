Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95D7D7CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 00:37:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68F438F8033
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2016 22:37:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jXDoHNuadbZRVvND for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2016 22:37:49 -0700 (PDT)
Date: Mon, 18 Jul 2016 15:37:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: remove __arch_pack
Message-ID: <20160718053746.GA16044@dastard>
References: <1466754767-10657-1-git-send-email-hch@lst.de>
	<1466754767-10657-4-git-send-email-hch@lst.de>
	<478743f8-774f-d363-2e3e-40cd0963d8a1@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <478743f8-774f-d363-2e3e-40cd0963d8a1@sandeen.net>
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

On Fri, Jun 24, 2016 at 09:55:37AM -0500, Eric Sandeen wrote:
> On 6/24/16 2:52 AM, Christoph Hellwig wrote:
> > Instead we always declare struct xfs_dir2_sf_hdr as packed.  That's
> > the expected layout, and while most major architectures do the packing
> > by default the new structure size and offset checker showed that not
> > only the ARM old ABI got this wrong, but various minor embedded
> > architectures did as well.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_da_format.h | 2 +-
> >  fs/xfs/xfs_linux.h            | 7 -------
> >  2 files changed, 1 insertion(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> > index f877bb1..685f23b 100644
> > --- a/fs/xfs/libxfs/xfs_da_format.h
> > +++ b/fs/xfs/libxfs/xfs_da_format.h
> > @@ -229,7 +229,7 @@ typedef struct xfs_dir2_sf_hdr {
> >  	__uint8_t		count;		/* count of entries */
> >  	__uint8_t		i8count;	/* count of 8-byte inode #s */
> >  	__uint8_t		parent[8];	/* parent dir inode number */
> > -} __arch_pack xfs_dir2_sf_hdr_t;
> > +} __packed xfs_dir2_sf_hdr_t;
> 
> The reason I did this in the first place was a vague notion that unconditional
> packing was harmful.
> 
> http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/
> 
> "However, it's actively harmful to add the attribute to a structure that's
> already going to be laid out with no padding."
> ...
> "gcc gets scared about unaligned accesses and generates six times as much code
> (96 bytes vs. 16 bytes)! sparc64 goes similarly crazy, bloating from 12 bytes
> to 52 bytes"
> 
> I don't know if that's (still) correct or not, but that was the reason
> for the selective __pack application way back when.  Might be worth
> investigating?

Christoph? The first two ptches are fine, but more info is needed
for this one...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
