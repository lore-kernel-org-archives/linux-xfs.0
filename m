Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E5277F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:09:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A4A6304032
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:09:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mnaImkQ7PM3UFDAv for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 21:09:21 -0700 (PDT)
Message-ID: <5450686F.9070307@sandeen.net>
Date: Tue, 28 Oct 2014 23:09:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
In-Reply-To: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>, xfs <xfs@oss.sgi.com>

On 10/28/14 11:06 PM, Tommy Wu wrote:
> 
> kernel 3.17.0 (same command in kernel 3.16.x work fine)
> xfsdump 3.1.4
> xfsprogs 3.2.1
> 
> test case:
> 1. create a new filesystem in LVM
> 
> lvcreate -L 5G -n test vg
> mkfs.xfs -f /dev/vg/test
> mount /dev/vg/test /mnt/x
> 
> 2. extract linux-3.17.tar.xz to the new filesystem
> 
> cd /mnt/x
> tar Jxvf /usr/src/linux-3.17.tar.xz
> 
> 3. backup the filesystem
> 
> xfsdump -l 0 -o -p 300 -J -F -M test -L test - /mnt/x | /bin/gzip -qv > /vol/test.xfsdump.gz
> 
> 4. test the dump file, it show a lots of NOTE, and it said restore status is SUCCESS.

Is this not the same bug we already discussed in your prior email,
"xfsdump not work in 3.17" ?  Are you testing with or without those bugfixes?

-Eric

> cat /vol/test.xfsdump.gz | gzip -dqv | xfsrestore -p 300 -J -t - | grep "^/sbin/xfsrestore:"
> /sbin/xfsrestore: using file dump (drive_simple) strategy
> /sbin/xfsrestore: version 3.1.4 (dump format 3.0)
> /sbin/xfsrestore: searching media for dump
> /sbin/xfsrestore: examining media file 0
> /sbin/xfsrestore: dump description:
> /sbin/xfsrestore: hostname: mail.teatime.com.tw <http://mail.teatime.com.tw>
> /sbin/xfsrestore: mount point: /mnt/x
> /sbin/xfsrestore: volume: /dev/mapper/vg-test
> /sbin/xfsrestore: session time: Wed Oct 29 11:45:54 2014
> /sbin/xfsrestore: level: 0
> /sbin/xfsrestore: session label: "test"
> /sbin/xfsrestore: media label: "test"
> /sbin/xfsrestore: file system id: d757277d-5167-4cdb-975d-c64b2f94a47e
> /sbin/xfsrestore: session id: 6f114712-6fb6-4f35-a2f3-30ca1a0af5bb
> /sbin/xfsrestore: media id: 2eb2ff54-1838-47b2-a8d5-5f520deaf5f5
> /sbin/xfsrestore: searching media for directory dump
> /sbin/xfsrestore: reading directories
> /sbin/xfsrestore: 2035 directories and 33045 entries processed
> /sbin/xfsrestore: directory post-processing
> /sbin/xfsrestore: reading non-directory files
> /sbin/xfsrestore: NOTE: ino 144 salvaging file, placing in orphanage/143.0/Makefile
> /sbin/xfsrestore: NOTE: ino 145 salvaging file, placing in orphanage/143.0/bayer.png.b64
> /sbin/xfsrestore: NOTE: ino 146 salvaging file, placing in orphanage/143.0/constraints.png.b64
> /sbin/xfsrestore: NOTE: ino 147 salvaging file, placing in orphanage/143.0/crop.gif.b64
> /sbin/xfsrestore: NOTE: ino 148 salvaging file, placing in orphanage/143.0/dvbstb.png.b64
> /sbin/xfsrestore: NOTE: ino 149 salvaging file, placing in orphanage/143.0/fieldseq_bt.gif.b64
> /sbin/xfsrestore: NOTE: ino 150 salvaging file, placing in orphanage/143.0/fieldseq_tb.gif.b64
> .... skip it....
> /sbin/xfsrestore: NOTE: ino 50363235 gen 1622742662 not referenced: placing in orphanage
> /sbin/xfsrestore: table of contents display complete: 3 seconds elapsed
> /sbin/xfsrestore: Restore Status: SUCCESS
> 
> 5. restore it, show a lots of NOTE, and resotre status is SUCCESS, but... compare them, it's different.
> 
> cat test.xfsdump.gz | gzip -dqv | xfsrestore -p 300 -J - /vol/x/
> /sbin/xfsrestore: using file dump (drive_simple) strategy
> /sbin/xfsrestore: version 3.1.4 (dump format 3.0)
> /sbin/xfsrestore: searching media for dump
> /sbin/xfsrestore: examining media file 0
> /sbin/xfsrestore: dump description:
> /sbin/xfsrestore: hostname: mail.teatime.com.tw <http://mail.teatime.com.tw>
> /sbin/xfsrestore: mount point: /mnt/x
> /sbin/xfsrestore: volume: /dev/mapper/vg-test
> /sbin/xfsrestore: session time: Wed Oct 29 11:45:54 2014
> /sbin/xfsrestore: level: 0
> /sbin/xfsrestore: session label: "test"
> /sbin/xfsrestore: media label: "test"
> /sbin/xfsrestore: file system id: d757277d-5167-4cdb-975d-c64b2f94a47e
> /sbin/xfsrestore: session id: 6f114712-6fb6-4f35-a2f3-30ca1a0af5bb
> /sbin/xfsrestore: media id: 2eb2ff54-1838-47b2-a8d5-5f520deaf5f5
> /sbin/xfsrestore: searching media for directory dump
> /sbin/xfsrestore: reading directories
> /sbin/xfsrestore: 2035 directories and 33045 entries processed
> /sbin/xfsrestore: directory post-processing
> /sbin/xfsrestore: restoring non-directory files
> /sbin/xfsrestore: NOTE: ino 144 salvaging file, placing in orphanage/143.0/Makefile
> /sbin/xfsrestore: NOTE: ino 145 salvaging file, placing in orphanage/143.0/bayer.png.b64
> /sbin/xfsrestore: NOTE: ino 146 salvaging file, placing in orphanage/143.0/constraints.png.b64
> .... skip it....
> /sbin/xfsrestore: NOTE: ino 50363235 gen 1622742662 not referenced: placing in orphanage
> /sbin/xfsrestore: WARNING: unable to rmdir /vol/x//orphanage: Directory not empty
> /sbin/xfsrestore: restore complete: 3 seconds elapsed
> /sbin/xfsrestore: Restore Status: SUCCESS
> 
> 
> -- 
> 
> Tommy Wu
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
