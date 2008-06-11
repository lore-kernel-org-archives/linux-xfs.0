Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 17:00:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5B003Fn000620
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 17:00:05 -0700
Date: Wed, 11 Jun 2008 10:01:08 +1000
Subject: Re: Probems with xfs_repair on large filesystem and 32bit OS.
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <6A32BC807C106440B7E23208F280DDAF01D3F6C8A8@bcmail1.VIDMARK.LOCAL> <20080610115038.GD3005@sillage.bis.pasteur.fr> <6A32BC807C106440B7E23208F280DDAF01D3F6C8B4@bcmail1.VIDMARK.LOCAL>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ucj4z6qj3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <6A32BC807C106440B7E23208F280DDAF01D3F6C8B4@bcmail1.VIDMARK.LOCAL>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lance Reed <lreed@brightcove.com>, Tru Huynh <tru@pasteur.fr>
Cc: "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

On Tue, 10 Jun 2008 22:07:18 +1000, Lance Reed <lreed@brightcove.com>  
wrote:

> SO, I take it from what you say that that I can running any newer  
> version of xfs progs and a 64bit host (fiber attached, easy to do this),  
> and run xfs_repair on the 32bit XFS volumes without fear of data  
> corruption?
> Is this because XFS is not version specific, and xfs_repair will honor  
> the 32bit file data structures?
>
> Again thanks so much for your response!

As Christoph said, you can run 64-bit kernel/xfsprogs on a filesystem
used in a 32-bit kernel without problems.

You'll also find that xfsprogs 2.9.4 and later is more memory optimised
than the 2.8.x series. It may even work on your filesystem in 32-bit
mode. I can't guarantee that though as you never actually specified
the size of your filesystem and how many inodes are on it. I can repair a
9TB filesystem on a 2GB machine without using swap.

> Lance
> -----Original Message-----
> From: Tru Huynh [mailto:tru@pasteur.fr]
> Sent: Tuesday, June 10, 2008 7:51 AM
> To: Lance Reed
> Subject: Re: Probems with xfs_repair on large filesystem and 32bit OS.
>
> On Tue, Jun 10, 2008 at 07:28:21AM -0400, Lance Reed wrote:
>> So I am having trouble fixing a corrupted <16 TB file system on a 32bit  
>> Linux
>> system:
>>
>>
>> The problem is that xfs_repair dies due to xfs_repair: libxfs_initbuf  
>> can't
>> memalign 4096 bytes: Cannot allocate memory:
>>
>> I found the below post, but the links are dead.
>>
>> I tried upping the system RAM to 12 GB, but the problem still exists,  
>> which I
>> assume is the per process limit of 1-4 GB.
> you are on a 32 bits OS, so I would say are hitting a hard limit per  
> process.
>>
>> So I am looking for advice on how to fix a large 32bit filesystem.  I  
>> see
>> options about running on a 64bit host.  Can I do this with a newer  
>> version of
>> xfs and kernel?  We have many hosts that run 64bit Linux  
>> (2.6.18-8.1.15.el5
>> x86_64) and updated xfs progs.  Is it possible to mount the existing LVM
>> volumes on a new 64bit host with a newer OS and xfs progs and not risk  
>> losing
>> data.  Os details for old and possible new host below:
>>
> My 0.2 cents.
> - you can install a x86_64 CentOS-4 machine and fix it from there
> or
> - you can install a x86_64 CentOS-5 machine and fix it from there
> or
> - upgrade to the **development** versions for CentOS-4 i386 at
> https://projects.centos.org/trac/xfs/
>
> http://people.centos.org/tru/XFS/centos-4/RPMS/i386/xfsprogs-2.9.8-2.c4.i686.rpm
> http://people.centos.org/tru/XFS/centos-4/RPMS/i386/xfsdump-2.2.48-1.c4.i686.rpm
> and the right kmod-xfs  
> http://people.centos.org/tru/XFS/centos-4/RPMS/i386/
>
>> CentOS release 4.4 (Final)
> you should be running 4.6
>> 2.6.9-42.ELsmp  i686 i686 i386 GNU/Linux
> and 2.6.9-67.0.7.ELsmp...
>>
>> Possible new host.:
>>
>> CentOS release 5 (Final)
>> 2.6.18-8.1.15.el5  x86_64
> 2.6.18-53.1.21.el5
>
>> xfsprogs-2.9.4-1.el5.centos
>> xfsdump-2.2.46-1.el5.centos
> or
> http://people.centos.org/tru/XFS/centos-5/RPMS/x86_64/xfsprogs-2.9.8-1.c5.x86_64.rpm
> http://people.centos.org/tru/XFS/centos-5/RPMS/x86_64/xfsdump-2.2.48-1.c5.x86_64.rpm
>
>> kmod-xfs-0.4-1.2.6.18_8.1.15.el5
> or
> http://people.centos.org/tru/XFS/centos-5/RPMS/x86_64/kmod-xfs-0.4-2.2.6.18_53.1.21.el5.x86_64.rpm
>
> Cheers,
>
> Tru
> --
> Dr Tru Huynh          | http://www.pasteur.fr/recherche/unites/Binfs/
> mailto:tru@pasteur.fr | tel/fax +33 1 45 68 87 37/19
> Institut Pasteur, 25-28 rue du Docteur Roux, 75724 Paris CEDEX 15 France
>
>
