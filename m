Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IHDmTp202850 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 12:13:48 -0500
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8854304051
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 10:15:24 -0700 (PDT)
Message-ID: <50803926.1010904@sgi.com>
Date: Thu, 18 Oct 2012 12:15:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Update mount options documentation
References: <1350574138-30305-1-git-send-email-cmaiolino@redhat.com>
	<5080253A.9060906@sgi.com> <5080279C.8030702@mrc-lmb.cam.ac.uk>
	<508028CC.5080800@sgi.com>
	<20121018170442.GA6634@andromeda.usersys.redhat.com>
In-Reply-To: <20121018170442.GA6634@andromeda.usersys.redhat.com>
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
To: xfs@oss.sgi.com

On 10/18/12 12:04, Carlos Maiolino wrote:
> On Thu, Oct 18, 2012 at 11:05:32AM -0500, Mark Tinguely wrote:
>> On 10/18/12 11:00, Dave Howorth wrote:
>>> Mark Tinguely wrote:
>>>> Would "Indicates that XFS is allowed to create inodes at locations up to
>>>> 32 bits of significance .."
>>>
>>> I prefer the original wording. Your suggestion says something about what
>>> XFS can do, but nothing about what it is not allowed to do, which is
>>> rather more important.
>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>> I see your point. Sounds good to me.
>>
>> --Mark.
>>
> This means no change is needed?
>

I am okay with what is written about creating inodes.

On a separate question, should something be mentioned that inode32 mode 
can still read/write/unlink any inode, even those number greater than 32 
bit, or will that confuse the inode creation point?

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
