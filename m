Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8MaP3B029326 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 16:36:25 -0600
Date: Thu, 8 Nov 2012 16:38:24 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v6 00/10] speculative preallocation inode tracking
Message-ID: <20121108223824.GQ9783@sgi.com>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hey Brian,

On Tue, Nov 06, 2012 at 09:50:37AM -0500, Brian Foster wrote:
> Hi all,
> 
> Sorry for the delay. Here is v6 of the speculative prealloc tracking patchset.
> The first 5 patches are basically unchanged, the xfs_quota_type() patch is
> dropped and the subsequent patches have been reworked to gear the eofblocks
> ioctl() to filter based on inode ID's rather than being quota-centric, related to
> the following discussion:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00439.html
> 
> My initial intent was to leave the ability to filter on multiple ID's
> concurrently as a follow-on change, but it seemed relatively straightforward as I
> was hacking on this so I included it in this set (patch 8). It is included as a
> standalone patch so I can leave it or drop it if necessary.
> 
> This set has been tested via xfstests with debug on and off with no obvious
> regressions and sanity tested via Dave's xfs_spaceman tool and the prealloc add-on
> (which I will post an update for as well).

committed to git://oss.sgi.com/xfs/xfs.git, master and for-next branches.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
