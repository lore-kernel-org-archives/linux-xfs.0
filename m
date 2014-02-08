Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 77E8C7F3F
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 02:30:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6BFD28F8052
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 00:30:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	i5UBx6qyjrtYtnVk for <xfs@oss.sgi.com>;
	Sat, 08 Feb 2014 00:30:18 -0800 (PST)
Date: Sat, 8 Feb 2014 19:30:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: fix the setting of unaligned directory fields
Message-ID: <20140208083012.GI13647@dastard>
References: <20140207210348.249387765@sgi.com> <20140207223327.GG13647@dastard>
	<52F56891.5020305@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F56891.5020305@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 07, 2014 at 05:13:21PM -0600, Mark Tinguely wrote:
> On 02/07/14 16:33, Dave Chinner wrote:
> >On Fri, Feb 07, 2014 at 04:03:42PM -0600, Mark Tinguely wrote:
> >>@@ -526,16 +527,20 @@ convert_arg(
> >>  		 */
> >>  		*value = strtoll(arg, NULL, 0);
> >
> >If we are touching this code, the return value here should be error
> >checked.
> >
> >xfs_db>  write u3.bmx[0].startblock 3rgfdw
> >u3.bmx[0].startblock = 52776558133248
> 
> hmm, It should stop at 3. I will take a look.

Even if it stops at 3, that's still wrong because it's failed to
process the entire user input....

> >xfs_db>  write u3.bmx[0].startblock x3rgfdw
> >u3.bmx[0].startblock = 0
> >xfs_db>
> >
> >i.e. it accepts garbage rather than erroring out.
> 
> as does all the other writes ...
> xfs_db>  write core.nblocks x3rgfdw
> core.nblocks = 0
> 
> Fixing convert_arg() is beyond the scope of just this patch.

Sure, but I'm not asking you to fix all of convert_args in this
patch, just asking you to do a complete job of fixing the bitval
input processing in this patch.

But, seeing as you've raised that convert_args() has other broken
paths, can you also write new patches to address those issues? It
won't take you long while all this code is fresh in your mind, and
if you do it now it won't get dropped on the floor until somebody
else hits it a couple of years down the track...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
