Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7KFZUYW160436 for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 10:35:30 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80E9915FECC4
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 08:37:54 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id oAYmCbPH80XuCffP for
	<xfs@oss.sgi.com>; Sat, 20 Aug 2011 08:37:54 -0700 (PDT)
Message-ID: <4E4FD48B.8030101@oracle.com>
Date: Sat, 20 Aug 2011 08:36:43 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<4E4F814B.5070202@gmail.com> <4E4F865B.2010608@gmail.com>
In-Reply-To: <4E4F865B.2010608@gmail.com>
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
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On 08/20/2011 03:03 AM, Marco Stornelli wrote:
> Il 20/08/2011 11:41, Marco Stornelli ha scritto:
>> Hi,
>>
>> Il 28/06/2011 17:33, Josef Bacik ha scritto:
>>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.
>>> Turns out
>>> using fiemap in things like cp cause more problems than it solves, so
>>> lets try
>>> and give userspace an interface that doesn't suck. We need to match
>>> solaris
>>> here, and the definitions are
>>>
>>> *o* If /whence/ is SEEK_HOLE, the offset of the start of the
>>> next hole greater than or equal to the supplied offset
>>> is returned. The definition of a hole is provided near
>>> the end of the DESCRIPTION.
>>>
>>> *o* If /whence/ is SEEK_DATA, the file pointer is set to the
>>> start of the next non-hole file region greater than or
>>> equal to the supplied offset.
>>>
>>
>> I'm implementing the SEEK_DATA/SEEK_HOLE management for pramfs and I've
>> got some doubts about the right behavior:
>>
>> 1) when we use SEEK_DATA/SEEK_HOLE, the offset used in lseek means
>> always the offset from the start of the file, right?
>>
>> 2) in case of a file with hole at the beginning and data at the end, if
>> I do lseek(fd, 0, SEEK_HOLE) I should receive the end of the file
>> because the idea is to search the *next* hole and we have always a
>> virtual hole at the end of the file, right?
>
> Just to be precise about this question: the alternative here, it's to 
> return the same position because we are already in a hole.

Yes, the offset is from the start of the file.

And yes, same offset is ok. I think the word next should be
dropped from the definition. It is misleading.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
