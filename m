Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39244 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751036AbdJBNg1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Oct 2017 09:36:27 -0400
Subject: Re: Suggested XFS setup/options for 10TB file system w/ 18-20M files.
References: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fb88053a-873d-92f9-198d-ee8d4f841658@sandeen.net>
Date: Mon, 2 Oct 2017 08:36:26 -0500
MIME-Version: 1.0
In-Reply-To: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "R. Jason Adams" <rjasonadams@gmail.com>, linux-xfs@vger.kernel.org



On 10/2/17 8:14 AM, R. Jason Adams wrote:
> Hello,
> 
> I have a use case where I'm writing ~500Kb (avg size) files to a 10TB XFS file systems. Each of system has 36 of these 10TB drives.

On what version of kernel & what version of xfsprogs?

> The application opens the file, writes the data (single call), and closes the file. In addition there are a few lines added to the extended attributes. The filesystem ends up with 18 to 20 million files when the drive is full. The files are currently spread over 128x128 directories using a hash of the filename.

It's not uncommon for application filename hashing like this to be less efficient than the internal xfs directory algorithms, FWIW.

> The format command I'm using:
> 
> mkfs.xfs -f -i size=1024 ${DRIVE}

Why 1k inodes?

> Mount options:
> 
> rw,noatime,attr2,inode64,allocsize=2048k,logbufs=8,logbsize=256k,noquota

Why all these options?
 
> As the drive is filling, the first few % of the drive seems fine. Using iostat the avgrq-sz is close to the average file size. What I'm noticing is as the drive starts to fill (say around 5-10%) the reads start increasing (r/s in iostat). In addition, the avgrq-sz starts to decrease. Pretty soon the r/s can be 1/3 to 1/2 as many as our w/s. At first we thought this was related to using extended attributes, but disabling that didn’t make a difference at all.
> 
> Considering I know the app isn’t making any read request, I’m guessing this is related to updating metadata etc. Any guidance on how to resolve/reduce/etc? For example, would a different directory structure help (more files in less directories)?

Perhaps it's taking time reading through a large custom-hashed directory tree?  I don't know what that custom directory layout might look like.

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

Have you tried starting with defaults, and working your way up from there (if needed?)

Thanks,
-Eric


> Thanks,
> R. Jason Adams
