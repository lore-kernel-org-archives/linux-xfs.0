Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54970 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752630AbdC1V57 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 17:57:59 -0400
Subject: Re: [PATCH 2/2 V2] xfs_io: hook up statx
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
 <20170327205846.GA6502@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9562705a-3f0f-82f1-b74a-7f7c17eadd84@sandeen.net>
Date: Tue, 28 Mar 2017 16:57:56 -0500
MIME-Version: 1.0
In-Reply-To: <20170327205846.GA6502@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On 3/27/17 3:58 PM, Eric Biggers wrote:
> Hi Eric,
> 
> On Thu, Mar 23, 2017 at 11:45:45PM -0500, Eric Sandeen wrote:
>> Wire up the statx syscall to xfs_io.
>>
> 
> I haven't reviewed these patches in detail, but just a few nits:
> 
> Given that the command operates on an open file, wouldn't it make more sense to
> call statx() with the file descriptor and a NULL path?

Yeah, good point.  Not sure why I did what I did ;)

> It wouldn't be ideal for
> test coverage, but it seems xfs_io isn't currently designed to work otherwise.
> And note that the 'stat' xfs_io command already calls fstat(), not stat().
> 
> (In particular think about what should happen if you open a file through a
> symlink, then execute both the 'stat' and 'statx' commands... with the current
> proposal 'stat' would operate on the file, while 'statx' would operate on the
> symlink by default.  Seems inconsistent.)

*nod*

> 
>> diff --git a/io/init.c b/io/init.c
>> index 06002e6..c15a1e1 100644
>> --- a/io/init.c
>> +++ b/io/init.c
>> @@ -86,6 +86,7 @@ init_commands(void)
>>  	seek_init();
>>  	sendfile_init();
>>  	shutdown_init();
>> +	stat_init();
>>  	sync_init();
> 
> The call to stat_init() should be added in patch 1 instead of patch 2, since
> otherwise the 'stat' command is unavailable after applying just patch 1.

Yup!

>> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
>> index 19e1ae4..022f0ea 100644
>> --- a/man/man8/xfs_io.8
>> +++ b/man/man8/xfs_io.8
>> @@ -880,6 +880,32 @@ and the XFS_IOC_GETXATTR system call on the current file. If the
>>  option is specified, the atime (last access), mtime
>>  (last modify), and ctime (last change) timestamps are also displayed.
>>  .TP
>> +.BR statx " [ " \-O " | " "\-m mask" " ][ \-" FDLA " ]"
>> +Extended information from the statx syscall.
>> +.RS 1.0i
>> +.PD 0
>> +.TP 0.4i
>> +.B \-m mask
>> +Specify the field mask for the statx call (default STATX_ALL)
>> +.TP
>> +.B \-O
>> +Add only basic stats (STATX_BASIC_STATS) to default mask
>> +.TP
>> +.B \-F
>> +Force the attributes to be sync'd with the server
>> +.TP
>> +.B \-D
>> +Don't sync attributes with the server
>> +.TP
>> +.B \-L
>> +Follow symlinks (statx link target)
>> +.TP
>> +.B \-A
>> +Suppress terminal automount traversal
>> +.TP
>> +.RE
>> +.IP
>> +.TP
>>  .B statfs
>>  Selected statistics from
>>  .BR statfs (2)
> 
> This re-introduces the issue where the later text in the formatted man page is
> indented too much.  Removing the extra .TP and .IP, so that the source looks
> like the following, appears to fix it:

Ugh, thanks.  I'm not good at man pages.

Will fix all these, thanks!

-Eric

> .TP
> .B \-A
> Suppress terminal automount traversal
> .RE
> .TP
> .B statfs
> 
> 
> - Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
