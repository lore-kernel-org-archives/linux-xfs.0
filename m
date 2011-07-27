Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RHHaab213955 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 12:17:36 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B60A5182EABF
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 10:17:35 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id 6JACKvdBMcGwOzCm for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 10:17:35 -0700 (PDT)
Date: Wed, 27 Jul 2011 13:17:35 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
In-Reply-To: <201107271900.11091.sweet_f_a@gmx.de>
Message-ID: <alpine.DEB.2.02.1107271316140.1451@p34.internal.lan>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<4E303F6F.8010706@netapp.com> <201107271900.11091.sweet_f_a@gmx.de>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ruediger Meier <sweet_f_a@gmx.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Bryan Schumaker <bjschuma@netapp.com>



On Wed, 27 Jul 2011, Ruediger Meier wrote:

> On Wednesday 27 July 2011, Bryan Schumaker wrote:
>> On 07/27/2011 12:28 PM, Justin Piszcz wrote:
>>> On Wed, 27 Jul 2011, J. Bruce Fields wrote:
>>>>
>>>> What filesystem on the server are you exporting?
>>>
>>> xfs.
>>> /dev/sda1 on / type xfs (rw,noatime)
>>>
>>> Nothing special, thoughts?
>>
>> Are there a lot of files in the directory you're exporting?  It looks
>> like cookie 10272 is mapped to multiple files.
>
> I thought xfs is immune to readdir loops!?
> Is your export directory really located directly within / on /dev/sda1?

Hi,

I was sharing out a directory on the NFS server:
/d1         192.168.0.0/24(async,rw,no_root_squash,no_subtree_check,fsid=1)

Should I share out / instead?
Is this a known problem?

$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1              30G   13G   18G  43% /
tmpfs                 2.0G  8.0K  2.0G   1% /lib/init/rw
udev                   10M  192K  9.9M   2% /dev
tmpfs                 2.0G     0  2.0G   0% /dev/shm
$

Justin.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
