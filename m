Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA60C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 16:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjKBQj6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 12:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbjKBQj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 12:39:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5178812F
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 09:39:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC32C433C7;
        Thu,  2 Nov 2023 16:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698943193;
        bh=OzBOJfgpNyrvsW61ULvbF5Jox9ZGE6ZQONCqqfbOxtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fLxU/We8rDxVcUx8VEp8EUZJ1xiIT4vGYrd41S6UQZN7N7O6FlcSC26qcv+MzvQ4y
         nH7TeK4umyQWGl7wdwop25KVNa4Pl/K8Do35z/c57Vp3DH3R6rjyQa06+uUYbSBSPW
         USPDLiVOq061b1GqxBKKb+/5+z9P5y9NIJXqcbajH+viWRLIgDI2Uz4k9SUBYsTmma
         wWVmk+gLYCGML6Kps/7sM04P3xWWM3o7QYXc8fVKkn2Fy0wB7JWkq4Ha99F4Xs2R20
         Tc2yDaf8aFoyVOU05AJSSjXI2OySw9w38QJEi4TdKpUTB9B2/tTpnpDEtbAatyc/zq
         GlH0ZSxO8SfWA==
Date:   Thu, 2 Nov 2023 09:39:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alexander Puchmayr <alexander.puchmayr@linznet.at>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfsdump does not support reflink copied files properly
Message-ID: <20231102163953.GF1205143@frogsfrogsfrogs>
References: <2644025.VLH7GnMWUR@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2644025.VLH7GnMWUR@zeus>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2023 at 01:42:54PM +0100, Alexander Puchmayr wrote:
> Hi there,
> 
> I just encountered a problem when trying to use xfsdump on a filesystem with 
> lots of reflink copied vm disk images, yielding a dump file much larger than 
> expected and which I also was unable to restore from (target disk full). I 
> created a gentoo bug item under https://bugs.gentoo.org/916704 and I got 
> advised to report it here as well.
> 
> Copy from the bug report:
> 
> sys-fs/xfsdump-3.1.12 seems to copy reflink copied files as ordinary files, 
> resulting in a way too big dump file. Restoring from such a dump yields likely 
> a out-of-diskspace condition. 

Correct, xfsdump (and tar, and rsync...) does not know how to preserve
the sharing factor of a particular space extent.  All of those tools
walk the inodes on a filesystem, open them, and read() out the data.

Although there are ways to find out which file(s) own a piece of disk
space, each of those tools would most likely require a thorough redesign
to the dump file format to allow pointing to shared blocks elsewhere in
the dump file.  Or one could bolt a deduplicator onto the restore side,
which wouldn't help with the dumpfile size explosion but would at least
allow for compact restoration.

Regardless, nobody's submitted code to do any of those things.  Patches
welcome.

> It may be used as a denial-of-service tool which can be used by an ordinary 

Please do not file a  ^^^^^^^^^^^^^^^^^ CVE for this.

--D

> user once he/she is able to create lots of reflink copies of large files, 
> breaking a backup system relying on xfsdump (one can easily create Petabytes 
> or even Exabytes of useless data overloading every affordable existing backup 
> system) and also making it hard to restore the data during a disaster 
> recovery.
> 
> How to reproduce:
> 
> 1) Create a 1GB test filesystem for demonstration purpose and mount it, e.g.
> $ dd if=/dev/zero of=/var/tmp/testimage_xfs.raw bs=1M count=1k
> $ mkfs.xfs /var/tmp/testimage_xfs.raw 
> $ mount /var/tmp/testimage_xfs.raw /mnt/tmp
> 
> 2) Create a testfile with 256M
> $ dd if=/dev/urandom of=/mnt/tmp/testfile.dat bs=1k count=256k
> 
> 3) reflink-copy this file multiple times
> $ cd /mnt/tmp
> $ cp --reflink testfile.dat testfile1.dat
> $ cp --reflink testfile.dat testfile2.dat
> $ cp --reflink testfile.dat testfile3.dat
> $ cp --reflink testfile.dat testfile4.dat
> $ cp --reflink testfile.dat testfile5.dat
> $ cp --reflink testfile.dat testfile6.dat
> 
> 4) Verify:
> $ df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop0      960M  295M  666M  31% /mnt/tmp
> 
> $ ls -l 
> total 1835008
> -rw-r--r-- 1 root root 268435456 Nov  2 09:37 testfile.dat
> -rw-r--r-- 1 root root 268435456 Nov  2 09:38 testfile1.dat
> -rw-r--r-- 1 root root 268435456 Nov  2 09:38 testfile2.dat
> -rw-r--r-- 1 root root 268435456 Nov  2 09:38 testfile3.dat
> -rw-r--r-- 1 root root 268435456 Nov  2 09:38 testfile4.dat
> -rw-r--r-- 1 root root 268435456 Nov  2 09:38 testfile5.dat
> -rw-r--r-- 1 root root 268435456 Nov  2 09:38 testfile6.dat
> 
> 5) Create a dump:
> $ xfsdump -p10 -L TEST -M TEST1 -l 0 -f /var/tmp/xfsdump /mnt/tmp
> xfsdump: using file dump (drive_simple) strategy
> xfsdump: version 3.1.12 (dump format 3.0) - type ^C for status and control
> xfsdump: WARNING: most recent level 0 dump was interrupted, but not resuming 
> that dump since resume (-R) option not specified
> xfsdump: level 0 dump of poseidon.local:/mnt/tmp
> xfsdump: dump date: Thu Nov  2 09:40:46 2023
> xfsdump: session id: a5b46d21-698d-47fb-a0a0-9974421f923c
> xfsdump: session label: "TEST"
> xfsdump: ino map phase 1: constructing initial dump list
> xfsdump: ino map phase 2: skipping (no pruning necessary)
> xfsdump: ino map phase 3: skipping (only one dump stream)
> xfsdump: ino map construction complete
> xfsdump: estimated dump size: 1879071232 bytes
> xfsdump: creating dump session media file 0 (media 0, file 0)
> xfsdump: dumping ino map
> xfsdump: dumping directories
> xfsdump: dumping non-directory files
> xfsdump: ending media file
> xfsdump: media file size 1879556704 bytes
> xfsdump: dump size (non-dir files) : 1879501192 bytes
> xfsdump: dump complete: 5 seconds elapsed
> xfsdump: Dump Summary:
> xfsdump:   stream 0 /var/tmp/xfsdump OK (success)
> xfsdump: Dump Status: SUCCESS
> 
> Compare: A filesystem of size 1GB produced a dump of almost 2GB. My expectation 
> is about the used 295M plus a little overhead. 
> 
> 6) Try to restore:
> $ rm /mnt/tmp/*
> $ xfsrestore -f /var/tmp/xfsdump /mnt/tmp/
> xfsrestore: using file dump (drive_simple) strategy
> xfsrestore: version 3.1.12 (dump format 3.0) - type ^C for status and control
> xfsrestore: searching media for dump
> xfsrestore: examining media file 0
> xfsrestore: dump description: 
> xfsrestore: hostname: poseidon.local
> xfsrestore: mount point: /mnt/tmp
> xfsrestore: volume: /dev/loop0
> xfsrestore: session time: Thu Nov  2 09:40:46 2023
> xfsrestore: level: 0
> xfsrestore: session label: "TEST"
> xfsrestore: media label: "TEST1"
> xfsrestore: file system id: 919b4b3c-1d02-4f39-a42d-3fa1b01c1b2f
> xfsrestore: session id: a5b46d21-698d-47fb-a0a0-9974421f923c
> xfsrestore: media id: bc0946fb-e8aa-41bf-b856-03b6100a5e76
> xfsrestore: using online session inventory
> xfsrestore: searching media for directory dump
> xfsrestore: reading directories
> xfsrestore: 1 directories and 7 entries processed
> xfsrestore: directory post-processing
> xfsrestore: restoring non-directory files
> xfsrestore: attempt to write 262144 bytes to testfile3.dat at offset 160161792 
> failed: No space left on device
> xfsrestore: attempt to write 249856 bytes to testfile3.dat at offset 167772160 
> failed: No space left on device
> xfsrestore: attempt to write 245760 bytes to testfile3.dat at offset 184549376 
> failed: No space left on device
> xfsrestore: attempt to write 241664 bytes to testfile3.dat at offset 201326592 
> failed: No space left on device
> xfsrestore: attempt to write 237568 bytes to testfile3.dat at offset 218103808 
> failed: No space left on device
> xfsrestore: attempt to write 233472 bytes to testfile3.dat at offset 234881024 
> failed: No space left on device
> xfsrestore: attempt to write 229376 bytes to testfile3.dat at offset 251658240 
> failed: No space left on device
> xfsrestore: attempt to write 262144 bytes to testfile3.dat at offset 266563584 
> failed: No space left on device
> xfsrestore: WARNING: open of testfile4.dat failed: No space left on device: 
> discarding ino 135
> xfsrestore: WARNING: open of testfile5.dat failed: No space left on device: 
> discarding ino 136
> xfsrestore: WARNING: open of testfile6.dat failed: No space left on device: 
> discarding ino 137
> xfsrestore: restore complete: 3 seconds elapsed
> xfsrestore: Restore Summary:
> xfsrestore:   stream 0 /var/tmp/xfsdump OK (success)
> xfsrestore: Restore Status: SUCCESS
> $ 
> 
> RESTORE FAILED!! It is copying the files as ordinary files and not reflinked 
> files!
> 
> 
