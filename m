Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3648F7F3F
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 09:09:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B87FCAC001
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 07:09:14 -0700 (PDT)
Received: from mail3.ks.pochta.ru (mail3.ks.pochta.ru [62.141.94.173]) by
	cuda.sgi.com with ESMTP id OHIybT8DqxuJyO6x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Jul 2014 07:09:12 -0700 (PDT)
Message-ID: <53B6B581.5070801@hotbox.ru>
Date: Fri, 04 Jul 2014 18:09:05 +0400
From: flux@hotbox.ru
MIME-Version: 1.0
Subject: Re: XFS syncs
References: <53B59B81.2030603@hotbox.ru> <20140703231730.GW4453@dastard>
In-Reply-To: <20140703231730.GW4453@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hello Dave,

Thanks for the explanation and your suggestion to use wsync option.

On 07/04/2014 03:17 AM, Dave Chinner wrote:
> On Thu, Jul 03, 2014 at 10:05:53PM +0400, flux@hotbox.ru wrote:
>> Hi,
>>
>> I issue 'mkdir abc' on my xfs partition the cut off the power. After
>> reboot there's no 'abc' directoy.
>
> Because you didn't sync(1) the filesystem or fsync(2) the directory
> before you cut the power. Hence the change never hit the disk.
>
>> However, when I do that on ext4
>> the 'abc' direcory is always created after reboots.
>
> That'll be pure fluke - ext4 delays journal writes on namespace
> operations just like XFS does.
>
>> All the
>> settings, about mount options are default for my distro. What am I
>> missing or how do I change the things of the jounral or whatever?
>
> If you want directory operations to hitthe disk immediately, then
> mount with the "-o wsync" option. Be aware, however, that this will
> kill performance unless you have expensive storage with a large
> amount of battery backed write cache in front of the disks. There's
> a good chance it will also cause excessive wear on SSDs due to the
> frequent journal writes.
>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
