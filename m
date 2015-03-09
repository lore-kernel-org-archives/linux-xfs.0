Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 884307F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 11:14:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 617DC8F8033
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 09:14:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id hadwWzp5grKTASyx for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 09:14:54 -0700 (PDT)
Message-ID: <54FDC6FC.1070303@sandeen.net>
Date: Mon, 09 Mar 2015 12:14:52 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfault
References: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>
In-Reply-To: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>
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
To: Rui Gomes <rgomes@rvx.is>, xfs@oss.sgi.com
Cc: =?windows-1252?Q?=D3mar_Hermannsson?= <omar@rvx.is>

On 3/9/15 11:50 AM, Rui Gomes wrote:
> Program received signal SIGABRT, Aborted.
> 0x00007ffff74275c9 in __GI_raise (sig=sig@entry=6) at ../nptl/sysdeps/unix/sysv/linux/raise.c:56
> 56	  return INLINE_SYSCALL (tgkill, 3, pid, selftid, sig);
> #0  0x00007ffff74275c9 in __GI_raise (sig=sig@entry=6) at ../nptl/sysdeps/unix/sysv/linux/raise.c:56
> #1  0x00007ffff7428cd8 in __GI_abort () at abort.c:90
> #2  0x00007ffff7467db7 in __libc_message (do_abort=do_abort@entry=2, fmt=fmt@entry=0x7ffff756f561 "*** %s ***: %s terminated\n") at ../sysdeps/unix/sysv/linux/libc_fatal.c:196
> #3  0x00007ffff74ff9c7 in __GI___fortify_fail (msg=msg@entry=0x7ffff756f507 "buffer overflow detected") at fortify_fail.c:31
> #4  0x00007ffff74fdb90 in __GI___chk_fail () at chk_fail.c:28
> #5  0x0000000000414ea8 in memmove (__len=18446744073709551615, __src=0x1e562094, __dest=0x7fffffffd8f0) at /usr/include/bits/string3.h:57
> #6  process_sf_dir2 (dirname=0x46b0e2 "", repair=<synthetic pointer>, parent=0x7fffffffdc20, dino_dirty=0x7fffffffdc18, ino_discovery=1, dip=0x1e562000, ino=260256256, mp=0x1e562091) at dir2.c:992

That's here:

                if (junkit)  {
                        memmove(name, sfep->name, namelen); <<<<
                        name[namelen] = '\0';

and the len passed to memmove, 18446744073709551615, is 0xFFFFFFFFFFFFFFFF
or -1 according to gdb.

What are the few lines of xfs_repair output prior to this, i.e. messages
containing "shortform dir"?

If you'd like to create & compress an xfs_metadump & provide it to me offline,
I'll see if that recreates the segfault & look into it further.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
