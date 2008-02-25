Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 16:35:30 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1P0ZNM7009555
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 16:35:25 -0800
Date: Mon, 25 Feb 2008 11:36:28 +1100
Subject: Re: filesystem corruption in linus tree
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <03F8FD43-322F-41E3-A7A0-CD4E9AD8B4DE@ap.physik.uni-giessen.de>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t611a2kn3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <03F8FD43-322F-41E3-A7A0-CD4E9AD8B4DE@ap.physik.uni-giessen.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>, xfs@oss.sgi.com

On Sun, 24 Feb 2008 20:58:26 +1100, Marc Dietrich  
<Marc.Dietrich@ap.physik.uni-giessen.de> wrote:

> Hi,
>
> somewhere after the release of 2.6.24 my xfs filesystem got corrupted.  
> Initialy I thought it was only related to the readdir bug.  
> (http://oss.sgi.com/archives/xfs/2008-02/msg00027.html) So I waited for  
> the fix to go into mainline. Yesterday I tried again, but got this error  
> during boot:

[stack trace snipped]

> I seems that the log is corrupted because I can't mount the filesystem  
> anymore (blocks while replaying). Mounting with norecovery option works.  
> I tried to repair the filesystem, but xfs_repair also hangs in "Phase 3  
> - scan and clear agi unlinks lists". Before, Phase 2 reports some  
> "ir_freecount/free.mismatch" lines.

Might have to add this to the FAQ as this is the second time someone has
reported Phase 3 hanging.

Try running xfs_repair -P to try and get past this problem if you are
running xfsprogs 2.9.x.

> This happens on a newly created filesystem with xfsprogs 2.6.9 (I also  
> tested 2.5.22). I have a 32bit powermac, so it could be an endian issue.
>
> Thanks
>
> Marc
>
>
>
