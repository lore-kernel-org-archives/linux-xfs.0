Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PEbthp005927 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 09:37:55 -0500
Received: from mail-yi0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A431615F65F1
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 07:37:53 -0700 (PDT)
Received: from mail-yi0-f53.google.com (mail-yi0-f53.google.com
	[209.85.218.53]) by cuda.sgi.com with ESMTP id 9DXOSOslmPW49WWf
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 07:37:53 -0700 (PDT)
Received: by yic15 with SMTP id 15so2617462yic.26
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 07:37:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2D767D.3020801@hardwarefreak.com>
References: <CAOJJ1Zp821vD0JbGf5PuNGcW4VX4E_3SfcWYxVA4es2o0pyJXQ@mail.gmail.com>
	<CAOJJ1ZpL89-3xrhJTQgO97AebSSgnmfyM+mah75XOWiyi-wHwQ@mail.gmail.com>
	<20110723113027.162de009@galadriel.home>
	<4E2BBC00.50902@hardwarefreak.com>
	<CAOJJ1Zod9BgFCOZkav3zYy3k2wR9ohiN0U0R0sr1QdW5CWzV6g@mail.gmail.com>
	<4E2D767D.3020801@hardwarefreak.com>
Date: Mon, 25 Jul 2011 22:37:53 +0800
Message-ID: <CAOJJ1ZpyZ9gW6Nj7RaHGgpRbnt_1THXBbZxvS2Xwam+DPWKM=g@mail.gmail.com>
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

Thanks Stan. Well, because the size of cluster is not very big so
here's what I considered on its storage deployment. The users home
directory and data will be stored in OpenAFS. And also as I mentioned
in the first thread, 8 SATA disks will be used by using IP SAN to
share with compute nodes.

Some file systems I considered but not sure. Lustre, I know it has
good performance but I just use GigaEther network environment in this
cluster hence I am not pretty sure the performance would be good
seemed only high speed storage connected network can get good result.
GFS2, yeah, I ever heard about some institutes use such distributed
file systems for cluster computing field but still no evidence for its
scalability and performance. So my simple way just to use XFS as
underlayer and export it by using NFS.

For the real workload, I run bioinformatics software actually. They
may write many large or small files as parallel computing to the
storage.

Thanks.

Eric

On Mon, Jul 25, 2011 at 9:58 PM, Stan Hoeppner <stan@hardwarefreak.com> wro=
te:
> On 7/25/2011 6:52 AM, Lee Eric wrote:
>> Thanks mates. So the typical storage solution for the small size
>> cluster may use IP SAN as I know before. Yes, I can export the data by
>> using NFS directly without iSCSI/AoE but is there any good point to
>> use XFS? I just know XFS is better for parallelized read/write
>> operations in local disks.
>>
>> By the way, is there any good advantage to use XFS as the underlying
>> local filesystem for cluster/distributed/parallel filesystem?
>
> Narrow down your candidate list of distributed filesystems and read the
> documentation for each of them. =A0I'd guess that each one of them has a
> recommendation of some sort for the local storage node filesystem and
> the reasoning behind the recommendation. =A0Given the manner in which most
> of them derive their parallel performance, the local filesystem is
> likely not critical.
>
> You mentioned an IP SAN. =A0Have you looked at GFS2 and OCFS? =A0You have=
n't
> mentioned a workload. =A0We could better serve you if you described the
> workload.
>
> --
> Stan
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
