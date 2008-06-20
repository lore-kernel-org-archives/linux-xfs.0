Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 19:44:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5K2irbn020866
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 19:44:53 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA0F9D01983
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 19:45:51 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.245]) by cuda.sgi.com with ESMTP id mOWyYBypqD9EaSfM for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 19:45:51 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so5666777rvb.32
        for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 19:45:51 -0700 (PDT)
Message-ID: <dd599fe00806191945u336f4701raf82c0972bce8c26@mail.gmail.com>
Date: Thu, 19 Jun 2008 22:45:50 -0400
From: "Simon Jakesch" <simon.jakesch@gmail.com>
Subject: Re: xfs_repair trouble
In-Reply-To: <op.uctrkqf73jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd599fe00806140943g13c790dfo9b3a84d7f9841641@mail.gmail.com>
	 <op.uctrkqf73jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Barry Naujok <bnaujok@sgi.com>

Running xfs_metadump.sh will give me output below. Does all this mean
it's best to think about alternatives to fixing/recovering these
files?

root@redlace:~/xfsprogs-trunk/xfs-cmds/xfsprogs/db# ./xfs_metadump.sh
-g /dev/evms/monster_evms monster.dump
Copied 320 of 112448 inodes (0 of 0 AGs)                   xfs_db:
metadump.c:465: generate_obfuscated_name: Assertion
`libxfs_da_hashname(newname, namelen) == hash' failed.
./xfs_metadump.sh: line 31: 17542 Aborted
xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1


On Mon, Jun 16, 2008 at 12:47 AM, Barry Naujok <bnaujok@sgi.com> wrote:
> On Sun, 15 Jun 2008 02:43:12 +1000, Simon <simonjj@gmail.com> wrote:
>
>> Hello all,
>>
>>
>> I have a corrupted xfs filesystem on top of a RAID 5 (1TB in size).
>> The RAID is still fully intact but the filesystem was damaged. When
>> trying to repair the filesystem xfs_repair fails. I have tried various
>> versions of xfs_repair, the latest stable (2.9.8) and the latest trunk
>> (from CVS). I'd love to investigate and/or fix the issue further but I
>> am a bit confused about some of my xfs_repair runs (both done with
>> trunk).
>> Could someone shed some light on where the problem could be, I'd be
>> happy to continue digging if I would only know where roughly
>
> Are you able to generate an xfs_metadump? If you can make that available,
> I should be able to find out the problem pretty easily.
>
> Regards,
> Barry.
>
