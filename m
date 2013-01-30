Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FA967F4E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 18:57:00 -0600 (CST)
Date: Tue, 29 Jan 2013 18:56:56 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/4] xfs: Fix possible use-after-free with AIO
Message-ID: <20130130005656.GM27055@sgi.com>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
	<1359502081-20240-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359502081-20240-3-git-send-email-jack@suse.cz>
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
Cc: stable@vger.kernel.org, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Jan,

On Wed, Jan 30, 2013 at 12:27:59AM +0100, Jan Kara wrote:
> Running AIO is pinning inode in memory using file reference. Once AIO
> is completed using aio_complete(), file reference is put and inode can
> be freed from memory. So we have to be sure that calling aio_complete()
> is the last thing we do with the inode.
> 
> CC: xfs@oss.sgi.com
> CC: Ben Myers <bpm@sgi.com>
> CC: stable@vger.kernel.org
> Reviewed-by: Ben Myers <bpm@sgi.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

We picked this up in the xfs tree.  Sorry to keep you hanging.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
