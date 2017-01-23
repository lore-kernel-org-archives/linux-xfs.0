Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54562 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdAWNxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 08:53:52 -0500
Date: Mon, 23 Jan 2017 05:53:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS issues with NVMe SSD
Message-ID: <20170123135348.GA25320@infradead.org>
References: <8a562e13-6d86-d9ef-de22-f71d5aa79b60@jlbond.com>
 <dbcc14e5-73e7-4ba0-22d2-646d3e466927@sandeen.net>
 <20170123135048.GB33287@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170123135048.GB33287@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Bond Masuda <bond.masuda@jlbond.com>, linux-xfs@vger.kernel.org

On Mon, Jan 23, 2017 at 08:50:48AM -0500, Brian Foster wrote:
> Since this is limited hardware (I don't have access to such hardware, at
> least), it might also be helpful to see if you can isolate the problem
> from a full distro install. For example, can you format such a device
> external to the rootfs, mount, copy some stuff and reproduce the
> corruption after some sequence of unmount/remount/reboot operations?

I have plenty of NVMe hardware, although none of them is Intel and I've
never seen corruption like that.  I also don't run Fedora, though :)

Does anyone know if the Fedora installer does a fstrim run or something
similar?  I remember that most Intel NVMe devices had some pretty severe
deallocate (aka discard on NVMe) bugs.  A firmware update might be a
good start in that case.
