Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 16:53:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L0rhE1021457
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 16:53:45 -0800
Date: Mon, 21 Jan 2008 11:54:18 +1100
Subject: Re: [REVIEW 2/2] Case insensitive support for XFS - user-space
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t43zfeiz3jf8g2@pc-bnaujok.melbourne.sgi.com> <479118CF.1020302@sandeen.net>
Message-ID: <op.t488ss0n3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <479118CF.1020302@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Sat, 19 Jan 2008 08:23:27 +1100, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Barry Naujok wrote:
>> This patch relies on the dinode.c refactoring patch posted recently.
>> I have attached the latest version (with fixes pointed out by Chandan).
>
> So, new mkfs.xfs -h output says:
>
> /* naming */		[-n log=n|size=num,version=n,utf8=none|default|turkic]
>
> so I tried:
>
> mkfs.xfs -dfile,name=fsfile,size=500m -nutf8=none
>
> and got:
>
> Illegal value none for -n utf8 option

Bad usage on my part. I have changed it to:

/* naming */		[-n log=n|size=num,version=n,utf8[=default|turkic]]

> (are there man page updates lurking somewhere?  Pls also update
> Documentation/filesystems/xfs.txt in the kernel)

Yes, these are coming.
