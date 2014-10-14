Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3144F7F3F
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 10:34:47 -0500 (CDT)
Date: Tue, 14 Oct 2014 10:34:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 08/16] xfs: change interface of xfs_nameops.hashname
Message-ID: <20141014153446.GB2199@sgi.com>
References: <20141003214758.GY1865@sgi.com> <20141003215844.GG1865@sgi.com>
	<20141006221708.GI2301@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141006221708.GI2301@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Tue, Oct 07, 2014 at 09:17:08AM +1100, Dave Chinner wrote:
> On Fri, Oct 03, 2014 at 04:58:44PM -0500, Ben Myers wrote:
> > From: Olaf Weber <olaf@sgi.com>
> > 
> > With the introduction of the xfs_nameops.normhash callout, all uses of the
> > hashname callout now occur in places where an xfs_name structure must be
> > explicitly created just to match the parameter passing convention of this
> > callout. Change the arguments to a const unsigned char * and int instead.
> > 
> > Signed-off-by: Olaf Weber <olaf@sgi.com>
> > 
> > [v2: pass a 3rd argument for sb_utf8version to hashname.  --bpm]
> 
> So now I've looked at most of the rest of the patch set, I think
> this is the wrong thing to do. I see no reason apart from "it's less
> typing" to drop the use of the xfs-name structure, but it removes a
> key piece of documentation from the code. i.e. that the name/namelen
> are an inseparable tuple and cannot be separated. Indeed, lots of
> the utf8 xfs code declares norm/normlen tuples on the stack for
> temporary use, so really this comes down to a matter of taste.
> 
> And in that matter, I'd prefer that we keep the existing name
> abstaction and propagate it into the new code rather than the other
> way around.

Does something like this suit you?

struct xfs_name {
	const unsigned char	*name;
	int			len;
	int			type;
	__uint32_t		utf8version;
};

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
