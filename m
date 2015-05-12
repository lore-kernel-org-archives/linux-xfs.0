Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B95B97F3F
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 07:41:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3510EAC002
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 05:41:48 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id ahRKhf6by8qelE7p (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 05:41:46 -0700 (PDT)
Message-ID: <5551F508.2000508@profihost.ag>
Date: Tue, 12 May 2015 14:41:44 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: any chance for xfs shrinking?
References: <5551EBB2.9010508@profihost.ag> <5551F38A.2050102@sandeen.net>
In-Reply-To: <5551F38A.2050102@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Am 12.05.2015 um 14:35 schrieb Eric Sandeen:
> On 5/12/15 7:01 AM, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> while cloud / vms usage become more and more popular and qemu now also
>> offers memory hot add and unplug, cpu hot add and unplug, we still
>> suffer from a missing xfs shrink.
> 
> Filesystem shrink is a very different scenario than "cloud / vms" needs
> for hot memory & cpu plugging, IMHO.
> 
>> I would like to continue to use XFS as it is a rock solid base since
>> around 10 years for us.
>>
>> But one missing piece in variable ressource usage for us is disk
>> shrinking. Is there any chance to get an xfs online shrinking?
> 
> Under what circumstance does your workflow require a filesystem shrink?

May be special but there are a lot of customers out there who do not
manager their ressources. So they've partners and partners of partners.
It happens quite often that the disk runs out of space and the customer
does not know what he can do as third parties control the waste of
space. So we are in the situation where we need to extent the partition
so the customer can continue his business. Later when the partner has
solved the issue (real world shows mostly 2 days - 3 weeks) the customer
wants to shrink again as he does not want to pay the space.

> Honest question, I'm not challenging you, but I would like to understand
> what it is about shrink that is so critical it may cause you to stop using
> XFS.
> 
> One thing about shrink - while i.e. ext4 supports it, the end result of
> a shrunk filesystem is a scrambled filesystem.  All those heuristics that
> made the filesystem reasonably performant as it aged get thrown out the 
> window as the fs scavenges for space into which to shrink the filesystem...
> 
> That said, another option is to use the dm-thinp target, and allocate /
> de-allocate storage resources to the underlying block device as needed.

We do so while using ceph and trim but the customer pays what he can
theoretically use and not what he uses in real. Ceph also does not
provide a way to show us the real usage of a rbd disk.

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
