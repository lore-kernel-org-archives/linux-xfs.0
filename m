Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qABMbkTH175150 for <xfs@oss.sgi.com>; Sun, 11 Nov 2012 16:37:46 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fiYsOXUuRIxhLfKd for <xfs@oss.sgi.com>;
	Sun, 11 Nov 2012 14:39:46 -0800 (PST)
Date: Mon, 12 Nov 2012 09:39:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
Message-ID: <20121111223944.GN24575@dastard>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
	<20121101225938.GS29378@dastard>
	<CABJyUz+VhUY=tVKpEeKXfQRoaL4s+gwNmRr4wNAnRX6zTt5xXg@mail.gmail.com>
	<CABJyUz+r7yQSswqyBng_W=fAXxTz9heb88NeiKSeFU7j4ZD=Hw@mail.gmail.com>
	<20121108210210.GP6434@dastard>
	<CABJyUzKy4YXVZAj=awVNfPD69eWo2mKhM7a-xWF1Vy-PD989sg@mail.gmail.com>
	<20121109104839.GE6434@dastard>
	<CABJyUzJVj-rpGW=i5QG=AZPvhuD-qdbujuwOdu_EdGbYGZ++Rg@mail.gmail.com>
	<CABJyUzJ7maOcj+aPkpCvBc1-P+Z-XPsft8rbsVnqgpfyVCs9xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABJyUzJ7maOcj+aPkpCvBc1-P+Z-XPsft8rbsVnqgpfyVCs9xQ@mail.gmail.com>
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
To: Aaron Goulding <aarongldng@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Nov 10, 2012 at 11:08:23PM -0800, Aaron Goulding wrote:
> As I guessed, xfs_repair didn't work. xfs_db does now load with warnings,
> but I fear I don't know enough about that to properly use that tool. I've
> done a search for xfs_irepair but I'm finding very little from that. Where
> is that tool located? I'm understanding a full restore is very unlikely at
> this point, but if I can get anything, I'll consider this project a success
> and a learning experience. :)

xfs_irecover:

http://oss.sgi.com/archives/xfs/2008-12/msg01782.html

current location:

http://inai.de/projects/hxtools/

You might need to hack it to recovery full files (ISTR is ignore
files larger than a certain size), but tools lke this are your best
bet now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
