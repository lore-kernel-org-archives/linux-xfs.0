Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819ED298CD5
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 07:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108303; cv=none; b=asd5QU9exEJY17ZWYamrMeK2oBjf1FEdR6AdYgVVLUfd1fGfaCTdLRGoDE4k9Kq84X8uOsHx3r0uV04lvZu3l7eyoT2sVEHHJNPm9R4YsuZiRrjO3YTvZ+lt1rkzNnn2HOUcOM0Yj5wMoN1o2uOT7J7ULS3BsQEJayqUArhBAoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108303; c=relaxed/simple;
	bh=c53N7GBoYyGWNaWY/UEPBRR6COLLKCC3m60iHhwqM/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRVZ2+D7LT6DDBD/2NM6luGV94tTdeYp/HP093GbKMjPDB909wzRvUtmP5X7IhbUROAnZyzmAZHqB+Y1sxNodAWik8q8tQ8grMVtirqorss+6GPiwrV/68Uf457mO8+jPCsZ7ZrV/T9GQxvtKPSpfeQhpvKs2VH25NUyl8SexJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xlx6isrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xlx6isrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0FAC4CEED;
	Mon, 25 Aug 2025 07:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756108303;
	bh=c53N7GBoYyGWNaWY/UEPBRR6COLLKCC3m60iHhwqM/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xlx6isrHNSwM9JxTAM1EjMuDT4YYDRMfZBUsFpcLpaHKDNvOx+ycLBFQDmtg4vxbf
	 PISeW6u2Gqc6GWQrcN5zlLHd0z2AjBT7Q4ZwTh+CKntvmimAy3bcc67ZijMtJh3PHK
	 UPI8i8qwWIiuLKLI13oc/DCUhv/YOoHIsPsf/1x0TlkJk8y+VwLUHYOUq4vK68cRro
	 y6rrVM3A67M3M/JNpSPT9Cl71wn9E3xPmUgWSXQpxNw7khY2iFcWWOU8S9oHc14n2b
	 /3OzW9PapqA0GclfbYOSkdaDUyISPVMa+MfqEsVYqwp4ZS7XYzxOVA3M+AEjIXi87u
	 up8mgNZebR+QA==
Date: Mon, 25 Aug 2025 09:51:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "hubert ." <hubjin657@outlook.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_metadump segmentation fault on large fs - xfsprogs 6.1
Message-ID: <gjogpxo65cozoccj4fps6e4fzeu4ncibeofymhkyzys4hsclzy@vvrl2kndu7k6>
References: <f9Etb2La9b1KOT-5VdCdf6cd10olyT-FsRb8AZh8HNI1D4Czb610tw4BE15cNrEhY5OiXDGS7xR6R1trRyn1LA==@protonmail.internalid>
 <CH3PR05MB10392E816C6A1051847D214A2FA59A@CH3PR05MB10392.namprd05.prod.outlook.com>
 <6tqlc3mcf3ovkbzf4345m7oztoeagevfycpdnxizrtdbhq53p2@mrlmjhs6n7gy>
 <LV3PR05MB104071E0D6E7CAD06C7728DACFA26A@LV3PR05MB10407.namprd05.prod.outlook.com>
 <kZ0Ndjz5Uh9rHFbs-iYYoEFNVWoxMtkvK-3nrx6mrlxpglTxelNWuY_lqxKmfrItAPWl4M4ng-BzenCqcFiOaA==@protonmail.internalid>
 <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA0PR05MB99750EB3605E36DEF8874BACFA31A@IA0PR05MB9975.namprd05.prod.outlook.com>

Hello Hubert, my apologies for the delay.


On Mon, Aug 18, 2025 at 03:56:53PM +0000, hubert . wrote:
> Am 18.08.25 um 17:14 schrieb hubert .:
> >
> > Am 26.07.25 um 00:52 schrieb Carlos Maiolino:
> >>
> >> On Fri, Jul 25, 2025 at 11:27:40AM +0000, hubert . wrote:
> >>> Hi,
> >>>
> >>> A few months ago we had a serious crash in our monster RAID60 (~590TB) when one of the subvolume's disks failed and then then rebuild process triggered failures in other drives (you guessed it, no backup).
> >>> The hardware issues were plenty to the point where we don't rule out problems in the Areca controller either, compounding to some probably poor decisions on my part.
> >>> The rebuild took weeks to complete and we left it in a degraded state not to make things worse.
> >>> The first attempt to mount it read-only of course failed. From journalctl:
> >>>
> >>> kernel: XFS (sdb1): Mounting V5 Filesystem
> >>> kernel: XFS (sdb1): Starting recovery (logdev: internal)
> >>> kernel: XFS (sdb1): Metadata CRC error detected at xfs_agf_read_verify+0x70/0x120 [xfs], xfs_agf block 0xa7fffff59
> >>> kernel: XFS (sdb1): Unmount and run xfs_repair
> >>> kernel: XFS (sdb1): First 64 bytes of corrupted metadata buffer:
> >>> kernel: ffff89b444a94400: 74 4e 5a cc ae eb a0 6d 6c 08 95 5e ed 6b a4 ff  tNZ....ml..^.k..
> >>> kernel: ffff89b444a94410: be d2 05 24 09 f2 0a d2 66 f3 be 3a 7b 97 9a 84  ...$....f..:{...
> >>> kernel: ffff89b444a94420: a4 95 78 72 58 08 ca ec 10 a7 c3 20 1a a3 a6 08  ..xrX...... ....
> >>> kernel: ffff89b444a94430: b0 43 0f d6 80 fd 12 25 70 de 7f 28 78 26 3d 94  .C.....%p..(x&=.
> >>> kernel: XFS (sdb1): metadata I/O error: block 0xa7fffff59 ("xfs_trans_read_buf_map") error 74 numblks 1
> >>>
> >>> Following the advice in the list, I attempted to run a xfs_metadump (xfsprogs 4.5.0), but after after copying 30 out of 590 AGs, it segfaulted:
> >>> /usr/sbin/xfs_metadump: line 33:  3139 Segmentation fault      (core dumped) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1
> >>
> >> I'm not sure what you expect from a metadump, this is usually used for
> >> post-mortem analysis, but you already know what went wrong and why
> >
> > I was hoping to have a restored metadata file I could try things on
> > without risking the copy, since it's not possible to have a second one
> > with this inordinate amount of data.
> >
> >>>
> >>> -journalctl:
> >>> xfs_db[3139]: segfault at 1015390b1 ip 0000000000407906 sp 00007ffcaef2c2c0 error 4 in xfs_db[400000+8a000]
> >>>
> >>> Now, the host machine is rather critical and old, running CentOS 7, 3.10 kernel on a Xeon X5650. Not trusting the hardware, I used ddrescue to clone the partition to some other luckily available system.
> >>> The copy went ok(?), but it did encounter reading errors at the end, which confirmed my suspicion that the rebuild process was not as successful. About 10MB could not be retrieved.
> >>>
> >>> I attempted a metadump on the copy too, now on a machine with AMD EPYC 7302, 128GB RAM, a 6.1 kernel and xfsprogs v6.1.0.
> >>>
> >>> # xfs_metadump -aogfw  /storage/image/sdb1.img   /storage/metadump/sdb1.metadump 2>&1 | tee mddump2.log
> >>>
> >>> It creates again a 280MB dump and at 30 AGs it segfaults:
> >>>
> >>> Jul24 14:47] xfs_db[42584]: segfault at 557051a1d2b0 ip 0000556f19f1e090 sp 00007ffe431a7be0 error 4 in xfs_db[556f19f04000+64000] likely on CPU 21 (core 9, socket 0)
> >>> [  +0.000025] Code: 00 00 00 83 f8 0a 0f 84 90 07 00 00 c6 44 24 53 00 48 63 f1 49 89 ff 48 c1 e6 04 48 8d 54 37 f0 48 bf ff ff ff ff ff ff 3f 00 <48> 8b 02 48 8b 52 08 48 0f c8 48 c1 e8 09 48 0f ca 81 e2 ff ff 1f
> >>>
> >>> This is the log https://pastebin.com/jsSFeCr6, which looks similar to the first one. The machine does not seem loaded at all and further tries result in the same code.
> >>>
> >>> My next step would be trying a later xfsprogs version, or maybe xfs_repair -n on a compatible CPU machine as non-destructive options, but I feel I'm kidding myself as to what I can try to recover anything at all from such humongous disaster.
> >>
> >> Yes, that's probably the best approach now. To run the latest xfsprogs
> >> available.
> >
> > Ok, so I ran into some unrelated issues, but I could finally install xfsprogs 6.15.0:
> >
> > root@serv:~# xfs_metadump -aogfw /storage/image/sdb1.img  /storage/metadump/sdb1.metadump
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: data size check failed
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot init perag data (22). Continuing anyway.
> > xfs_metadump: read failed: Invalid argument
> > empty log check failed
> > xlog_is_dirty: cannot find log head/tail (xlog_find_tail=-22)
> >
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read superblock for ag 0
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agf block for ag 0
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agi block for ag 0
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agfl block for ag 0
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read superblock for ag 1
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agf block for ag 1
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agi block for ag 1
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agfl block for ag 1
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read superblock for ag 2
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agf block for ag 2
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agi block for ag 2
> > ...
> > ...
> > ...
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agfl block for ag 588
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read superblock for ag 589
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agf block for ag 589
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agi block for ag 589
> > xfs_metadump: read failed: Invalid argument
> > xfs_metadump: cannot read agfl block for ag 589
> > Copying log
> > root@serv:~#
> >
> > It did create a 2.1GB dump which of course restores to an empty file.
> >
> > I thought I had messed up with some of the dependency libs, so then I
> > tried with xfsprogs 6.13 in Debian testing, same result.
> >
> > I'm not exactly sure why now it fails to read the image; nothing has
> > changed about it. I could not find much more info in the documentation.
> > What am I missing..?
> 
> I tried a few more things on the img, as I realized it was probably not
> the best idea to dd it to a file instead of a device, but I got nowhere.
> After some team deliberations, we decided to connect the original block
> device to the new machine (Debian 13, 16 AMD cores, 128RAM, new
> controller, plenty of swap, xfsprogs 6.13) and and see if the dump was possible then.
> 
> It had the same behavior as with with xfsprogs 6.1 and segfauled after
> 30 AGs. journalctl and dmesg don't really add any more info, so I tried
> to debug a bit, though I'm afraid it's all quite foreign to me:
> 
> root@ap:/metadump# gdb xfs_metadump core.12816
> GNU gdb (Debian 16.3-1) 16.3
> Copyright (C) 2024 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.
> ...
> Type "apropos word" to search for commands related to "word"...
> "/usr/sbin/xfs_metadump": not in executable format: file format not recognized
> [New LWP 12816]
> Reading symbols from /usr/sbin/xfs_db...
> (No debugging symbols found in /usr/sbin/xfs_db)
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
> Core was generated by `/usr/sbin/xfs_db -i -p xfs_metadump -c metadump /dev/sda1'.
> Program terminated with signal SIGSEGV, Segmentation fault.
> #0  0x0000556f127d6857 in ?? ()
> (gdb) bt full
> #0  0x0000556f127d6857 in ?? ()
> No symbol table info available.
> #1  0x0000556f127dbdc4 in ?? ()
> No symbol table info available.
> #2  0x0000556f127d5546 in ?? ()
> No symbol table info available.
> #3  0x0000556f127db350 in ?? ()
> No symbol table info available.
> #4  0x0000556f127d5546 in ?? ()
> No symbol table info available.
> #5  0x0000556f127d99aa in ?? ()
> No symbol table info available.
> #6  0x0000556f127b9764 in ?? ()
> No symbol table info available.
> #7  0x00007eff29058ca8 in ?? () from /lib/x86_64-linux-gnu/libc.so.6
> No symbol table info available.
> #8  0x00007eff29058d65 in __libc_start_main () from /lib/x86_64-linux-gnu/libc.so.6
> No symbol table info available.
> #9  0x0000556f127ba8c1 in ?? ()
> No symbol table info available.
> 
> And this:
> 
> root@ap:/PETA/metadump# coredumpctl info
>            PID: 13103 (xfs_db)
>            UID: 0 (root)
>            GID: 0 (root)
>         Signal: 11 (SEGV)
>      Timestamp: Mon 2025-08-18 19:03:19 CEST (1min 12s ago)
>   Command Line: xfs_db -i -p xfs_metadump -c metadump -a -o -g -w $' /metadump/metadata.img' /dev/sda1
>     Executable: /usr/sbin/xfs_db
>  Control Group: /user.slice/user-0.slice/session-8.scope
>           Unit: session-8.scope
>          Slice: user-0.slice
>        Session: 8
>      Owner UID: 0 (root)
>        Boot ID: c090e507272647838c77bcdefd67e79c
>     Machine ID: 83edcebe83994c67ac4f88e2a3c185e3
>       Hostname: ap
>        Storage: /var/lib/systemd/coredump/core.xfs_db.0.c090e507272647838c77bcdefd67e79c.13103.1755536599000000.zst (present)
>   Size on Disk: 26.2M
>        Message: Process 13103 (xfs_db) of user 0 dumped core.
> 
>                 Module libuuid.so.1 from deb util-linux-2.41-5.amd64
>                 Stack trace of thread 13103:
>                 #0  0x000055b961d29857 n/a (/usr/sbin/xfs_db + 0x32857)
>                 #1  0x000055b961d2edc4 n/a (/usr/sbin/xfs_db + 0x37dc4)
>                 #2  0x000055b961d28546 n/a (/usr/sbin/xfs_db + 0x31546)
>                 #3  0x000055b961d2e350 n/a (/usr/sbin/xfs_db + 0x37350)
>                 #4  0x000055b961d28546 n/a (/usr/sbin/xfs_db + 0x31546)
>                 #5  0x000055b961d2c9aa n/a (/usr/sbin/xfs_db + 0x359aa)
>                 #6  0x000055b961d0c764 n/a (/usr/sbin/xfs_db + 0x15764)
>                 #7  0x00007fc870455ca8 n/a (libc.so.6 + 0x29ca8)
>                 #8  0x00007fc870455d65 __libc_start_main (libc.so.6 + 0x29d65)
>                 #9  0x000055b961d0d8c1 n/a (/usr/sbin/xfs_db + 0x168c1)
>                 ELF object binary architecture: AMD x86-64

Without the debug symbols it get virtually impossible to know what
was going on =/

> 
> I guess my questions are: can the fs be so corrupted that it causes
> xfs_metadump (or xfs_db) to segfault? Are there too many AGs / fs too
> large?
> Shall I assume that xfs_repair could fail similarly then?

In a nutshell xfs_metadump shouldn't segfault even if the fs is
corrupted.
About xfs_repair, it depends, there is some code shared between both,
but xfs_repair is much more resilient.

> 
> I'll appreciate any ideas. Also, if you think the core dump or other logs
> could be useful, I can upload them somewhere.

I'd start by running xfs_repair in no-modify mode, i.e. `xfs_repair -n`
and check what it finds.

Regarding the xfs_metadump segfault, yes, a core might be useful to
investigate where the segfault is triggered, but you'll need to be
running xfsprogs from the upstream tree (preferentially latest code), so
we can actually match the core information the code.

Cheers,
Carlos.

> 
> Thanks again
> 
> >
> >
> > Thanks
> >>
> >> Also, xfs_repair does not need to be executed on the same architecture
> >> as the FS was running. Despite log replay (which is done by the Linux
> >> kernel), xfs_repair is capable of converting the filesystem data
> >> structures back and forth to the current machine endianness
> >>
> >>
> >>>
> >>> Thanks in advance for any input
> >>> Hub
> >
