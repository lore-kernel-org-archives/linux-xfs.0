Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 821297F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 14:56:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 612CA8F8039
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 12:56:08 -0800 (PST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id lUIzqGlh4FInayCy
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 12:56:05 -0800 (PST)
Received: by wmvv187 with SMTP id v187so225979720wmv.1
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 12:56:04 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<CAD-J=zY=A8MQLzykox276cHiH7ddXHFVp0w0B4XRBskv6YK_WQ@mail.gmail.com>
	<20151201204535.GX19199@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565E0961.4060603@scylladb.com>
Date: Tue, 1 Dec 2015 22:56:01 +0200
MIME-Version: 1.0
In-Reply-To: <20151201204535.GX19199@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Glauber Costa <glauber@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 12/01/2015 10:45 PM, Dave Chinner wrote:
> On Tue, Dec 01, 2015 at 09:01:13AM -0500, Glauber Costa wrote:
>> On Tue, Dec 1, 2015 at 8:58 AM, Avi Kivity <avi@scylladb.com> wrote:
>>> On 12/01/2015 03:11 PM, Brian Foster wrote:
>>>> It sounds to me that first and foremost you want to make sure you don't
>>>> have however many parallel operations you typically have running
>>>> contending on the same inodes or AGs. Hint: creating files under
>>>> separate subdirectories is a quick and easy way to allocate inodes under
>>>> separate AGs (the agno is encoded into the upper bits of the inode
>>>> number).
>>>
>>> Unfortunately our directory layout cannot be changed.  And doesn't this
>>> require having agcount == O(number of active files)?  That is easily in the
>>> thousands.
>> Actually, wouldn't agcount == O(nr_cpus) be good enough?
> Not quite. What you need is agcount ~= O(nr_active_allocations).

Yes, this is what I mean by "active files".

>
> The difference is an allocation can block waiting on IO, and the
> CPU can then go off and run another process, which then tries to do
> an allocation. So you might only have 4 CPUs, but a workload that
> can have a hundred active allocations at once (not uncommon in
> file server workloads).

But for us, probably not much more.  We try to restrict active I/Os to 
the effective disk queue depth (more than that and they just turn sour 
waiting in the disk queue).


> On worklaods that are roughly 1 process per CPU, it's typical that
> agcount = 2 * N cpus gives pretty good results on large filesystems.

This is probably using sync calls.  Using async calls you can have many 
more I/Os in progress (but still limited by effective disk queue depth).

> If you've got 400GB filesystems or you are using spinning disks,
> then you probably don't want to go above 16 AGs, because then you
> have problems with maintaining continugous free space and you'll
> seek the spinning disks to death....

We're concentrating on SSDs for now.

>
>>>> 'mount -o ikeep,'
>>>
>>> Interesting.  Our files are large so we could try this.
> Keep in mind that ikeep means that inode allocation permanently
> fragments free space, which can affect how large files are allocated
> once you truncate/rm the original files.
>
>

We can try to prime this by allocating a lot of inodes up front, then 
removing them, so that this doesn't happen.

Hurray ext2.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
