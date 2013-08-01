Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA09029DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 15:21:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98F24304051
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 13:21:12 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id 5Hl9LKxpBnfOSSSC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 13:21:10 -0700 (PDT)
Date: Thu, 1 Aug 2013 22:21:08 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Performance decrease over time
Message-ID: <20130801202108.GA355@x4>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Yesterday I noticed that the nightly rsync run that backups my root
fs took over 8 minutes to complete. Half a year ago when the backup disk
was freshly formated it only took 2 minutes. (The size of my root fs stayed
constant during this time).

So I decided to reformat the drive, but first took some measurements.
The drive in question also contains my film and music collection,
several git trees and is used to compile projects quite often.

Model Family:     Seagate Barracuda Green (AF)
Device Model:     ST1500DL003-9VT16L

/dev/sdb on /var type xfs (rw,relatime,attr2,inode64,logbsize=256k,noquota)
/dev/sdb       xfs       1.4T  702G  695G  51% /var

 # xfs_db -c frag -r /dev/sdb
actual 1540833, ideal 1529956, fragmentation factor 0.71%

# iozone -I -a -s 100M -r 4k -r 64k -r 512k -i 0 -i 1 -i 2
        Iozone: Performance Test of File I/O
                Version $Revision: 3.408 $
                Compiled for 64 bit mode.
                Build: linux-AMD64 
...
        Run began: Thu Aug  1 12:55:09 2013

        O_DIRECT feature enabled
        Auto Mode
        File size set to 102400 KB
        Record Size 4 KB
        Record Size 64 KB
        Record Size 512 KB
        Command line used: iozone -I -a -s 100M -r 4k -r 64k -r 512k -i 0 -i 1 -i 2
        Output is in Kbytes/sec
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
                                                            random  random    bkwd   record   stride                                   
              KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
          102400       4    8083    9218     3817     3786     515     789                                                          
          102400      64   56905   48177    17239    26347    7381   15643                                                          
          102400     512  113689   86344    84583    83192   37136   63275                                                          

After fresh format and restore from another backup, performance is much
better again:

# iozone -I -a -s 100M -r 4k -r 64k -r 512k -i 0 -i 1 -i 2
                                                            random  random    bkwd   record   stride                                   
              KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
          102400       4   13923   18760    19461    27305     761     652                                                          
          102400      64   95822   95724    82331    90763   10455   11944                                                          
          102400     512   93343   95386    94504    95073   43282   69179 

Couple of questions. Is it normal that throughput decreases this much in
half a year on a heavily used disk that is only half full? What can be
done (as a user) to mitigate this effect? 

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
