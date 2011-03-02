Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p228MB4W255437 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 02:22:11 -0600
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C74F01D46672
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 00:25:00 -0800 (PST)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id 6FXKBHLTRVuLnSNi
	for <xfs@oss.sgi.com>; Wed, 02 Mar 2011 00:25:00 -0800 (PST)
Received: by wwf26 with SMTP id 26so5525941wwf.32
	for <xfs@oss.sgi.com>; Wed, 02 Mar 2011 00:24:59 -0800 (PST)
Message-ID: <4D6DFDAA.3060006@gmail.com>
Date: Wed, 02 Mar 2011 09:19:54 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Check for immutable flag in fallocate path
References: <4D6221B8.9040303@gmail.com> <20110221124635.GA5525@infradead.org>
	<AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
	<20110227224940.GL2924@thunk.org>
In-Reply-To: <20110227224940.GL2924@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Il 27/02/2011 23:49, Ted Ts'o ha scritto:
> On Mon, Feb 21, 2011 at 05:50:21PM +0100, Marco Stornelli wrote:
>> 2011/2/21 Christoph Hellwig <hch@infradead.org>:
>>> On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
>>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>>
>>>> All fs must check for the immutable flag in their fallocate callback.
>>>> It's possible to have a race condition in this scenario: an application
>>>> open a file in read/write and it does something, meanwhile root set the
>>>> immutable flag on the file, the application at that point can call
>>>> fallocate with success. Only Ocfs2 check for the immutable flag at the
>>>> moment.
>>>
>>> Please add the check in fs/open.c:do_fallocate() so that it covers all
>>> filesystems.
>>>
>>>
>>
>> The check should be done after the fs got the inode mutex lock.
> 
> Why?  None of the other places which check the IMMUTABLE flag do so

I add to my previous response an other point: IMHO each fs should check
for it because after the inclusion of punch hole patch, the fs
can/cannot check for the append-only flag. So XFS (it supports the
"unreserve") should check even for append. I think we don't want to
allow this operation for an append-only file, isn't it? About this point
I'll update and resend my patch.

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
