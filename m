Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbeLCQfR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 11:35:17 -0500
Date: Mon, 3 Dec 2018 08:34:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs/xfs: Add support for passing write life-time hint
 with log
Message-ID: <20181203163457.GW8125@magnolia>
References: <CGME20181203131558epcas2p14b6b38cb67d4915b1ba782e11ce7ffe6@epcas2p1.samsung.com>
 <1543842769-6363-1-git-send-email-joshi.k@samsung.com>
 <f3d25c5b-6a96-397c-d947-370867401a83@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3d25c5b-6a96-397c-d947-370867401a83@applied-asynchrony.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>, linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 04:48:12PM +0100, Holger Hoffstätte wrote:
> On 12/3/18 2:12 PM, Kanchan Joshi wrote:
> > Log gets updated in a circular fashion, and that makes life-time
> > of log-data different from other types of meta/user-data.
> > By passing a write life-time hint with log, GC efficiency of multi-stream SSD
> > gets improved, leading to endurance/performance benefits.
> > It is described in greater detail (along with results) in this "FAST 2018"
> > paper -
> > https://www.usenix.org/conference/fast18/presentation/rho
> > This patch introduces new mount option "logwritehint" to pass write hint
> > with XFS log.
> 
> Is there any downside to passing the hints unconditionally?

Why wouldn't we always pass LIFE_EXTREME?  Do people have setups where,
say, hint <= LIFE_MEDIUM gets a disk but anything longer than that gets
a big slow stone tablet, which is not where we'd want the metadata log?

For that matter, should we be passing write hints for other fs metadata?
Fixed AG headers never move, should they be LIFE_whateverthelogis ?  How
about space and file metadata, which aren't fixed to certain locations?

> Introducing a new mount option which depends on the internals of
> an SSD seems .. unlikely to gain many friends.
> Otherwise a great idea. :)

Likewise, I'm not wild about adding mount options or passing raw
integers via mount(8) command line:

mount /dev/fd0 /mnt -o logwritehint=3 # ???

--D

> -h
