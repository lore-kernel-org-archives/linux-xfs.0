Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail2.jlbond.com ([68.15.28.130]:60555 "EHLO mail.jlbond.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750708AbdAXCNh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 21:13:37 -0500
Subject: Re: XFS issues with NVMe SSD
References: <8a562e13-6d86-d9ef-de22-f71d5aa79b60@jlbond.com>
 <dbcc14e5-73e7-4ba0-22d2-646d3e466927@sandeen.net>
 <20170123135048.GB33287@bfoster.bfoster>
 <20170123135348.GA25320@infradead.org>
 <CAJCQCtQnH1PgUf=9gJT=5UpZ8SCGqvN-1rAvO3HLq9nQJkF+eA@mail.gmail.com>
 <325e2a40-0ba6-a973-8ca4-933e44b075a9@sandeen.net>
 <CAJCQCtQ-Ud7cqtX6ub_h+bPmp6qKpOYZMaZCvgbT60G=0QBZGg@mail.gmail.com>
From: Bond Masuda <bond.masuda@jlbond.com>
Message-ID: <8af51363-bcb3-5830-7531-4417ffb099fd@jlbond.com>
Date: Mon, 23 Jan 2017 18:13:34 -0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ-Ud7cqtX6ub_h+bPmp6qKpOYZMaZCvgbT60G=0QBZGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org



On 01/23/2017 01:33 PM, Chris Murphy wrote:
>
> Anaconda requires reformat of any partition used for rootfs, except
> Btrfs where it requires a new subvolume for rootfs.
>
> I've got one of these with Fedora 25 on it, variably using kernels
> 4.5.5 through 4.10-rc4 and haven't had any corruption issues with
> either XFS or Btrfs
> Samsung Electronics Co Ltd NVMe SSD Controller SM951/PM951 [144d:a802]
>
There are only 2 people I know of that have run into this issue, 
including myself. Maybe the issue is hardware specific? If so, the SSD 
model I had this problem with is Intel SSDPEKKW512G7X1. I'm not sure 
what the "other" person who reported this problem has, other than it too 
was an Intel SSD.

The system I had this issue with got shipped to Japan 2 weeks ago and I 
no longer have possession of it. Ended up not putting the OS install on 
the Intel NVMe SSD, but on a SATA SSD. I may have another system 
similarly configured soon - when I get a chance, I'll try to reproduce 
the problem again and try to collect more information.

Bond
