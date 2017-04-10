Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57610 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752912AbdDJPuC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 11:50:02 -0400
Subject: Re: filesystem dead, xfs_repair won't help
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7ee4173a-93b4-4000-757f-52733a2edcca@sandeen.net>
Date: Mon, 10 Apr 2017 10:49:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org

There is a known firmware bug on Intel 600P drives which
causes corruption with XFS, FWIW.

https://bugzilla.redhat.com/show_bug.cgi?id=1402533

On 4/10/17 4:23 AM, Avi Kivity wrote:
> Today my kernel complained that in memory metadata is corrupt and
> asked that I run xfs_repair.  But xfs_repair doesn't like the
> superblock and isn't able to find a secondary superblock.
> 
> Latest Fedora 25 kernel, new Intel NVMe drive (worked for a few weeks
> without issue).
> 
> Anything I can do to recover the data?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
