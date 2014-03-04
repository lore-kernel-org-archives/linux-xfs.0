Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A5CB7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 07:04:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1EEEF304043
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 05:04:20 -0800 (PST)
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id DHbxrkEsnFVWp56b for
	<xfs@oss.sgi.com>; Tue, 04 Mar 2014 05:04:19 -0800 (PST)
Subject: Re: [PATCH] xfsprogs: fix use after free in inode_item_done()
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <531506BD.80209@redhat.com>
References: <5314E912.9080708@redhat.com> <20140303223617.GL13647@dastard>
	<531506BD.80209@redhat.com>
Date: Tue, 04 Mar 2014 13:04:17 +0000
Message-Id: <1393938257.8455.6.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>


On Mon, 2014-03-03 at 16:48 -0600, Eric Sandeen wrote:
> On 3/3/14, 4:36 PM, Dave Chinner wrote:
...
> > which leaves the rest of the ili_done: code looking a little
> > strange.
> > 
> > can you convert that now to be:
> > 
> > ili_done:
> > 	if (iip->ili_lock_flags) {
> > 		iip->ili_lock_flags = 0;
> > 		return;
> > 	}
> > 	/* free the inode */
> > 	libxfs_iput(ip, 0);
> > }
> 
> yeah, I actually had that first.  Not sure why I didn't go with it ;)
> 
> (Still looks strange to my untrained eye; "if lock flags are set, unset them and don't free the inode, otherwise free it")
> 

I'd be tempted to write:

ili_done:
	if (iip->ili_lock_flags == 0) /* don't return locked inode */
		libxfs_iput(ip, 0);

	iip->ili_lock_flags = 0;

-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
