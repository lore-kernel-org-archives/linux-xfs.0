Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9AD0B7F58
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 01:57:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C9CB8F8070
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 23:57:28 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id zfhsVNCHAzozVcxm (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 23:57:25 -0800 (PST)
Date: Fri, 20 Feb 2015 21:56:36 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Documenting MS_LAZYTIME
Message-ID: <20150221025636.GB7922@thunk.org>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
	<54E7578E.4090809@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54E7578E.4090809@redhat.com>
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
Cc: linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

On Fri, Feb 20, 2015 at 09:49:34AM -0600, Eric Sandeen wrote:
> 
> >               This mount option significantly reduces  writes  to  the
> >               inode  table  for workloads that perform frequent random
> >               writes to preallocated files.
> 
> This seems like an overly specific description of a single workload out
> of many which may benefit, but what do others think?  "inode table" is also
> fairly extN-specific.

How about somethign like "This mount significantly reduces writes
needed to update the inode's timestamps, especially mtime and actime.
Examples of workloads where this could be a large win include frequent
random writes to preallocated files, as well as cases where the
MS_STRICTATIME mount option is enabled."?

(The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat system
calls will return the correctly updated atime, but those atime updates
won't get flushed to disk unless the inode needs to be updated for
file system / data consistency reasons, or when the inode is pushed
out of memory, or when the file system is unmounted.)

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
