Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37106 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750879AbdBBQAL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Feb 2017 11:00:11 -0500
Subject: Re: 4.9-stable updates for XFS
References: <1486022171-8076-1-git-send-email-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e2f39f4b-b906-5b66-56a3-0cd42fa7a309@sandeen.net>
Date: Thu, 2 Feb 2017 10:00:10 -0600
MIME-Version: 1.0
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>

On 2/2/17 1:55 AM, Christoph Hellwig wrote:
> Hi all,
> 
> below are backports up to 4.10-rc6 for XFS.  I've selected all clear
> bugfixes for reported bugs.  I've skipped the finobt space reservation
> patch for now - I think it is stable material, but I want it to settle
> a bit more first.

fwiw, the finobt space reservation thing also seems to be doing something
odd with allocation on striped storage, unless I'm missing something.

If I stick an xfs_bmap -v into generic/108 after we write the initial
file, we find that it's not stripe aligned with that patch in place,
which seems unexpected.  I haven't yet worked out why, was first trying
to sort out that lvm error propagation problem...

-Eric
