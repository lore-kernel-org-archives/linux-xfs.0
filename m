Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ADC947F76
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 19:56:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B828304059
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 17:56:09 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id qWfibZO8V14uc7E6
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 17:56:08 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id E19916C162
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 19:56:07 -0500 (CDT)
Message-ID: <5154E6AC.9020402@hardwarefreak.com>
Date: Thu, 28 Mar 2013 19:56:12 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Help with XFS in VMs on VMFS
References: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
	<51549F09.1090109@hardwarefreak.com>
	<20130328214550.GA3771@pirx.askja.de>
In-Reply-To: <20130328214550.GA3771@pirx.askja.de>
Reply-To: stan@hardwarefreak.com
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

On 3/28/2013 4:45 PM, Ralf Gross wrote:
> Stan Hoeppner schrieb:

> Snapshots are possible with RDM in virtual compatibily mode, not
> physical mode (> 2 TB).

So 2TB is the kicker here.  I haven't used ESX since 3.x, and none of
our RDMs back then were close to 2TB.  IIRC our largest was 500GB.

>> VMFS volumes are not intended for high performance IO.  Unless things
>> have changed recently, VMware has always recommended housing only OS
>> images and the like in VMDKs, not user data.  They've always recommended
>> using RDMs for everything else.  IIRC VMDKs have a huge block (sector)
>> size, something like 1MB.  That's going to make XFS alignment difficult,
>> if not impossible.
> 
> I can't remember that I've every found this recommendation on a vmware
> page.
> 
> http://blogs.vmware.com/vsphere/2013/01/vsphere-5-1-vmdk-versus-rdm.html

If you drill down through that you find this:
http://www.vmware.com/files/pdf/performance_char_vmfs_rdm.pdf

RDMs have better large sequential performance, and lower CPU burn than
VMDKs.  The OP mentioned "compute node" in his post, which suggests an
HPC application workload, which suggests large sequential IO.

Also note that VMware is Microsoft centric so they always run their
tests using an MS Server guest.  Also note they always test with tiny
volumes, in this case 20GB.  NTFS isn't going to have any trouble at
this size, but at say 20TB it probably will and these published results
would likely be quite different at that scale.  XFS performance
characteristics on a 2TB or 20TB or ?? TB volume will likely be
substantially different than NTFS.  Their tests show 5-8% lower CPU burn
for RDM vs VMDK.  Not a huge difference, but again they're testing only
20GB.

>> I cannot stress emphatically enough that you should not stitch 2TB VMDKs
>> together and use them in the manner you described.  This is a recipe for
>> disaster.  Find another solution.
> 
> I'm seeing more and more requests for VMs with large disks lately in my
> env. Right now the max. is ~2 TB. I'm also thinking about where to go,
>  > 2 TB ist only possible with pRDMs which can't be snapshotted. You
> have to use the snapshot features of your storage array.

And more and more folks are using midrange FC/iSCSI arrays that don't
have snapshot features, others are using DAS with RAID HBAs, in both
cases forcing them to rely on ESX snapshots.  Sounds like VMware needs
to bump this artificial 2TB limit quite a bit higher.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
