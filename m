Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbdAWNmA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 08:42:00 -0500
Subject: Re: XFS issues with NVMe SSD
References: <8a562e13-6d86-d9ef-de22-f71d5aa79b60@jlbond.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dbcc14e5-73e7-4ba0-22d2-646d3e466927@sandeen.net>
Date: Mon, 23 Jan 2017 07:41:58 -0600
MIME-Version: 1.0
In-Reply-To: <8a562e13-6d86-d9ef-de22-f71d5aa79b60@jlbond.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bond Masuda <bond.masuda@jlbond.com>, linux-xfs@vger.kernel.org

On 1/21/17 7:20 PM, Bond Masuda wrote:
> Hi linux-xfs list:
> 
> I've been having XFS file system corruption issues when used with
> Intel NVMe SSD in Fedora 25 Linux as reported here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1402533
> 
> I don't know if this is XFS issue or not, but ext4 on the same Intel
> NVMe SSD doesn't appear to be a problem. Are linux/xfs devs already
> aware of the problem?
> 
> Bond 

Well, the bug languished under anaconda, so no, we haven't seen it.

It's pretty light on details.  Please provide the install logs, dmesg output,
xfs_repair output etc.  I'll update the bug.

-Eric
