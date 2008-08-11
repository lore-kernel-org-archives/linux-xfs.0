Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 16:51:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7BNpVuL025222
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 16:51:31 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED76112F334A
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 16:52:48 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id F7xgDsO4Khasqw8k for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 16:52:48 -0700 (PDT)
Date: Tue, 12 Aug 2008 09:52:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corruption of in-memory data detected - on heavy  hard linking
Message-ID: <20080811235244.GF6119@disturbed>
References: <48876D03.8010804@stepping-stone.ch> <20080725052051.GA26367@infradead.org> <489732B2.7000201@stepping-stone.ch> <20080805001952.GI6119@disturbed> <48A02FF6.70703@stepping-stone.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48A02FF6.70703@stepping-stone.ch>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Affolter <c.affolter@stepping-stone.ch>
Cc: xfs@oss.sgi.com

On Mon, Aug 11, 2008 at 02:26:30PM +0200, Christian Affolter wrote:
> Hi Dave
>
>>>> On Wed, Jul 23, 2008 at 07:40:19PM +0200, Christian Affolter wrote:
>>>>> Kernel-Error:
>>>>> Filesystem "sdc1": XFS internal error xfs_trans_cancel at line 
>>>>> 1163 of  file fs/xfs/xfs_trans.c.  Caller 0xffffffff803a4fcf
>>>>> Pid: 22816, comm: cp Not tainted 2.6.24-gentoo-r8 #1
>>>> 2.6.24 is pretty old.  Did you try with a recent kernel?  We had some
>>>> fixes for in-core memory corruption although I don't remember one in
>>>> this area.
>>> I finally found the time to update the kernel to a recent 2.6.26 version.
>>>
>>> Unfortunately the problem still exists:
>>> Filesystem "dm-3": XFS internal error xfs_trans_cancel at line 1163 
>>> of  file fs/xfs/xfs_trans.c.  Caller 0xffffffff803a6672
>>> Pid: 12584, comm: cp Not tainted 2.6.26-gentoo #1
>>
>> Ok, what we need is the following. First, try to reproduce the
>> problem on a small filesystem (say a few GB). Once you've reproduced
>> the problem, unmount and remount the filesystem to get the log
>> replayed, then take a xfs_metadump image of the filesystem. Put the
>> metadump image somewhere that can be downloaded (ftp/web site) and
>> let us know where it is.
> Please excuse the delay, it took some time to reproduce the issue with  
> newly generated nonsensitive data...

You probably didn't need to do that. from the man page:

	By default, xfs_metadump obfuscates most file (regular file,
	directory and symbolic link) names and extended attribute names to
	allow the dumps to be sent without revealing confi‐ dential
	information. Extended attribute values are zeroed and no data is
	copied. The only exceptions are file or attribute names that are 4
	or less characters in length. Also file names that span extents
	(this can only occur with the mkfs.xfs(8) options where -n size > -b
	size) are not obfuscated. Names between 5 and 8 characters in length
	inclusively  are partially obfuscated.

> However while looking at the meta dump (with the help of the strings  
> command), a lot of non-existing file names appears. Non-existing in the  
> sense of not present on this device, they may exist on other devices,  
> but they definitely were never on the dumped device (the device was  
> filled with /dev/zero before creating the xfs filesystem).

That's the obfuscation.

> Therefor I'm a bit scared to place the dump publicly on the internet,  
> might it be possible to put it somewhere with user/pw protection and  
> hand the credentials to you privately?

Sure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
