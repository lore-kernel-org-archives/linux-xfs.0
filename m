Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3F07DSv111164 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 19:07:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0C972C34FA
	for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 17:09:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	NBQBwQz1nXQzBWWm for <xfs@oss.sgi.com>;
	Wed, 14 Apr 2010 17:09:07 -0700 (PDT)
Date: Thu, 15 Apr 2010 10:09:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 9/10] xfs: a few more minor xfs_log_recover.c cleanups
Message-ID: <20100415000904.GN2493@dastard>
References: <1270852266.7840.159.camel@doink> <20100412071131.GK2493@dastard>
	<1271279952.3559.81.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271279952.3559.81.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 14, 2010 at 04:19:12PM -0500, Alex Elder wrote:
> On Mon, 2010-04-12 at 17:11 +1000, Dave Chinner wrote:
> > On Fri, Apr 09, 2010 at 05:31:06PM -0500, Alex Elder wrote:
> > > - Add a more descriptive header comment for xlog_find_verify_cycle().
> > 
> > It just describes what the code does - I don't think it make the
> > code any clearer and makes it more likely that if we ever change the
> > code the comment will then be wrong...
> 
> I still think the existing comments are confusing.  What do you
> think of this instead:
> 
> /*
>  * Check that the range of blocks does not contain stop_on_cycle_no.
>  * Fill in *new_blk with the block offset where such block is found,
>  * or with -1 (an invalid block number) if there is no such block in
>  * the range.  The scan needs to occur from front to back and the
>  * pointer into the region must be updated since a later routine will
>  * need to perform another test.  
>  */

Yup, that's much better ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
