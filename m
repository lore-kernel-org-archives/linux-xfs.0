Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 481087F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 15:35:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4D11AC004
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 13:35:31 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	boFTvekM2fp3Eh2M for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 13:35:29 -0800 (PST)
Date: Wed, 4 Mar 2015 08:34:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: Correctly lock inode when removing suid and
	security marks
Message-ID: <20150303213450.GT4251@dastard>
References: <1425379119-3773-1-git-send-email-jack@suse.cz>
	<1425379119-3773-6-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1425379119-3773-6-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, xfs@oss.sgi.com

On Tue, Mar 03, 2015 at 11:38:39AM +0100, Jan Kara wrote:
> Currently XFS calls file_remove_privs() without holding i_mutex. This is
> wrong because that function can end up messing with file permissions and
> security xattrs for which we need i_mutex held.
> 
> Fix the problem by grabbing iolock exclusively when we will need to
> change anything in permissions / xattrs.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
