Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E7DC7F56
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 11:24:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25B0B30408A
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:24:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id q5aLUGg5bqowjsg6 for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 09:24:43 -0700 (PDT)
Message-ID: <53A9A64B.7030808@sandeen.net>
Date: Tue, 24 Jun 2014 11:24:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Metadata CRC error upon unclean unmount
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>	<53A9A295.8030302@sandeen.net>
	<CA+o=1OXJZk2XjZhtEORQesDjb3VGzM1Ddk6DGXwuLhHJUEbjPQ@mail.gmail.com>
In-Reply-To: <CA+o=1OXJZk2XjZhtEORQesDjb3VGzM1Ddk6DGXwuLhHJUEbjPQ@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On 6/24/14, 11:19 AM, Fanael Linithien wrote:
> 2014-06-24 18:08 GMT+02:00 Eric Sandeen <sandeen@sandeen.net>:
>> Do you have any kind of reproducer for this?
> 
> The closest thing to a reliable reproducer I found is:
> dd if=/dev/urandom of=some.file
> <VM reset while dd is still running>
> 
>> Any chance you created an xfs_metadump before the xfs_repair?
> 
> I still have the broken FS, but the dump is 225 MB. Will it be OK if I
> repro it on a clean FS?

absolutely, if you have a recipe starting at mkfs and ending with corruption,
that's even better.

>> What constitutes an "unclean unmount" in your case; a VM reset?  A host
>> crash?
> 
> A VM reset.
> 
>> (This is a VM, right?)
> 
> Right.
> 
>> What sort of block device configuration does it have?
> 
> What do you mean?

Is the VM using a host block device or an image file?
What type of image file, VDI, QCOW, or?
If an image, what type of filesystem hosts the image?
Have you done any "VBoxManage storagectl"-type modifications to virtualbox defaults?

Since this was a guest reset, not a host reset, it doesn't
matter as much, but it's worth getting the details I think.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
