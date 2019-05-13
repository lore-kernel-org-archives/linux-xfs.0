Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57020 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbfEMPGD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 11:06:03 -0400
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513140943.GC61135@bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <683a9b7b-ad5c-5e91-893e-daaa68a853c9@sandeen.net>
Date: Mon, 13 May 2019 10:06:02 -0500
MIME-Version: 1.0
In-Reply-To: <20190513140943.GC61135@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Tim Smith <tim.smith@vaultcloud.com.au>
Cc: linux-xfs@vger.kernel.org

On 5/13/19 9:09 AM, Brian Foster wrote:
> We can (temporarily) fix the issue by unmounting and running
> `xfs_repair` on the filesystem, but it soon reoccurs.

I'm kind of interested in what xfs_repair finds in this case.

However, 4.15 is about a year an a half old, so this list may not be
the best place for support.

> $ lsb_release -a
> No LSB modules are available.
> Distributor ID: Ubuntu
> Description: Ubuntu 16.04.5 LTS
> Release: 16.04
> Codename: xenial

LTS is "Long Term Support" right?  So I'd suggest reaching out to your
distribution for assistance unless you can demonstrate the problem
on a current upstream kernel.

-Eric
