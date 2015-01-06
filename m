Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C86D7F50
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 06:36:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF88C8F8039
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 04:36:27 -0800 (PST)
Received: from mail-wg0-f42.google.com (mail-wg0-f42.google.com
	[74.125.82.42]) by cuda.sgi.com with ESMTP id KcQDcH2JAzgjzahF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2015 04:36:26 -0800 (PST)
Received: by mail-wg0-f42.google.com with SMTP id k14so29488866wgh.15
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 04:36:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOFq7B6eqEpGN2gcON-D63ZRf7AEabe2V_4q7jECZHk0t4etJQ@mail.gmail.com>
References: <CAOFq7B6eqEpGN2gcON-D63ZRf7AEabe2V_4q7jECZHk0t4etJQ@mail.gmail.com>
Date: Tue, 6 Jan 2015 13:36:25 +0100
Message-ID: <CAAxjCEy4zEjA_J45im8PFcr40QPGXtDnoefFQDo9OqTtuxvsLw@mail.gmail.com>
Subject: Re: XFS corrupt after RAID failure and resync
From: Stefan Ring <stefanrin@gmail.com>
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
To: David Raffelt <david.raffelt@florey.edu.au>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Tue, Jan 6, 2015 at 6:39 AM, David Raffelt
<david.raffelt@florey.edu.au> wrote:
> Hi All,
>
> I have 7 drives in a RAID6 configuration with a XFS partition (running Arch
> linux). Recently two drives dropped out simultaneously, and a hot spare
> immediately synced successfully so that I now have 6/7 drives up in the
> array.
>
> After a reboot (to replace the faulty drives) the XFS file system would not
> mount. Note that I had to perform a hard reboot since the server hung on
> shutdown. When I try to mount I get the following error:
> mount: mount /dev/md0 on /export/data failed: Structure needs cleaning
>
> I have tried to perform: xfs_repair /dev/md0
> And I get the following output:
>
> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - bad magic number !!!
> attempting to find secondary superblock...

This is certainly not what you want to hear, but I guess it will not
matter much what you do. If you want to, you can continue trying
everything for your own amusement, but I would say farewell to the
data on that RAID. A rebuild should not have any effect on the data
contained by the array. If it does, then something must have gone
wrong. And since something seems to have gone wrong, it has likely
gone wrong in a big way. What are the chances of just the tiny little
amount of data that XFS needs for mounting getting corrupted, while
everything else magically got away unscathed?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
