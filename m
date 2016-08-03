Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA7D27CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 12:37:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90930304039
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 10:37:22 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id zmetq9xkYjjJDJLl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 10:37:19 -0700 (PDT)
Date: Wed, 3 Aug 2016 18:37:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2 RESEND] fs: return EPERM on immutable inode
Message-ID: <20160803173712.GJ2356@ZenIV.linux.org.uk>
References: <1470139108-13115-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470139108-13115-1-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, "open list:GFS2 FILE SYSTEM" <cluster-devel@redhat.com>, Bob Peterson <rpeterso@redhat.com>, linux-fsdevel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>

On Tue, Aug 02, 2016 at 07:58:28PM +0800, Eryu Guan wrote:
> In most cases, EPERM is returned on immutable inode, and there're only a
> few places returning EACCES. I noticed this when running LTP on
> overlayfs, setxattr03 failed due to unexpected EACCES on immutable
> inode.
> 
> So converting all EACCES to EPERM on immutable inode.
> 
> Acked-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
