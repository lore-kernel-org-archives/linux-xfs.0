Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B52B47F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 12:04:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94726304067
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 10:04:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VKt8BQGuiRBzMhtw for
	<xfs@oss.sgi.com>; Thu, 31 Jan 2013 10:04:16 -0800 (PST)
Message-ID: <510AB2D5.2080600@redhat.com>
Date: Thu, 31 Jan 2013 13:07:17 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: 50% more blocks allocated than needed
References: <CA+kHd+eRifnCVkri6TPKS9UcUpBSW9nPnCEz0a412vO_Aw8=Xw@mail.gmail.com>
In-Reply-To: <CA+kHd+eRifnCVkri6TPKS9UcUpBSW9nPnCEz0a412vO_Aw8=Xw@mail.gmail.com>
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
To: Thomas Habets <thomas@habets.se>
Cc: xfs@oss.sgi.com

On 01/31/2013 06:43 AM, Thomas Habets wrote:
> Hi.
> 
> I've had some files on an XFS filesystem that use way
> more blocks than they need.
> 
> That is, st_size=50MB and st_blocks*512= about 68MB.
> 
> The files were downloaded with wget on a somewhat unreliable 3G
> connection (50-500kBps) and sometimes defragging (xfs_fsr) fixes it,
> but
> sometimes not.
> 
> If st_blocks*512<st_size then it could be sparse files, but this is
> the opposite. So... preallocation?
> 

Yes, here's a thread (one of probably several examples) that discusses
the behavior and how the extra space is not permanent, but can hang
around for a bit:

http://oss.sgi.com/archives/xfs/2012-03/msg00145.html

> "df" before and after deleting a bunch of these files shows that the
> st_blocks is what it cares about. Would the preallocation (if that's
> what it is) be reclaimed if the fs started to run out of space?
> 

I don't think so at the moment, but preallocation is throttled as the
filesystem free space becomes more limited. We've recently added
speculative prealloc tracking that performs background trimming on a
timer controlled via:

/proc/sys/fs/xfs/speculative_prealloc_lifetime

... and can be used in the future to explicitly reclaim extra space
lying around when the filesystem is full.

Brian

> If not preallocation, then what?
> 
> Note st_blocks is 134656 and xfs_bmap shows 97663 blocks.
> 
> $ ls -l foo
> -rw-r--r-- 1 root root 50000000 Jan 29 01:32 foo
> $ du -h foo
> 66M foo
> $ stat foo
>   File: `foo'
>   Size: 50000000   Blocks: 134656     IO Block: 4096   regular file
> Device: fe04h/65028d Inode: 68688483    Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2013-01-30 18:56:18.603278346 +0000
> Modify: 2013-01-29 01:32:51.000000000 +0000
> Change: 2013-01-31 11:38:10.892330145 +0000
>  Birth: -
> $ xfs_bmap foo
> foo:
> 0: [0..97663]: 44665840..44763503
> 
> --
> typedef struct me_s {
>  char name[]      = { "Thomas Habets" };
>  char email[]     = { "thomas@habets.pp.se" };
>  char kernel[]    = { "Linux" };
>  char *pgpKey[]   = { "http://www.habets.pp.se/pubkey.txt" };
>  char pgp[] = { "A8A3 D1DD 4AE0 8467 7FDE  0945 286A E90A AD48 E854" };
>  char coolcmd[]   = { "echo '. ./_&. ./_'>_;. ./_" };
> } me_t;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
