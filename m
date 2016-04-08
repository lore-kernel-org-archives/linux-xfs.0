Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1BACA7CA7
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 15:49:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E3BB98F8052
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 13:49:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HNjM8SQHYsHARC2R for <xfs@oss.sgi.com>;
	Fri, 08 Apr 2016 13:49:18 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A411316C16D
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 15:49:17 -0500 (CDT)
Subject: Re: Use latest xfs_repair on older file systems
References: <CAD4UnC8M32_GO1+2rfi=v6f3R02T70dhxQJeZtnGFi_muL2z9g@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5708194D.4080406@sandeen.net>
Date: Fri, 8 Apr 2016 15:49:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAD4UnC8M32_GO1+2rfi=v6f3R02T70dhxQJeZtnGFi_muL2z9g@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 4/8/16 3:37 PM, Chris M Moser wrote:
> Hello,
> 
> I have a file system that experienced issues and would not mount. The
> system would not boot either as this file system was listed in
> /etc/fstab. I booted to a debian image with xfsprogs 3.2.1 and ran
> xfs_repair
> 
> The host OS now boots and the file system mounts but has only a
> handful of the original files. I unmounted and ran xfs_repair 2.9.4
> form the host OS a few more times. (I read somewhere that running
> xfs_repair multiple times can find more files) I still see the same
> handful of files.
> 
> A previous thread
> (http://oss.sgi.com/archives/xfs/2014-06/msg00204.html) suggests
> running the latest xfs_repair as it may be able to reattach more
> files.
> 
> I booted to a fedora 23 live image and updated xfsprogs to 4.5.0.
> (openSUSE Tumbleweed has xfsprogs 4.5.0 but I was not able to get
> their live image working) When running xfs_repair on the file system
> it complains: xfs_repair: V1 inodes unsupported. Please try an older
> xfsporgs.
> 
> Is it reasonable to assume that xfs_repair has done all it can and I
> should now use photorec from the testdisk package to recover what I
> can?

Yes, unfortunately.

In general, using the latest xfs_repair is a good idea.  And in general,
a single pass of xfs_repair should be enough.

In some cases, there are features which only newer xfs_repair understands - 
but older versions should simply refuse to run in that case.

Obsolete features do occasionally get dropped upstream, as well - witness
your V1 inode message.  However, that was likely just some other form of
corruption, seen as V1 inodes, unless this really was a very, very old
filesystem (created prior to 2007), which seems unlikely.

It sounds like you experienced some very severe corruption; if that is the
case, you might start by making sure your storage devices are in decent
shape.

Oh, and look in lost+found, if most files seem to be "gone" - they may
be there.

-Eric

> Thank you for your feedback.
> 
> -Chris
> 
> -- 
> Christopher M Moser
> 
> Seagate Technology LLC
> Cluster Lab Administrator
> NRM Bldg A/A1-3
> chris.m.moser@seagate.com <mailto:chris.m.moser@seagate.com>
> 952-402-8269
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
