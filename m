Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46766 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750823AbeCCFBl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 3 Mar 2018 00:01:41 -0500
Subject: Re: [RFC v2] mkfs.xfs: add mkfs.xfs.conf parse support using
 libini_config
References: <20180302203228.9622-1-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <deaab496-f413-9f52-21a2-7d7a01da1a59@sandeen.net>
Date: Fri, 2 Mar 2018 23:01:40 -0600
MIME-Version: 1.0
In-Reply-To: <20180302203228.9622-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On 3/2/18 2:32 PM, Luis R. Rodriguez wrote:
> You may want to stick to specific set of configuration options when
> creating filesystems with mkfs.xfs -- sometimes due to pure technical
> reasons, but some other times to ensure systems remain compatible as
> new features are introduced with older kernels, or if you always want
> to take advantage of some new feature which would otherwise typically
> be disruptive.
> 
> Although mkfs.xfs already uses sensible defaults this adds a configuration
> option for parsing defaults settings for mkfs.xfs parsed prior to processing
> input arguments from the command line.
> 
> We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
> different types of configuration files, if none is specified we look for
> the default type, /etc/mkfs.xfs.d/default, and you can override with -t.
> For instance if you specify:
> 
> 	mkfs.xfs -t experimental -f /dev/loop0
> 
> The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> file. If you really need to override the full path of the configuration
> file you may use the MKFS_XFS_CONFIG enviornment variable.
> 
> To use /etc/ be sure to configure xfsprogs with:
> 
>  ./configure --sysconfdir=/etc/
> 
> To verify what configuration file is used on a system use the typical:
> 
>   mkfs.xfs -N
> 
> There is only a subset of options allowed to be set on the conifiguration
> file, and currently only 1 or 0 are acceptable values. They are:
> 
> [data]
> noalign=
> 
> [inode]
> align=
> attr=
> projid32bit=
> sparse=

Hey, can I ask a maybe ridiculous question ...

What's the advantage of haggling over ini file parsers and file formats, vs. just:

# echo "-m crc=0 -n ftype=0" > /etc/mkfs.xfs.d/default

and parse that into defaults exactly as if it had been on the commandline?

-Eric
