Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 00:53:02 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.188])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8K7qtuw017152
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 00:52:57 -0700
Message-ID: <46F223DE.10003@gmx.net>
Date: Thu, 20 Sep 2007 09:40:14 +0200
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: The problem in installing the linux-2.6-xfs kernel
References: <1190260918.24375.4.camel@OpenSUSE-desktop.Home>
In-Reply-To: <1190260918.24375.4.camel@OpenSUSE-desktop.Home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: hxsrmeng@gmail.com
Cc: XFS <xfs@oss.sgi.com>

Hi hxsrmeng,

hxsrmeng schrieb:
> Hi, 
> 
> When I do:
> $/sbin/mkinitrd -k vmlinuz-2.6-xfs -i initrd-2.6-xfs
> 
> I got:
> "
> Filesystem modules:
> WARNING: Couldn't open
> directory /var/tmp/mkinitramfs.C23294/mnt/lib/modules/2.6.23-rc4: No
> such file or directory
> FATAL: Could not
> open /var/tmp/mkinitramfs.C23294/mnt/lib/modules/2.6.23-rc4/modules.dep.temp for writing: No such file or directory
> "
> So, does this mean it failed?
Look's like your mkinitrd can't handle the way the kernel-version is set
-> no working initrd is created.
> 
> If I can still boot this kernel, are the file system features OK?
If you don't need special modules loaded on boot from the initrd, it
should be OK. If not, don't build needed drivers and features as modules.

> Especially, I want to try XFS and "Concurrent Multi-File Data Streams".
> 
> Thanks in advance!
> 
> 

as Eric stated, quite off-topic and very very little info ...

- did you do a make modules_install ?
- where the modules copied to /lib/modules/2.6.23-rc4 ?
- what distro are you using, mkinitrd is totally different by distro and
version!
- is your box running out of diskspace ?
- are there special settings in the distros kernel-sources Makefile ?

If you don't know answers to these questions, you'd rather use the
distros kernel than trying to kernels from other sources ;-).

On SuSE -k list the kernel to use and -i the initrd to create, RedHat  (
for ex. ) is totally different AFAiK!

Perhaps the maintainer of your mkinitrd can help you further.

-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
 X        AGAINST HTML MAIL
/ \
