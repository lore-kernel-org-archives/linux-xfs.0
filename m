Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 333C57F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:59:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD80BAC001
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:59:50 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tGEGbRhY4Qp2NtmT for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 21:59:48 -0800 (PST)
Date: Thu, 3 Dec 2015 16:59:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] xfsprogs: xfs_mdrestore: check bad read count in
	perform_restore
Message-ID: <20151203055934.GV26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-6-git-send-email-t.vivek@samsung.com>
	<565FCAFB.5020502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565FCAFB.5020502@sandeen.net>
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

On Wed, Dec 02, 2015 at 10:54:19PM -0600, Eric Sandeen wrote:
> On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> > fix error reported by coverity - Integer overflowed argument
> > 
> > also, add print incase of invalid read count to get more debug
> > information.
> > 
> > Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> > ---
> >  mdrestore/xfs_mdrestore.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> > index 5764616..a87a091 100644
> > --- a/mdrestore/xfs_mdrestore.c
> > +++ b/mdrestore/xfs_mdrestore.c
> > @@ -93,6 +93,10 @@ perform_restore(
> >  	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
> >  	block_buffer = (char *)metablock + block_size;
> >  
> > +	if (block_size < sizeof(tmb))
> > +		fatal("bad read count, block_size: %d, tmb size %d\n",
> > +				block_size, sizeof(tmb));
> > +
> 
> block_size is block_size = 1 << tmb.mb_blocklog; where mb_blocklog is
> always metablock->mb_blocklog = BBSHIFT;, so block_size is always 512.
> 
> On the other hand, sizeof(tmb) is simply 8.
> 
> There seems to be no possible path for this to be a problem, so it hardly
> seems worth the printf.
> 
> Would an ASSERT(block_size >= sizeof(tmb)) make coverity happy?

Just ignoring this coverity warning would be more appropriate, i
think.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
