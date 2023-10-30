Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7748C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Oct 2023 07:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbjJ3Hu4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 03:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjJ3Huz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Oct 2023 03:50:55 -0400
X-Greylist: delayed 465 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Oct 2023 00:50:52 PDT
Received: from guitar.compbio.ucsf.edu (guitar.compbio.ucsf.edu [169.230.79.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB1BDA
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2023 00:50:52 -0700 (PDT)
X-Virus-Scanned: amavisd-new at guitar.compbio.ucsf.edu
Received: from ouray (hal2.cgl.ucsf.edu [169.230.25.10])
        by guitar.compbio.ucsf.edu (Postfix) with ESMTPSA id 9D1CBB021924
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2023 00:43:06 -0700 (PDT)
Authentication-Results: guitar.compbio.ucsf.edu; arc=none smtp.remote-ip=169.230.25.10
ARC-Seal: i=1; a=rsa-sha256; d=salilab.org; s=arc; t=1698651786; cv=none; b=TEQ/k06FiOQ1HyvYZjskjMOfIVsWN4j84rb/c7Lg2gxZTDxJO6rR1NUPS1eq+O66hA0qWdsNXsQ7UKQI6xEFJ5XlzcVCJbofAEZ9K3w7qd3ObcjvIRmJQVKbdgaUgodrb1SPSQPYjUPYTTiCyMFv8hbzDioqorRmlenrrmME1/g=
ARC-Message-Signature: i=1; a=rsa-sha256; d=salilab.org; s=arc; t=1698651786;
        c=relaxed/simple; bh=gONhFudogJLX+YSpf9Av6Ocd2fMYnjoVnrRAesP8hCs=;
        h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=EqU/Acoq+/oXvAjgKXdPHlNjvLecC7YZq/FPpiK05d6MfepCqmHIdgj4lFhfIBh0o98Sn4g59pP4k9ipIdax7SR6PN5kY9C4ma3dj1Fs98oZd5woOx45XRV7SLlgTKDhR2MbH4oudyPaWxfSKv5d6dYihlJkKWX3cgWcitdRGbc=
ARC-Authentication-Results: i=1; guitar.compbio.ucsf.edu
DKIM-Filter: OpenDKIM Filter v2.11.0 guitar.compbio.ucsf.edu 9D1CBB021924
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salilab.org;
        s=default; t=1698651786;
        bh=cbAz7aRn/HrZSQnkINsjvep/8e+HrcfMgy7K9FvY/kQ=;
        h=Date:From:To:Subject:From;
        b=wvhyow6UmfyXHxXwy88h7fnfAwwm/WOMebhkxlBMqR4IscZ6uWAXU16Ht5+qm22hn
         gRtgMktjZPhnX5tB1h4u0a8cliHHH+kNmOK6xqnVLdcy5FHZ1r/iPDZrXT8WTg7Gra
         uqGAAOvueNTx4+d6TOQ4U6IeWmqo4ymC45MXMyyU=
Date:   Mon, 30 Oct 2023 00:43:06 -0700 (PDT)
From:   Joshua Baker-LePain <jlb@salilab.org>
X-X-Sender: jlb@ouray
To:     linux-xfs@vger.kernel.org
Subject: Looking for consultant for crashed FS
Message-ID: <baad4400-aa5a-deb3-0f5f-be61bc56e4a4@salilab.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (guitar.compbio.ucsf.edu [0.0.0.0]); Mon, 30 Oct 2023 00:43:06 -0700 (PDT)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi there.  We have a large BeeGFS system here, and our metadata targets 
use XFS.  The metadata targets run on top of software RAID1 mirrors, and 
BeeGFS mirrors each target across two servers.  Our base OS is CentOS-7 
(up to date).  On Friday, the primary FS of a metadata pair crashed.  We 
successfully failed over to the secondary.  Just a few minutes later, 
though, that FS crashed with the same error message.  We've been 
attempting recovery.  If you are or know a consultant skilled in XFS, 
please have them contact me.  Thank you so much.

For reference, the error message we got was this:

[14074823.591265] XFS (md125): Internal error XFS_WANT_CORRUPTED_GOTO at line 3305 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_inobt_insert_rec+0x1f/0x30 [xfs]
[14074823.606436] CPU: 43 PID: 173948 Comm: Worker34 Kdump: loaded Not tainted 3.10.0-1160.90.1.el7.x86_64 #1
[14074823.616581] Hardware name: Supermicro Super Server/X11DDW-L, BIOS 3.1 04/30/2019
[14074823.624695] Call Trace:
[14074823.627781]  [<ffffffffa4bb1bec>] dump_stack+0x19/0x1f
[14074823.633655]  [<ffffffffc073ebaf>] xfs_error_report+0x3f/0x50 [xfs]
[14074823.640550]  [<ffffffffc07290cf>] ? xfs_inobt_insert_rec+0x1f/0x30 [xfs]
[14074823.647933]  [<ffffffffc0716723>] xfs_btree_insert+0x1e3/0x1f0 [xfs]
[14074823.654992]  [<ffffffffc07290cf>] xfs_inobt_insert_rec+0x1f/0x30 [xfs]
[14074823.662175]  [<ffffffffc072c003>] xfs_difree_finobt+0xb3/0x200 [xfs]
[14074823.669215]  [<ffffffffc072c273>] xfs_difree+0x123/0x1d0 [xfs]
[14074823.675690]  [<ffffffffc0750c23>] xfs_ifree+0x83/0x150 [xfs]
[14074823.681989]  [<ffffffffc0750db8>] xfs_inactive_ifree+0xc8/0x230 [xfs]
[14074823.689087]  [<ffffffffc0750fab>] xfs_inactive+0x8b/0x140 [xfs]
[14074823.695688]  [<ffffffffc0758805>] xfs_fs_destroy_inode+0x95/0x190 [xfs]
[14074823.702976]  [<ffffffffa467aa4b>] destroy_inode+0x3b/0x70
[14074823.709067]  [<ffffffffa467ab95>] evict+0x115/0x180
[14074823.714583]  [<ffffffffa467af6c>] iput+0xfc/0x190
[14074823.719925]  [<ffffffffa466e8f6>] do_unlinkat+0x1b6/0x2e0
[14074823.726024]  [<ffffffffa4680c84>] ? mntput+0x24/0x40
[14074823.731660]  [<ffffffffa466fa16>] SyS_unlink+0x16/0x20
[14074823.737456]  [<ffffffffa4bc539a>] system_call_fastpath+0x25/0x2a
[14074823.744130] XFS (md125): xfs_inactive_ifree: xfs_ifree returned error -117
[14074823.751684] XFS (md125): xfs_do_force_shutdown(0x1) called from line 1756 of file fs/xfs/xfs_inode.c.  Return address = ffffffffc0750e43
[14074823.795025] XFS (md125): I/O Error Detected. Shutting down filesystem
[14074823.802300] XFS (md125): Please umount the filesystem and rectify the problem(s)


-- 
Joshua Baker-LePain
Wynton Cluster Sysadmin
UCSF
