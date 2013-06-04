Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 098DF7CBF
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 04:42:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D1CEAC019
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 02:42:04 -0700 (PDT)
Received: from beta.jouy.inra.fr (mx.jouy.inra.fr [138.102.162.52]) by
	cuda.sgi.com with ESMTP id aUGfOTZI7ezzwh1G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 02:42:02 -0700 (PDT)
Received: from www2jouy (www2jouy [138.102.140.106])
	by beta.jouy.inra.fr (/8.14.4) with ESMTP id r549g0Vf016557
	for <xfs@oss.sgi.com>; Tue, 4 Jun 2013 11:42:00 +0200 (CEST)
Received: from www-data by www2jouy with local (Exim 4.63)
	(envelope-from <sacha.muszlak@jouy.inra.fr>) id 1UjnpS-0004DH-Ik
	for xfs@oss.sgi.com; Tue, 04 Jun 2013 11:46:58 +0200
Message-ID: <20130604114658.16154113ctcvao4k@www2.jouy.inra.fr>
Date: Tue, 04 Jun 2013 11:46:58 +0200
From: smuszlak <sacha.muszlak@jouy.inra.fr>
Subject: Begining of xfs partition destroyed
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,
Sorry for this long email, but I do hope you've got a solution to  
recover my lab's data (mostly unanalysed research data, a big part  
being mostly videos).

Hardware is 3ware 9096SA-4I RAID controler with 16 disks of 931.5M  
totalizing 13.6 To on an lvm xfs formated volume in RAID 5. It is in  
VERIFYING state in the 3ware bios.

I don't now original state of the server as I wasn't it's  
administrator and there isn't much written procedures left. (no idea  
if lvm patritions got expanded and so on)

I guess it was the /data partition of the FreeNAS volume on
lvm with VG called rosalbarray, and one LV

As I saw it with df -h there was a small partion prior to the VG, I  
guess it was a /boot partition on the raid but outside of the lvm.

But I did a mistake. Here it is :
I added a small IDE disk to receve a new FreeNAS OS.
At the formating step to install the os, booting form iso on CD from  
usb-CD reader I was on the other server waiting for the install disk  
to load when the keyboard and mouse switch (with a remotte button)
changed machine inextedly and I hit return on the format step but on  
the wrong device :
FreeNAS installed itself at the begining ot the 13.5T of data thus  
destroying partition information and about 2Go of /data as well as the  
supposedly /boot partition...

Now I ve booted on an crunchbang live cd where I've installed lvm2 package.
And of course what I see are 4 partitions created for FreeNAS and  
"unallocated" free space of 13ish To

Since yesterday I am running
xfs_restore

Regarding data, I beleave disk it is about 50% full with about 5 to 7  
To filled up.
Regarding lvm stucture all I have is speculations that needs to be checked.
Regarding original FreeNAS version, I have found an FreeNAS 8.3 CD and  
it is the one I subsequently used.
Is there a way to recover xfs partition size and data (minus the about  
2Go) from the secondary superblocks and then restore it to a mountable  
state ?

when xfs_repair is over (it takes ages) I will post it's result

for now the output is
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!
attempting to find secondary superblock...
with some
found candidate secondary superblock
-- 
Sacha Muszlak

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
