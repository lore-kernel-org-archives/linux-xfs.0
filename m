Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:34202 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbeLCPsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 10:48:16 -0500
Subject: Re: [PATCH] fs/xfs: Add support for passing write life-time hint with
 log
References: <CGME20181203131558epcas2p14b6b38cb67d4915b1ba782e11ce7ffe6@epcas2p1.samsung.com>
 <1543842769-6363-1-git-send-email-joshi.k@samsung.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <f3d25c5b-6a96-397c-d947-370867401a83@applied-asynchrony.com>
Date: Mon, 3 Dec 2018 16:48:12 +0100
MIME-Version: 1.0
In-Reply-To: <1543842769-6363-1-git-send-email-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kanchan Joshi <joshi.k@samsung.com>, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

On 12/3/18 2:12 PM, Kanchan Joshi wrote:
> Log gets updated in a circular fashion, and that makes life-time
> of log-data different from other types of meta/user-data.
> By passing a write life-time hint with log, GC efficiency of multi-stream SSD
> gets improved, leading to endurance/performance benefits.
> It is described in greater detail (along with results) in this "FAST 2018"
> paper -
> https://www.usenix.org/conference/fast18/presentation/rho
>                                                                                  
> This patch introduces new mount option "logwritehint" to pass write hint
> with XFS log.

Is there any downside to passing the hints unconditionally?
Introducing a new mount option which depends on the internals of
an SSD seems .. unlikely to gain many friends.
Otherwise a great idea. :)

-h
