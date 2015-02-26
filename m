Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB9E27F47
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 07:31:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 99F548F8049
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2015 05:31:20 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id wcoQU3sUcXT8egWt (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Feb 2015 05:31:17 -0800 (PST)
Date: Thu, 26 Feb 2015 08:31:13 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Documenting MS_LAZYTIME
Message-ID: <20150226133113.GD11217@thunk.org>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
	<54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org>
	<54EEDE23.6080009@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54EEDE23.6080009@gmail.com>
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

On Thu, Feb 26, 2015 at 09:49:39AM +0100, Michael Kerrisk (man-pages) wrote:
> > How about somethign like "This mount significantly reduces writes
> > needed to update the inode's timestamps, especially mtime and actime.
> 
> What is "actime" in the preceding line? Should it be "ctime"?

Sorry, no, it should be "atime".

> I find the wording of there a little confusing. Is the following 
> a correct rewrite:
> 
>     The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat(2)
>     will return the correctly updated atime, but the atime updates
>     will be flushed to disk only when (1) the inode needs to be 
>     updated for filesystem / data consistency reasons or (2) the 
>     inode is pushed out of memory, or (3) the filesystem is 
>     unmounted.)

Yes, that's correct.  The only other thing I might add is that in the
case of a crash, the atime (or mtime) fields on disk might be out of
date by at most 24 hours.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
