Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DFD6E7F4E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 21:51:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA8EB8F8050
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 19:51:31 -0800 (PST)
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id APkz3h7EHcgb0S7v (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2013 19:51:30 -0800 (PST)
Date: Tue, 29 Jan 2013 22:51:25 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix possible use-after-free with AIO
Message-ID: <20130130035125.GB25006@thunk.org>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
	<1359502081-20240-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359502081-20240-2-git-send-email-jack@suse.cz>
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

On Wed, Jan 30, 2013 at 12:27:58AM +0100, Jan Kara wrote:
> Running AIO is pinning inode in memory using file reference. Once AIO
> is completed using aio_complete(), file reference is put and inode can
> be freed from memory. So we have to be sure that calling aio_complete()
> is the last thing we do with the inode.
> 
> CC: linux-ext4@vger.kernel.org
> CC: "Theodore Ts'o" <tytso@mit.edu>
> CC: stable@vger.kernel.org
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

I've picked up the ext4 change.  Sorry for not getting to this sooner.

     	       	   		       	   - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
