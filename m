Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DJEPFr034225 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 13:14:25 -0600
Message-ID: <4F39610E.5070601@sgi.com>
Date: Mon, 13 Feb 2012 13:14:22 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore: WARNING: corrupt extent header
References: <CAGdb-8fFOAOSZAZNJDB9kyQJHoWKh+4SUohZfkknLDkaGnQFcQ@mail.gmail.com>
In-Reply-To: <CAGdb-8fFOAOSZAZNJDB9kyQJHoWKh+4SUohZfkknLDkaGnQFcQ@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

Could you please send me the output of xfsrestore using -v 4?
It'll probably be a lot of output, so compressing and attaching
it would be best.

Thanks,
Bill

On 02/12/2012 10:46 PM, Tommy Wu wrote:
> Hi!
>
>     OS: Debian squeeze amd64
>     xfsdump 3.0.6
>     xfsprogs 3.1.7
>
>     It happen when the xfsdump got message like:
> /sbin/xfsdump: WARNING: could not open regular file ino 33905028 mode
> 0x00008180: Stale NFS file handle: not dumped
> /sbin/xfsdump: WARNING: could not get list of non-root attributes for
> nondir ino 33905028: Stale NFS file handle (116)
> /sbin/xfsdump: WARNING: could not get list of root attributes for
> nondir ino 33905028: Stale NFS file handle (116)
> /sbin/xfsdump: WARNING: could not get list of secure attributes for
> nondir ino 33905028: Stale NFS file handle (116)
>
>     when I restore the dump file, it will get this, and it's not
> restore all files in the dump file:
> xfsrestore: WARNING: corrupt extent header
> xfsrestore: WARNING: unable to resync media file: some portion of dump
> will NOT be restored
>
>
>     for example:
> cmd: /sbin/xfsdump -l 0 -o -p 300 -J -F -M weekly_backup -L var -
> /dev/sda8 | /bin/gzip -qv | /usr/bin/split -b 1024m --verbose -
> /vol/backup/fw1/dump.20120211/var.xfsdump.gz.
> /sbin/xfsdump: using file dump (drive_simple) strategy
> /sbin/xfsdump: version 3.0.6 (dump format 3.0) - Running single-threaded
> /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/var
> /sbin/xfsdump: dump date: Sat Feb 11 00:17:41 2012
> /sbin/xfsdump: session id: 54572680-8778-49e0-b6bd-635747c47de3
> /sbin/xfsdump: session label: "var"
> /sbin/xfsdump: ino map phase 1: constructing initial dump list
> /sbin/xfsdump: ino map phase 2: skipping (no pruning necessary)
> /sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
> /sbin/xfsdump: ino map construction complete
> /sbin/xfsdump: estimated dump size: 598793856 bytes
> /sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
> /sbin/xfsdump: dumping ino map
> /sbin/xfsdump: dumping directories
> /sbin/xfsdump: dumping non-directory files
> /sbin/xfsdump: WARNING: could not open regular file ino 33905028 mode
> 0x00008180: Stale NFS file handle: not dumped
> /sbin/xfsdump: WARNING: could not get list of non-root attributes for
> nondir ino 33905028: Stale NFS file handle (116)
> /sbin/xfsdump: WARNING: could not get list of root attributes for
> nondir ino 33905028: Stale NFS file handle (116)
> /sbin/xfsdump: WARNING: could not get list of secure attributes for
> nondir ino 33905028: Stale NFS file handle (116)
> /sbin/xfsdump: ending media file
> /sbin/xfsdump: media file size 549085392 bytes
> /sbin/xfsdump: dump size (non-dir files) : 543886560 bytes
> /sbin/xfsdump: dump complete: 46 seconds elapsed
> /sbin/xfsdump: Dump Status: SUCCESS
>   60.6%
> creating file `/vol/backup/fw1/dump.20120211/var.xfsdump.gz.aa'
>
> then test or restore from this dump file:
> mail:/vol/backup/fw1/dump.20120211# cat var.xfsdump.gz.aa | gzip -dqv
> | xfsrestore -v silent -p 300 -J -t - | grep ^xfsrestore:
> xfsrestore: WARNING: corrupt extent header
> xfsrestore: WARNING: unable to resync media file: some portion of dump
> will NOT be restored
>
>
>     It seems only happen in /var partition, and it's not always happen.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
