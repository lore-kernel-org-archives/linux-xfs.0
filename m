Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0B927F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 23:32:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B95458F804B
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 21:32:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id s2ztOdFo3ZCFlWKU for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 21:32:30 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 2133360003C3
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 23:32:30 -0600 (CST)
Subject: Re: Which xfsprogs version to which kernel version
References: <5656DD39.8060403@poczta.onet.pl> <20151130214104.GL26718@dastard>
	<2952345.NUOFtjxqgC@merkaba> <20151201202639.GV19199@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565E826D.6040301@sandeen.net>
Date: Tue, 1 Dec 2015 23:32:29 -0600
MIME-Version: 1.0
In-Reply-To: <20151201202639.GV19199@dastard>
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

On 12/1/15 2:26 PM, Dave Chinner wrote:
> On Tue, Dec 01, 2015 at 09:30:00AM +0100, Martin Steigerwald wrote:
>> Am Dienstag, 1. Dezember 2015, 08:41:04 CET schrieb Dave Chinner:
>>> On Thu, Nov 26, 2015 at 11:21:45AM +0100, aluno3@poczta.onet.pl wrote:
>>>> Hello,
>>>>
>>>> I am using kernel 3.10 and would like to update xfsprogs (currently I
>>>> have 3.1.5).
>>>>
>>>> When I tried to use the newest version of xfsprogs 4.3.0 I get the call
>>>> trace about detected version 5 of superblock when mounting volume which
>>>> was formatted using mkfs.xfs from 4.3.0.
>>>
>>> More recent xfsprogs versions enable features that are only
>>> supported by recent kernels. We tend to wait at least a year before
>>> enabling new features by default in xfsprogs so that kernel support
>>> is usually picke dup by distros before they update xfsprogs....
>>>
>>> If you have an old kernel, then you need to turn off the newer
>>> features that your kernel does not support. This has always been the
>>> case - if you update the xfsprogs yourself, then you need to use the
>>> correct options for your kernel. In general, this:
>>>
>>> # mkfs.xfs -f -m crc=0 -n ftype=0 <dev>
>>>
>>> will make a filesystem that can be mounted on old kernels. If
>>> distros are shipping old kernels with new xfsprogs and are not
>>> changing the default behaviour to suit their kernel, then that is a
>>> distro problem.
>>
>> How about just checking running kernel version before enabling this by 
>> default?
> 
> The btrfs solution? No thanks.

Another option is to export features the running kernel can handle in
sysfs & mkfs accordingly - but then somebody mkfs's under one kernel,
boots another kernel, and gets different mkfs's, possibly fails to mount,
etc... magically changing defaults is a nightmare.  yeah, at some point
you have to realize that you cannot save everyone from themselves.  ;)
 
> Apart from the fact I make filesystems that the kernel does not
> support all the time, xfstests does the same thing so that we can
> test that the kernel correctly rejects mounts of filesystems with
> features it doesn't support. And this fails when a distro installer
> or rescue distro has a different kernel to the one the distro
> actually uses, too...
> 
> And, really, where does this slipperly slope end? Suddenly we have
> to maintain a map of every feature in every mainline kernel, then
> every distro kernel that does backports (e.g. sles, rhel, etc) and
> we end up with something nobody can maintain or test.
> 
>> While this is some implementation effort, it may help to reduce questions on 
>> this mailing list. And as you see distro problem or not: People still ask 
>> here. :)

Like Dave said - not very often at all.

-Eric

> The majority of distro's get it right the majority of the time -
> there's no point in turning everything upside down just to silence a
> very small vocal minority. i.e. It's only when users do their own
> package upgrades, or a distro screws up (like gentoo with shipping
> 3.2.4 on an old kernel) that users end up with a problem.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
