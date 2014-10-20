Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 19DC37F4E
	for <xfs@OSS.SGI.com>; Mon, 20 Oct 2014 03:00:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A68C9AC001
	for <xfs@OSS.SGI.com>; Mon, 20 Oct 2014 01:00:41 -0700 (PDT)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com
	[66.111.4.27]) by cuda.sgi.com with ESMTP id 9UR18FAmQuseAy6i
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@OSS.SGI.com>; Mon, 20 Oct 2014 01:00:36 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by gateway2.nyi.internal (Postfix) with ESMTP id 220D1205D2
	for <xfs@OSS.SGI.com>; Mon, 20 Oct 2014 04:00:36 -0400 (EDT)
Message-ID: <5444C122.4080104@fastmail.fm>
Date: Mon, 20 Oct 2014 10:00:34 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
MIME-Version: 1.0
Subject: Re: Problem about very high Average Read/Write Request Time
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>	<20141018143848.3baf3266@galadriel.home>
	<21571.36364.518119.806191@tree.ty.sabi.co.uk>
In-Reply-To: <21571.36364.518119.806191@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg@xfs.list.sabi.co.UK>, Linux fs XFS <xfs@OSS.SGI.com>

On 10/19/2014 12:10 PM, Peter Grandi wrote:
>>> I am using xfs on a raid 5 (~100TB) and put log on external
>>> ssd device, the mount information is: /dev/sdc on
>>> /data/fhgfs/fhgfs_storage type xfs
>>> (rw,relatime,attr2,delaylog,logdev=/dev/sdb1,sunit=512,swidth=15872,noquota).
>>> when doing only reading / only writing , the speed is very
>>> fast(~1.5G), but when do both the speed is very slow (100M),
>>> and high r_await(160) and w_await(200000).
> 
>> What are your kernel version, mount options and xfs_info output ?
> 
> Those are usually important details, but in this case the
> information that matters is already present.
> 
> There is a ratio of 31 (thirty one) between 'swidth' and 'sunit'
> and assuming that this reflects the geometry of the RAID5 set
> and given commonly available disk sizes it can be guessed that
> with amazing "bravery" someone has configured a RAID5 out of 32
> (thirty two) high capacity/low IOPS 3TB drives, or something
> similar.
> 
>   It is even "braver" than that: if the device name
>   "/data/fhgfs/fhgfs_storage" is dedscriptive, this "brave"
>   RAID5 set is supposed to hold the object storage layer of a
>   BeeFS highly parallel filesystem, and therefore will likely
>   have mostly-random accesses.
> 

Where do you get the assumption from that FhGFS/BeeGFS is going to do
random reads/writes or the application of top of it is going to do that?


Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
