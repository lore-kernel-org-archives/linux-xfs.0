Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36680 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751734AbeERDYQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 23:24:16 -0400
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net>
Date: Thu, 17 May 2018 22:24:13 -0500
MIME-Version: 1.0
In-Reply-To: <20180517192700.23457-6-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On 5/17/18 2:27 PM, Luis R. Rodriguez wrote:
> You may want to stick to specific set of configuration options when
> creating filesystems with mkfs.xfs -- sometimes due to pure technical
> reasons, but some other times to ensure systems remain compatible as
> new features are introduced with older kernels, or if you always want
> to take advantage of some new feature which would otherwise typically
> be disruptive.
> 
> This adds support for parsing a configuration file to override defaults
> parameters to be used for mkfs.xfs.
> 
> We define an XFS configuration directory,/etc/mkfs.xfs.d/  and allow for
> different configuration files, if none is specified we look for the
> default configuration file, /etc/mkfs.xfs.d/default. You can override
> with -c.  For instance, if you specify:
> 
> 	mkfs.xfs -c experimental -f /dev/loop0
> 
> The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> file. If you really need to override the full path of the configuration
> file you may use the MKFS_XFS_CONFIG environment variable.

I'm swamped under a deadline at work this week so just commenting at a
very high level for now, but I'm curious; why use an env var vs
providing a full path for -c ?  env vars always strike me as magic unexpected
behaviors.

# mkfs.xfs -c /my/fancy/path/to/config

seems much clearer than

# export MKFS_XFS_CONFIG=/my/fancy/path/to/
# mkfs.xfs -c config

i.e. if a full path is specified use it, else use the config directory.

Thoughts?

Thanks,
-Eric

> To verify what configuration file is used on a system use the typical:
> 
>    mkfs.xfs -N
> 
> There is only a subset of options allowed to be set on the configuration
> file, and currently only 1 or 0 are acceptable values. The default
> parameters you can override on a configuration file and their current
> built-in default settings are:
> 
> [data]
> noalign=0
> 
> [inode]
> align=1
> projid32bit=1
> sparse=0
> 
> [log]
> lazy-count=1
> 
> [metadata]
> crc=1
> finobt=1
> rmapbt=0
> reflink=0
> 
> [naming]
> ftype=1
> 
> [rtdev]
> noalign=0
> 
> Signed-off-by: Luis R. Rodriguez<mcgrof@kernel.org>
