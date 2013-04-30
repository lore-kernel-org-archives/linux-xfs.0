Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 211827F52
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 13:36:49 -0500 (CDT)
Date: Tue, 30 Apr 2013 13:36:47 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20130430183647.GF812@sgi.com>
References: <20130429112943.afdd088c7bb8d80046bdfd2f@canb.auug.org.au>
	<20130429014002.GY10481@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130429014002.GY10481@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hey Stephen and Dave,

On Mon, Apr 29, 2013 at 11:40:02AM +1000, Dave Chinner wrote:
> On Mon, Apr 29, 2013 at 11:29:43AM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the xfs tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > ERROR: "xfs_dquot_buf_ops" [fs/xfs/xfs.ko] undefined!
> > 
> > Probably caused by commit 3fe58f30b4fc ("xfs: add CRC checks for quota
> > blocks").
> > 
> > I have used the xfs tree from next-20130426 for today.
> 
> CONFIG_XFS_QUOTA=y will fix it.
> 
> Or, alternatively, apply this patch:
> 
> http://oss.sgi.com/pipermail/xfs/2013-April/025434.html

I applied this patch so it should be fixed today.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
