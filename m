Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0FAgCU1002996 for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 04:42:12 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1AA5AC003
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 02:42:05 -0800 (PST)
Date: Thu, 15 Jan 2009 04:48:15 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH] xfsprogs: allow xfs_freeze to work on non-xfs filesystems
Message-ID: <20090115104815.GA21591@sgi.com>
References: <496E6FB4.8070300@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <496E6FB4.8070300@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@sgi.com>

On Wed, Jan 14, 2009 at 05:05:24PM -0600, Eric Sandeen wrote:
| allow xfs_freeze to freeze "foreign" filesystems
| 
| Now that the freeze ioctl has been elevated to the VFS,
| let's let xfs_io and xfs_freeze freeze other filesystems
| as well - add the CMD_FOREIGN_OK flag to freeze & thaw.
| 
| I think the worst that will happen on older kernels is that
| the command will fail with ENOSYS or EINVAL....
| 
| Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
| ---
                                                                  
Reviewed-by: Bill O'Donnell <billodo@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
