Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 232D429DF7
	for <xfs@oss.sgi.com>; Sat, 15 Mar 2014 22:28:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C03C8F8039
	for <xfs@oss.sgi.com>; Sat, 15 Mar 2014 20:28:05 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id Z8DQD2EeHDPaSjKS (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Mar 2014 20:28:01 -0700 (PDT)
Date: Sat, 15 Mar 2014 23:27:56 -0400
From: tytso@mit.edu
Subject: Re: [PATCH 1/6 v2] ext4: Update inode i_size after the preallocation
Message-ID: <20140316032756.GA31988@thunk.org>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
	<1393355679-11160-2-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355679-11160-2-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 08:14:34PM +0100, Lukas Czerner wrote:
> Currently in ext4_fallocate we would update inode size, c_time and sync
> the file with every partial allocation which is entirely unnecessary. It
> is true that if the crash happens in the middle of truncate we might end
> up with unchanged i size, or c_time which I do not think is really a
> problem - it does not mean file system corruption in any way. Note that
> xfs is doing things the same way e.g. update all of the mentioned after
> the allocation is done.
> 
> This commit moves all the updates after the allocation is done. In
> addition we also need to change m_time as not only inode has been change
> bot also data regions might have changed (unwritten extents). However
> m_time will be only updated when i_size changed.
> 
> Also we do not need to be paranoid about changing the c_time only if the
> actual allocation have happened, we can change it even if we try to
> allocate only to find out that there are already block allocated. It's
> not really a big deal and it will save us some additional complexity.
> 
> Also use ext4_debug, instead of ext4_warning in #ifdef EXT4FS_DEBUG
> section.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
