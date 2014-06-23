Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 237A27F3F
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 17:13:13 -0500 (CDT)
Message-ID: <53A8A676.80305@sgi.com>
Date: Mon, 23 Jun 2014 17:13:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Null pointer dereference while at ACL limit on v5 XFS
References: <53A8A0AF.9070009@gmail.com> <53A8A578.4070005@sgi.com>
In-Reply-To: <53A8A578.4070005@sgi.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 06/23/14 17:08, Mark Tinguely wrote:
> On 06/23/14 16:48, Michael L. Semon wrote:
>> At the ACL limit of v5-superblock XFS--with a directory filled with
>> both default
>> and access ACL entries--I'm getting a null pointer dereference on x86
>> after
>> creating the directory successfully.
>>
>> Disclaimer: There's some current issues on 32-bit x86 that, for
>> instance, can
>> make badblocks see phantom bad blocks on a read test. My apologies in
>> advance
>> if this turns out to be a false alarm bug report.
>>
>> My first encounter with this issue involved fsstress. Here's part of a
>> `crash`
>> session from the fsstress run.
>>
>> root@oldsvrhw:/mnt/crashdump/xfs-fsstress-max-acl-2# crash vmlinux
>> System.map vmcore
>> crash 7.0.4
...
 >> Thanks!
 >>
 >> Michael
 >>
 >
 > Michael, do you have the vmcore dump for this or was this just from the
 > messages.
 >
 > Thanks.
 >
 > --Mark.

ummm, duh me. you were running crash ...

Can I look at the core?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
