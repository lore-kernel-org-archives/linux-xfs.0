Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADBEF29DFC
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 09:38:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4DAE5AC002
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 07:38:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id TjmZYU4EtLqRdEYC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 07:38:06 -0700 (PDT)
Date: Mon, 23 Sep 2013 22:37:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH] xfstest/btrfs/001: fix the misuse of subvolume set-default
Message-ID: <20130923143755.GC18072@localhost.localdomain>
References: <1379926049-22135-1-git-send-email-bo.li.liu@oracle.com>
	<20130923131746.GA18681@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130923131746.GA18681@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 23, 2013 at 09:17:46AM -0400, Josef Bacik wrote:
> On Mon, Sep 23, 2013 at 04:47:29PM +0800, Liu Bo wrote:
> > The command is
> > btrfs subvolume set-default <subvolid> <path>.
> > 
> > It uses @subvolid to control the default subvolume and
> > @subvolid=0 has always been parsed into FS_TREE no matter
> > what subvolume @path points to.
> > 
> > So in order to set a subvolume to the default one, we need
> > to get the id of this subvolume first.
> > 
> > Also fix a typo:
> > s/sbuvolid/subvolid/g
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Sent a patch for this already.  Thanks,

oops, sorry I should have noticed that, any chance to fold the typo fix
into your patch?

-liubo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
