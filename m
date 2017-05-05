Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38222 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbdEETUh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 15:20:37 -0400
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <63a045ae-0c12-e1b7-a7e0-df251dd88a4f@sandeen.net>
Date: Fri, 5 May 2017 14:20:36 -0500
MIME-Version: 1.0
In-Reply-To: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

On 5/5/17 5:29 AM, Gionatan Danti wrote:
> Hi all, I have a question about multiple mounts protection in XFS.
> 
> On the iSCSI list, discussing how to avoid accidental multiple
> mounts, I received the following advise: "Use XFS. XFS won't let you
> mount it several time on different machines without various "force"
> options."
> 
> I just tried mounting an exported iSCSI disk formatted with XFS and I
> *can* mount it concurrently on two different Linux boxes (both CentOS
> 7.3 x86-64).
> 
> I am missing something? Thanks.

I guess this has been covered, but: no.  There is no cross-machine
multi-mount protection in XFS.  Nothing like ext4's MMP.

There is a unique UUID test at mount time, so you can't i.e. mount
the same path twice /on the same box/, but there is no mechanism in
XFS to prevent the same disk from being mounted by 2 /separate/ machines
on a SAN.

-Eric
 
