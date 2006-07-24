Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 14:32:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6OLW8DW025835
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 14:32:19 -0700
Message-ID: <44C53C23.8040008@melbourne.sgi.com>
Date: Tue, 25 Jul 2006 07:31:15 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: atime on xfs
References: <d1ec67b40607240625s5d8b9385ueab714c0f20fcc24@mail.gmail.com>
In-Reply-To: <d1ec67b40607240625s5d8b9385ueab714c0f20fcc24@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Artur Iwaniuk <aiwaniuk@gmail.com>
Cc: linux-xfs@oss.sgi.com



Artur Iwaniuk wrote:
> hello,
> 
> can anyone can me explain such stat on my xfs partition:
> 
>   File: `194/194.149.231.137'
>   Size: 0               Blocks: 0          IO Block: 4096   pusty zwyk³y
> plik
> Device: 902h/2306d      Inode: 1477457428  Links: 1
> Access: (0666/-rw-rw-rw-)  Uid: (  201/  qmaild)   Gid: (  200/ nofiles)
> Access: 2006-07-18 09:13:32.903206500 +0200
> Modify: 2006-07-18 11:26:23.273786250 +0200
> Change: 2006-07-18 11:26:23.273786250 +0200
> 
> why access time is earlier than change, modify time ? how is it posible? is
> there bug in xfs ?
> i am sure, that file was asscessed yesterday, maybe even today
> 
> please, help
> 
> 

Are you using the noatime mount option? That will cause XFS not to
update the atime, its often used since the filesystem normally
has to write metadata just because someone read the file.

David

-- 
David Chatterton                   Phone: +61 3 9963 1934
XFS Engineering Manager            Mobile: +61 409 154 121
SGI Australia          http://www.sgi.com/products/storage
