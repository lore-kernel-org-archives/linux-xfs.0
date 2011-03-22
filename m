Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2MJRKTa045569 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 14:27:26 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 482E5AC010
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 12:30:15 -0700 (PDT)
Subject: Re: [PATCH] xfstests: ensure selinux xattrs don't interfere with
	quota tests
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D83B2D0.1030607@redhat.com>
References: <4D83B2D0.1030607@redhat.com>
Date: Tue, 22 Mar 2011 14:30:07 -0500
Message-ID: <1300822207.2875.23.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, 2011-03-18 at 14:30 -0500, Eric Sandeen wrote:
> 219 and 235 were failing on ext3 with selinux, because the extra
> xattrs upped the quota usage.
> 
> Do the same trick we've used in the past to mount with an selinux
> global context when doing quota tests.
> 
> Note the gross hack for remount,ro, though.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

My only suggestion would be to define the value of
the security context using a variable, so it's
easier to see that the thing you're editing out of
/etc/mtab is identical to the thing that was
supplied as a mount option.  I.e., define
    MOUNT_CONTEXT="system_u:object_r:nfs_t:s0"
and use it in the two spots elsewhere.

But even if you don't take that suggestion this
looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
