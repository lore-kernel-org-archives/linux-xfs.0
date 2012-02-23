Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1NJcSvw142964 for <xfs@oss.sgi.com>; Thu, 23 Feb 2012 13:38:29 -0600
Received: from millhouse.houseofnate.net
	(dsl092-086-237.bos1.dsl.speakeasy.net [66.92.86.237]) by
	cuda.sgi.com with ESMTP id 0SDHajVAW60jAToT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Feb 2012 11:38:26 -0800 (PST)
Message-ID: <4F4695B1.4060202@houseofnate.net>
Date: Thu, 23 Feb 2012 14:38:25 -0500
From: "Nathaniel W. Turner" <nate@houseofnate.net>
MIME-Version: 1.0
Subject: Re: XFS, empty files after a crash
References: <4F4387A7.2070009@gmail.com>
	<20291.50554.414722.399249@tree.ty.sabi.co.UK>
	<4F445E9F.5030003@sandeen.net>
In-Reply-To: <4F445E9F.5030003@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 02/21/2012 10:18 PM, Eric Sandeen wrote:
> I'd agree that there is likely nothing to recover; there are no extents 
> allocated. I'm not sure why du is reporting space used though.

I have noticed that xfs_bmap (which uses the ioctl bmap interface) will not 
report extents after EOF.  There probably *are* extents allocated to this file, 
but they are not being reported by xfs_bmap.

kfx, try getting the inode number of the file (via stat or ls -i) and then 
doing something like this:

xfs_db -r $DEV -c "inode $INO" -c "bmap"

This will dump the entire extent map, and I suspect you'll see at least one extent.

nate


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
