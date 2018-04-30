Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33980 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbeD3W0b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 18:26:31 -0400
Date: Mon, 30 Apr 2018 15:26:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: statvfs() return large f_bavail on a 10TB drive
Message-ID: <20180430222628.GA22891@magnolia>
References: <c126c0a025db7e4011b4461c1ff26601@mail.gmail.com>
 <20180413154313.GC32099@magnolia>
 <3bd0697599c117cfd4db6431a2cba270@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3bd0697599c117cfd4db6431a2cba270@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirubakaran Kaliannan <kirubak@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 09:56:58AM +0530, Kirubakaran Kaliannan wrote:
> Hi Darrick,
> 
> Yes this looks like the bitflip !
> Do you have seen any occurrence of this before or maybe something related to
> a in-memory corruption ?

Usually only on machines with bad memory or use-after-free bugs in the
kernel.

--D

> Thaks
> -kiru
> 
> -----Original Message-----
> From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
> Sent: Friday, April 13, 2018 9:13 PM
> To: Kirubakaran Kaliannan
> Cc: linux-xfs@vger.kernel.org
> Subject: Re: statvfs() return large f_bavail on a 10TB drive
> 
> On Fri, Apr 13, 2018 at 12:10:19PM +0530, Kirubakaran Kaliannan wrote:
> > Hi All,
> >
> > I have couple of  xfs filesystem  on a 10TB STAT drive.
> >
> > After 50% of filesystem is full, the df –kH is returning a large f_bavail.
> >
> >
> > Filesystem                   Size  Used Avail Use% Mounted on
> > /dev/dm-4                     10T  -12T   22T    - /mnt/a
> > /dev/dm-3                     10T  -12T   22T    - /mnt/b
> >
> > I tried statvfs() and got the same large f_bavail as well,
> >
> >         total filesystem size = 9763506176 KB
> >         total Available size = 21279656740 KB
> 
> 21279656740KB = 0x100000000000 | (about 50% of the space) ?
> 
> Bitflip?
> 
> --D
> 
> >         total used size = -11516150564 KB
> >
> > We are using Ubuntu 3.18.19 Linux kernel/xfs.
> >
> > If I unmount and mount the filesysem back, the f_bavail values are back to
> > normal.
> >
> > Can you please point me, if this is something a known issue got fixed in
> > XFS in the later version, or any lead may help.
> > It is difficult at this point of time to upgrade the XFS for this specific
> > issue.
> >
> > Thanks,
> > -kiru
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
