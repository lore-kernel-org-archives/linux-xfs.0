Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2NEt4ep099801 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 09:55:10 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC5D814AACE7
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:57:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7ZLkNScOsLlMiQTX for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:57:54 -0700 (PDT)
Message-ID: <4D8A0A70.9030201@redhat.com>
Date: Wed, 23 Mar 2011 09:57:52 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: xfstests: failure to umount ext4
References: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
In-Reply-To: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amir Goldstein <amir73il@gmail.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, XFS <xfs@oss.sgi.com>

On 3/23/11 9:36 AM, Amir Goldstein wrote:
> On Wed, Mar 23, 2011 at 4:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> I've been running xfstests on ext4 and I always get annoying failures to umount:
>>
>> 213 8s ... 31s
>> umount: /mnt/test/ext4: device is busy.
>>        (In some cases useful info about processes that use
>>         the device is found by lsof(8) or fuser(1))
>>
>> post 198 mostly fails to umount as well.
>> and post 124 always fails to umount.
>>
>> My server is Ubuntu 10.10, running kernel 2.6.38.
>>
>> Is there any known issue about this? because I could find it on google
>> or on the XFS list.
>>
> 
> Hi All,
> 
> Has anyone seen these failures when running xfstests on ext4?
> My test and scratch partitions are dedicated for xfstests.

I've not seen it, can you investigate with lsof etc?

They both work for me on a quick test, anyway, on a .38
kernel.

What are you using for your partitions under test?
 
-Eric

> Thanks,
> Amir.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
