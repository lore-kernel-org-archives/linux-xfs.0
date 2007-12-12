Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 16:35:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBC0YrKh021527
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 16:34:56 -0800
Message-ID: <475F2D54.3090609@sgi.com>
Date: Wed, 12 Dec 2007 11:37:40 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs ... lazy-count=1 ... not mountable by older kernels?
References: <475EE83A.3060607@ca.sophos.com> <20071211221554.GC4612@sgi.com>
In-Reply-To: <20071211221554.GC4612@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Sparks <dave@ca.sophos.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:
> On Tue, Dec 11, 2007 at 11:42:50AM -0800, David Sparks wrote:
>> Hi all,
>>
>> Is it expected that filesystems made with lazy-count=1 are not mountable by
>> older kernels?
> 
> That is expected. lazy-count is a mkfs option because it changes the on-disk
> format slightly, and older kernels do not understand that format. Hence
> mkfs sets a superblock feature bit to prevent the filesystem from being
> mounted on kernels that don't understand the slightly different disk format.
> 
> Cheers,
> 
> Dave.

And there will be a message in the logs but it probably isn't
overly obvious what it is talking about.

Looking at code, I presume it will come from:
         if (!XFS_SB_GOOD_VERSION(sbp)) {
                 xfs_fs_mount_cmn_err(flags, "bad version");
                 return XFS_ERROR(EWRONGFS);
         }
so there will be a msg about a "bad version".

--Tim
