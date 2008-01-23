Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 18:50:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0N2oZQj009704
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 18:50:39 -0800
Date: Wed, 23 Jan 2008 13:51:41 +1100
Subject: Re: xfs_rapair memory requirement per TB
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <1201042882.32649.256.camel@holwrs01.bp.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t5c3kfub3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <1201042882.32649.256.camel@holwrs01.bp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rene Salmon <salmr0@bp.com>, xfs@oss.sgi.com

On Wed, 23 Jan 2008 10:01:22 +1100, Rene Salmon <salmr0@bp.com> wrote:

> Hi,
>
> Reading the "Repairing a possibly incomplete xfs_growfs command?" thread
> this month makes me wonder if there is some type of rough formula or
> guesstimation cheat sheet to figure out how much memory and swap one
> would need for an xfs_repair given a file system with many terabytes.
>
>
> Say I have an 8TB LUN that needs an xfs_repair.  What would be the rough
> memory requirements and swap space?
>

General rule of thumb at the moment is 128MB of RAM/TB of filesystem
plus 4MB/million inodes on that filesystem.

Barry.
