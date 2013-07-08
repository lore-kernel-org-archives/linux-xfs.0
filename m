Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 94E0C7F51
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 16:30:05 -0500 (CDT)
Date: Mon, 8 Jul 2013 16:30:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: make fs for 274 larger
Message-ID: <20130708213001.GJ20932@sgi.com>
References: <1371846670-21882-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371846670-21882-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 21, 2013 at 04:31:10PM -0400, Josef Bacik wrote:
> Btrfs will default to mixed block groups for 1 gigabyte file systems and
> smaller, which means data and metadata share the same area.  This makes
> generic/274 fail for us because we cannot reserve enough metadata space to do
> our writes.  Bumping the scratch fs up to 2 gigabytes allows us to do our normal
> metadata/data seperation and allows us to pass this test.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

XFS and ext4 still passed with this patch.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
