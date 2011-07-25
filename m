Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PBqr5M261376 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 06:52:53 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5F09181B4EE
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 04:52:52 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	wg03kYpg958tm68h for <xfs@oss.sgi.com>;
	Mon, 25 Jul 2011 04:52:52 -0700 (PDT)
Received: by iyf40 with SMTP id 40so4918347iyf.26
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 04:52:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2BBC00.50902@hardwarefreak.com>
References: <CAOJJ1Zp821vD0JbGf5PuNGcW4VX4E_3SfcWYxVA4es2o0pyJXQ@mail.gmail.com>
	<CAOJJ1ZpL89-3xrhJTQgO97AebSSgnmfyM+mah75XOWiyi-wHwQ@mail.gmail.com>
	<20110723113027.162de009@galadriel.home>
	<4E2BBC00.50902@hardwarefreak.com>
Date: Mon, 25 Jul 2011 19:52:52 +0800
Message-ID: <CAOJJ1Zod9BgFCOZkav3zYy3k2wR9ohiN0U0R0sr1QdW5CWzV6g@mail.gmail.com>
Subject: Re: 1 Gb Ethernet based HPC storage deployment plan
From: Lee Eric <openlinuxsource@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Thanks mates. So the typical storage solution for the small size
cluster may use IP SAN as I know before. Yes, I can export the data by
using NFS directly without iSCSI/AoE but is there any good point to
use XFS? I just know XFS is better for parallelized read/write
operations in local disks.

By the way, is there any good advantage to use XFS as the underlying
local filesystem for cluster/distributed/parallel filesystem?

Thanks very much.

Eric

On Sun, Jul 24, 2011 at 2:30 PM, Stan Hoeppner <stan@hardwarefreak.com> wro=
te:
> On 7/23/2011 4:30 AM, Emmanuel Florac wrote:
>> Le Wed, 20 Jul 2011 22:03:33 +0800 vous =E9criviez:
>>
>>> I know it would be better if I can use Lustre but my interconnection
>>> is a little slow. I suspect if it is feasible if using such parallel
>>> file system.
>>>
>>> Does anyone has good idea on this deployment?
>>>
>>
>> For this kind of setup, true cluster filesystems like Lustre,
>> PVFS2/OrangeFS, Gluster, Ceph... would be much better. Striping 20
>> iSCSI volumes across would be awfully dangerous.
>>
>> I'd go with OrangeFS (pvfs.org) because I'm pretty happy with it so far
>> (using XFS as the underlying local filesystem). It's precisely made to
>> agreggate computing clusters storage.
>
> Typically one starts looking at hardware solutions after identifying the
> needs of the target application/workload.
>
> Is the proposed storage cluster system simply a proof of concept
> testbed, or will it actually be tasked with real work? =A0If the latter
> I'd rethink your iSCSI export to NFS server idea. =A0You mentioned only 8
> disks. =A0Just drop them directly into the NFS host and avoid many
> potential headaches down the road.
>
> --
> Stan
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
