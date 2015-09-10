Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5949B7F47
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 05:31:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6EDDAC008
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 03:31:49 -0700 (PDT)
Received: from posti5.jyu.fi (posti5.jyu.fi [130.234.4.34]) by cuda.sgi.com
	with ESMTP id wQsAH3rqFZWdBAFV (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 03:31:44 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by posti5.jyu.fi (8.13.8/8.13.8) with ESMTP id t8AAVhRM032731
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 13:31:43 +0300
Received: from posti5.jyu.fi ([127.0.0.1])
	by localhost (posti5.jyu.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 17roYesaK6ff for <xfs@oss.sgi.com>;
	Thu, 10 Sep 2015 13:31:42 +0300 (EEST)
Received: from tehanu.it.jyu.fi (tehanu.it.jyu.fi [130.234.160.128])
	by posti5.jyu.fi (8.13.8/8.13.8) with ESMTP id t8AAVgvC032717
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 13:31:42 +0300
Received: (from tt@localhost)
	by tehanu.it.jyu.fi (8.14.4/8.14.4/Submit) id t8AAVgBs026892
	for xfs@oss.sgi.com; Thu, 10 Sep 2015 13:31:42 +0300
Date: Thu, 10 Sep 2015 13:31:42 +0300
From: Tapani Tarvainen <tapani.j.tarvainen@jyu.fi>
Subject: Re: "This is a bug."
Message-ID: <20150910103142.GA26847@tehanu.it.jyu.fi>
References: <20150910091834.GC24937@tehanu.it.jyu.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910091834.GC24937@tehanu.it.jyu.fi>
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
To: xfs@oss.sgi.com

A perhaps interesting addition: xfs_metadump succeeds with
the -o option (without it it fails consistently).

If you think the dump would be useful to you I can probably
send it unobfuscated (would have to check but I don't think
there's anything sensitive in the filenames or attributes).

-- 
Tapani Tarvainen

On 10 Sep 12:18, Tapani Tarvainen (tapani.j.tarvainen@jyu.fi) wrote:
> 
> Hi,
> 
> After a rather spectacular crash we've got an xfs filesystem
> in unrepairable state: mount fails with "Structure needs cleaning",
> xfs_repair without options refuses to work (asks to mount first),
> and xfs_repair -L stopped with
> 
> corrupt dinode 2151195170, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> 
> I tried to dump the metadata and it failed, too:
> 
> # xfs_metadump /dev/sdata1/data1 /data2/tmp/data1_metadump
> xfs_metadump: cannot init perag data (117)
> *** glibc detected *** xfs_db: double free or corruption (!prev): 0x0000000003361000 ***
> ======= Backtrace: ========= 
> [...]
> Aborted
> 
> 
> At this point I'm going to give up trying to recover the data
> (recreate filesystem and restore from backup), but if you want to
> analyze it to find the bug, I have enough spare disk space to keep a
> copy for a while (took lvm snapshot of it before recovery attempt,
> could dd it to another location).
> 
> The machine is running Debian Wheezy (7.8),
> kernel 3.2.0-4-amd64 #1 SMP Debian 3.2.68-1+deb7u1 x86_64 GNU/Linux,
> xfsprogs version 3.1.7+b1.
> And the filesystem is 6TB in size.
> 
> If you want to take a look, please let me know what I can do to help.
> 
> Thank you,
> 
> -- 
> Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
