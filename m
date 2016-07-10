Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 531607CC7
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 04:24:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 12FE08F8035
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 02:24:28 -0700 (PDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id 2J4kmL2UVWA9MJQy
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2016 02:24:27 -0700 (PDT)
Received: by mail-wm0-f53.google.com with SMTP id f65so32804258wmi.0
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 02:24:27 -0700 (PDT)
Subject: Re: xfs + 100TB+ storage + lots of small files + NFS
References: <CACNifpXnSMcm6EfSjqLFPXXfqv7XWd4Yu_=UhqTcdn6-o+49Yw@mail.gmail.com>
From: Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <0f365b8a-16e2-7814-06d2-d452e80c7c07@gmail.com>
Date: Sun, 10 Jul 2016 12:24:22 +0300
MIME-Version: 1.0
In-Reply-To: <CACNifpXnSMcm6EfSjqLFPXXfqv7XWd4Yu_=UhqTcdn6-o+49Yw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Marcin Sura <mailing-lists@sura.pl>, xfs@oss.sgi.com

On 07/09/2016 02:14 PM, Marcin Sura wrote:
> Hi,
>
> Friend of mine asked me about evaluation of XFS for their purposes. Currently 
> I don't have physical access to their system, but here are the info I've got 
> so far:
>
> SAN:
> - physical storage is from FSC array, thin provisioned raid 6 volume,
> - volumes are 100TB+ in size
> - there are SSD disks in the array, which potentially can be used for journal
> - storage is connected to the host via 10GbE iSCSI
>
> Host:
> - They are using CentOS 6.5, with stock kernel 2.6.32-*
> - System uses all default values, no optimization has beed done
> - OS installed on SSD
> - Don't know exact details of CPU, but I assume some recent multicore CPU
> - Don't know amount of RAM installed, I assume 32GB+
>
> NFS:
> - they are exporting filesystem via NFS to 10-20 clients (services), some VMs, 
> some bare metal
> - clients are connected via 1GbE or 10GbE links
>
> Workload:
> - they are storing tens or hundreds of millions of small files
> - files are not in single directory
> - files are undek 1K, usually 200 - 500 bytes
> - I assume, that some NFS clients constantly write files
> - some NFS clients initiates massive reads, millions of random files
> - those reads are on demand, but during peak hours there can be many of such 
> requests
>
> So far they were using Ext4, after some basic test they observed 40% 
> improvement in application counters. But I'm afraid that those tests were done 
> in environment not even close to the production (not so big size of 
> filesystem, not so much files).
>
> I want to ask you what would be best mkfs.xfs settings for such setup.
>
> I assume, that they should use inode64 mount option for such large filesystem 
> with that amount of files, but I'm a bit worried about compatibility with NFS 
> (default shipped with CentOS 6.5). I think inode32 is totally out of scope here.
>
> Any other hints for setting this stuff up?
> Probably some recent OS/kernel would also help a lot, right?
>
> Also, do you know any benchmark which can be used to simulate such workload? 
> I've googled a lot, but there is quite short list of multi-threaded, small 
> files oriented benchmarks. To be honest, I've found only 
> https://github.com/bengland2/smallfile to be close to what I need. Any other 
> alternatives?
>
> BR
> Marcin

I think that is a good test to explore - Ben wrote that for exactly this kind of 
workload.

For a single system (i.e., performance a single NFS client or local file 
system), you could also test using fs_mark.

Regards,
Ric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
