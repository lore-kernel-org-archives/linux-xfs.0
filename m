Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 418067F37
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 12:38:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1DFE38F8052
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 10:38:17 -0700 (PDT)
Message-ID: <5203D784.7070900@redhat.com>
Date: Thu, 08 Aug 2013 13:38:12 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsprogs/io: add readdir command
References: <1374669868-14075-1-git-send-email-bfoster@redhat.com>
	<5203A5B7.4020102@sgi.com>
In-Reply-To: <5203A5B7.4020102@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 08/08/2013 10:05 AM, Mark Tinguely wrote:
> On 07/24/13 07:44, Brian Foster wrote:
>> readdir reads the directory entries from an open directory from
>> the provided offset (or 0 if not specified). On completion,
>> readdir prints summary information regarding the number of
>> operations and bytes transferred. Options are available to specify
>> the starting offset, length and verbose mode to dump directory
>> entry information.
>>
>> Signed-off-by: Brian Foster<bfoster@redhat.com>
>> ---
>>
>> v2:
>> - Convert from getdents to readdir.
>> - Use configure mechanism for libc readdir() availability (zab).
>> - Add extra dirent fields to verbose output (zab).
>>
> 
> Just started to look at this.
> 

Hi Mark,

Thanks for looking at this...

> Shouldn't there be a "closedir(dir);" to close the directory stream and
> release the directory structure?
> 

According to the man page, closedir() would also close the fd. I gave it
a quick test to be sure and I end up with behavior like this:

xfs_io> open /export/test
xfs_io> readdir
[00000000 [00000004 [00000006 [00000009 [00000200 read 104 bytes from
offset 0
104.000000 bytes, 4 ops, 0.0000 sec (5.220 MiB/sec and 210526.3158 ops/sec)
xfs_io> close
close: Bad file descriptor

That said, I'm not sure what the ramifications of repeated readdir
commands might be (i.e., repeated fdopendir() calls on the same fd).
Perhaps the right thing to do here is dup() file->fd prior to
fdopendir() and then add the closedir().

> Could we get a little info for the xfs_io man page?
> 

Ok.

Brian

> Looks like a nice feature.
> 
> Thanks.
> 
> --Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
