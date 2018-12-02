Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:46421 "EHLO
        smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbeLBR2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 12:28:25 -0500
Subject: Re: [Bug 201823] inconsistent behaviour of xfs_db, xfs_repair and
 xfs_scrub
References: <bug-201823-201763@https.bugzilla.kernel.org/>
 <bug-201823-201763-SQxbGgt1ty@https.bugzilla.kernel.org/>
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Message-ID: <05431fde-455e-13f3-650d-dcc218d9c22b@bodenbinder.de>
Date: Sun, 2 Dec 2018 18:28:19 +0100
MIME-Version: 1.0
In-Reply-To: <bug-201823-201763-SQxbGgt1ty@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org

Am 02.12.18 um 18:02 schrieb bugzilla-daemon@bugzilla.kernel.org:
> https://bugzilla.kernel.org/show_bug.cgi?id=201823
> 
> --- Comment #5 from Eric Sandeen (sandeen@sandeen.net) ---
> If you'd like to send me a compressed metadump image (offline for maximum
> privacy) I'll take a look.
> 
> However, some of your messages above are a result user error: you are providing
> a block number as an inode number to xfs_db, so it is trying to parse a
> non-inode as an inode.
> 

I will send you a dropbox link to the metadump
