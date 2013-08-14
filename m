Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC0907F4E
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 16:28:27 -0500 (CDT)
Message-ID: <520BF6A2.6030208@sgi.com>
Date: Wed, 14 Aug 2013 16:29:06 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfsprogs: Allow pquota and gquota to be used together
References: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
	<20130802015032.GY7118@dastard>
	<1375476019.4155.66.camel@chandra-dt.ibm.com>
In-Reply-To: <1375476019.4155.66.camel@chandra-dt.ibm.com>
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
To: sekharan@us.ibm.com
Cc: xfs@oss.sgi.com

On 08/02/2013 03:40 PM, Chandra Seetharaman wrote:
> On Fri, 2013-08-02 at 11:50 +1000, Dave Chinner wrote:
>> On Thu, Aug 01, 2013 at 02:24:59PM -0500, Chandra Seetharaman wrote:
>>> Hello All,
>>>
>>> These two patches make the relevant user space changes to support
>>> the gquota/pquota in kernel.
>>>
>>> It applies cleanly on crc-dev branch of xfsprogs.
>>
>> I think I've already brought all of the libxfs pquota changes across
>> in the series of patches I have that unified the kernel and
>> userspace code on top of the crc-dev branch....
>
> Cool.
>
> I just looked at your patches. Some of my changes are still not in those
> patches.
>
> I will rebase and post a new patchset once your patches are merged in.
>
> Thanks
>
> Chandra
>>
>> Cheers,
>>
>> Dave.
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
This patch series looks good and applies cleanly to current xfsprogs 
tree. As the patchset mentioned above needs to be rebased and this 
series coincides with quota kernel patch series already reviewed and 
waiting one minor change, this series has been committed (0340d70 and 
342aef1).

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
