Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC9BB7FBC
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 06:25:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7D6D304043
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 04:24:59 -0800 (PST)
Received: from mail-we0-f172.google.com (mail-we0-f172.google.com
	[74.125.82.172]) by cuda.sgi.com with ESMTP id aMFDHrRLC2Coz69y
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Mar 2013 04:24:57 -0800 (PST)
Received: by mail-we0-f172.google.com with SMTP id x10so2499951wey.17
	for <xfs@oss.sgi.com>; Fri, 01 Mar 2013 04:24:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130301111701.GB23616@dastard>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<20130301111701.GB23616@dastard>
From: Ole Tange <tange@binf.ku.dk>
Date: Fri, 1 Mar 2013 13:24:36 +0100
Message-ID: <CANU9nTkkEd61UsM+KngGzMzXVXdOa2oXOPtmqN4xGaPuEBN_nQ@mail.gmail.com>
Subject: Re: xfs_repair segfaults
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 1, 2013 at 12:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Feb 28, 2013 at 04:22:08PM +0100, Ole Tange wrote:
:
>> I forced a RAID online. I have done that before and xfs_repair
>> normally removes the last hour of data or so, but saves everything
>> else.
>
> Why did you need to force it online?

More than 2 harddisks went offline. We have seen that before and it is
not due to bad harddisks. It may be due to driver/timings/controller.

The alternative to forcing it online would be to read back a backup.
Since we are talking 100 TB of data reading back the backup can take a
week and will set us back to the last backup (which is more than a day
old). So it is preferable to force the last failing harddisk online
even though that causes us to loose a few hours of work.

>> Today that did not work:
>>
>> /usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - scan filesystem freespace and inode maps...
>> flfirst 232 in agf 91 too large (max = 128)
>
> Can you run:
>
> # xfs_db -c "agf 91" -c p /dev/md5p1
>
> And post the output?

# xfs_db -c "agf 91" -c p /dev/md5p1
xfs_db: cannot init perag data (117)
magicnum = 0x58414746
versionnum = 1
seqno = 91
length = 268435200
bnoroot = 295199
cntroot = 13451007
bnolevel = 2
cntlevel = 2
flfirst = 232
fllast = 32
flcount = 191
freeblks = 184285136
longest = 84709383
btreeblks = 24

The partition has earlier been mounted with -o inode64.

/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
