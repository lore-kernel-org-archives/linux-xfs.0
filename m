Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3G2uQcj161163 for <xfs@oss.sgi.com>; Sun, 15 Apr 2012 21:56:26 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id N1WwFlxZ27OQV4na for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 19:56:25 -0700 (PDT)
Message-ID: <4F8B8A58.6000300@sandeen.net>
Date: Sun, 15 Apr 2012 21:56:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfstests 062: fix support for ext4 and SELinux
References: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
	<4F8B881E.2040806@sandeen.net>
In-Reply-To: <4F8B881E.2040806@sandeen.net>
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
To: tmarek@redhat.com
Cc: lczerner@redhat.com, xfs@oss.sgi.com, dchinner@redhat.com

On 4/15/12 9:46 PM, Eric Sandeen wrote:
> On 4/13/12 4:49 AM, tmarek@redhat.com wrote:
>> From: Tom Marek <tmarek@redhat.com>
>>
>> Tests number 062 was supposed to work with ext4 fs but there were some
>> problems in it - Tests haven't considered existence of lost+found directory in
>> ext4. Also when scratch was mounted with SELinux context test failed because
>> fgetattr returns SELinux extended attributes. And when fgetattr is run with
>> recursive flag it's output might change between file systems due to different
>> file ordering. Fix this by sorting the output manually. Also all lines
>> containing SELinux and lost+found were removed from output.
>>
>> Signed-off-by: Tom Marek <tmarek@redhat.com>
> 
> Have you run the latest xfstests?  This looks a lot like:
> 
> commit 2fb1c931a6090f646afa44e4ce3f1f9815af9067
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Fri Jan 27 12:28:20 2012 -0600
> 
>     062: Sort recursive getfattr output
>     
>     Test 062 was made "generic" a while back, but it fails on any filesystem
>     which returns getfattr -R results (aka readdir results) in something
>     other than inode-order.
>     
>     With a little awk-fu we can sort the records from getfattr -R so that
>     the output is the same for xfs as well as ext4, etc.
>     
>     Also filter out lost+found which extN creates at mkfs time, but
>     some other filesystems do not.
>     
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>     Reviewed-by: Christoph Hellwig <hch@lst.de>

Oh, and as for selinux, scratch should be getting mounted with an fs-wide selinux context mount option, I think?

-Eric
 
> -Eric



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
