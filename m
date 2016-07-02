Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B543D7CA3
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 16:00:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B1AFAC001
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 14:00:37 -0700 (PDT)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com
	[209.85.213.48]) by cuda.sgi.com with ESMTP id 2q0w5HJMz2W7uozH
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Jul 2016 14:00:35 -0700 (PDT)
Received: by mail-vk0-f48.google.com with SMTP id m127so132805749vkb.3
	for <xfs@oss.sgi.com>; Sat, 02 Jul 2016 14:00:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160702201249.GH4917@birch.djwong.org>
References: <CAC5UwBi8Skjx90_XC5Z5B8P+CadawBZ3iUabKtm-2ZvrkgocZQ@mail.gmail.com>
	<20160702201249.GH4917@birch.djwong.org>
From: Nick Fisk <friskyfisk10@googlemail.com>
Date: Sat, 2 Jul 2016 22:00:33 +0100
Message-ID: <CAC5UwBgS-q4e9KQmHNEZ9SNDQ8G9t8=U5+-YVs9vjZ_VCGiokQ@mail.gmail.com>
Subject: Re: High Fragmentation with XFS and NFS Sync
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On 2 July 2016 at 21:12, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Sat, Jul 02, 2016 at 09:52:40AM +0100, Nick Fisk wrote:
>> Hi, hope someone can help me here.
>>
>> I'm exporting some XFS fs's to ESX via NFS with the sync option enabled. I'm
>> seeing really heavy fragmentation when multiple VM's are copied onto the
>> share at the same time. I'm also seeing kmem_alloc failures, which is
>> probably the biggest problem as this effectively takes everything down.
>
> (Probably a result of loading the millions of bmbt extents into memory?)

Yes I thought that was the case.

>
>> Underlying storage is a Ceph RBD, the server the FS is running on, is
>> running kernel 4.5.7. Mount options are currently default. I'm seeing
>> Millions of extents, where the ideal is listed as a couple of thousand when
>> running xfs_db, there is only a couple of 100 files on the FS. It looks
>> like roughly the extent sizes roughly match the IO size that the VM's were
>> written to XFS with. So it looks like each parallel IO thread is being
>> allocated next to each other rather than at spaced out regions of the disk.
>>
>> From what I understand, this is because each NFS write opens and closes the
>> file which throws off any chance that XFS will be able to use its allocation
>> features to stop parallel write streams from interleaving with each other.
>>
>> Is there anything I can tune to try and give each write to each file a
>> little bit of space, so that it at least gives readahead a chance when
>> reading, that it might hit at least a few MB of sequential data?
>
> /me wonders if setting an extent size hint on the rootdir before copying
> the files over would help here...

I've set a 16M hint and will copy a new VM over, interested to see
what happens. Thanks for the suggestion.

>
> --D
>
>>
>> I have read that inode32 allocates more randomly compared to inode64, so I'm
>> not sure if it's worth trying this as there will likely be less than a 1000
>> files per FS.
>>
>> Or am I best just to run fsr after everything has been copied on?
>>
>> Thanks for any advice
>> Nick
>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
