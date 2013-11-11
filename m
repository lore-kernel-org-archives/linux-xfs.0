Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E18C7F6B
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 12:23:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E42B73040BA
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 10:23:55 -0800 (PST)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id strfArWerJLM3yVK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 10:23:54 -0800 (PST)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	rABINpZ0012129
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 19:23:52 +0100
Received: from mail2.itwm.fhg.de ([131.246.191.79]:34739)
	by itwm2.itwm.fhg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(/C=DE/ST=Bayern/L=Muenchen/O=Fraunhofer/OU=ITWM/OU=Services/CN=smtp.itwm.fraunhofer.de)(verified=1)
	(Exim 4.74 #1) id 1Vfw9P-0003Ts-E1
	for xfs@oss.sgi.com; Mon, 11 Nov 2013 19:23:51 +0100
Message-ID: <528120B7.9030802@itwm.fraunhofer.de>
Date: Mon, 11 Nov 2013 19:23:51 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: ag selection
References: <l5r3tf$m0j$1@ger.gmane.org>	<20131111175313.GA16643@orion.maiolino.org>
	<20131111175550.GB16643@orion.maiolino.org>
In-Reply-To: <20131111175550.GB16643@orion.maiolino.org>
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

On 11/11/2013 06:55 PM, Carlos Maiolino wrote:
> On Mon, Nov 11, 2013 at 03:53:14PM -0200, Carlos Maiolino wrote:
>> On Mon, Nov 11, 2013 at 06:25:13PM +0100, Bernd Schubert wrote:
>>> Hi all,
>>>
>>> for streaming writes onto a raid6 the current round-robin ag
>>> selection seems does not seem to be optimal. Writing 4 files from 4
>>> threads into a single directory we get 900 MB/s, writing 4 files in
>>> 4 different directories we only get 700 MB/s (12 disks with with hw
>>> megaraid-sas). The current round-robin scheme seems to be optimized
>>> for linear raid0? With small AGs one could also argue, that choosing
>>> AGs which are not far away from each other (in respect to the number
>>> of blocks) also adds more parallel disk access for small and medium
>>> sized files.
>>>
>>> Any objections against a patch to improve the AG selection?
>>>
>>
>> I wouldn't say this it is optimized specifically for raid 0 environments but I
>> lack some knowledge on this choice. The mainly reason for the round-robing IIRC,
>> was to avoid lock contention in a single AG. spreading different files along the
>> whole disk, and also making it able to allocate them contiguously along the disk.
>>
> Lock contention in inodes and blocks B-Trees for example, improving parallelism
> in the filesystem, but of course this might not be the optimal behavior for all

Agreed, more locks help to avoid that.

> environments. That's why XFS has a long list of tuning mkfs/mount options :-)
> 
>> But, I'm not sure what kind of optimization you have in mind and I believe
>> another engineers will also need some extra information about what optimization
>> you have in mind, what kind of tests you're doing (Direct I/O, buffered,
>> pre-allocation), etc.. You'll also need to post filesystem configurations like
>> FS aligment (su, sw options), etc.

One of my colleagues benchmarked this on one of our fast systems and another 
colleague current needs this system for other tests, so I don't have the 
exact parameters. However, it was for sure formated with options like these:

mkfs.xfs -d su=256k,sw=10 -l version=2,su=256k -isize=512 /dev/sdX

and mounted with these options:

mount -onoatime,nodiratime,largeio,inode64,swalloc,allocsize=131072k,nobarrier /dev/sdX <mountpoint>


>>
>> For different write patterns, you might also want to take a look at the
>> rotor_step procfs option, and some other options dedicated to streaming writes,
>> that might help you in this case.

Thanks, I didn't know that knob, I'm going to look into it. 
According to the comments its for inode32 only, but I need 
to read the xfs_alloc code first to see what it actually 
does. 



Thanks,
Bernd



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
