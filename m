Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB51GBPJ216103 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 19:16:11 -0600
Received: from relay01.pair.com (relay01.pair.com [209.68.5.15]) by
	cuda.sgi.com with SMTP id zJXmAkH5b9wk3cZE for
	<xfs@oss.sgi.com>; Tue, 04 Dec 2012 17:18:34 -0800 (PST)
Date: Tue, 04 Dec 2012 20:18:31 -0500
Subject: Re: xfsdump INTERRUPT issue
From: "J. Ellis" <jellis@dhnet.us>
Message-ID: <CCE40B17.B056E%jellis@dhnet.us>
In-Reply-To: <50BE961B.8030705@hardwarefreak.com>
Mime-version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com, xfs@oss.sgi.com

Hi, Stan--

Ok, I truly apologize for my ignorance, but I don't know how to dump the
contents to a file. Is it something like:

xfsdump -J - somefile_xfsdump.txt
xfsrestore -J - somefile_xfsrestore.txt

?

Best,
J. 


on 12/4/12 7:32 PM, Stan Hoeppner at stan@hardwarefreak.com wrote:

> On 12/3/2012 4:27 PM, Jeffrey Ellis wrote:
> 
> xfs_info output and this below is all that is needed at this point.
> 
>>> FWIW, this implies that xfsrestore failed. What is the output from
>>> xfsrestore? Can you just run xfsdump to a file?
> 
>> Can you tell me how to do that and dmesg?
> 
> The command you posted
> 
> xfsdump -J - /mnt/hr20 | xfsrestore -J - /mnt/fp
> 
> pipes the output from xfsdump into xfsrestore.  This error
> 
> xfsdump: WARNING: write to stdio failed: 32 (Broken pipe)
> 
> tells us something broke while piping into xfsrestore, possibly
> xfsrestore itself.  I believe what Dave is asking you is to xfsdump to a
> file, then xfsrestore that file.  In two separate operations.  This
> should tell us more about where the problem is.
> 
> Regarding dmesg information, simply do
> 
> ~$ dmesg
> 
> and copy the output into your email.  It should be a few screen fulls
> starting with something like:
> 
> Linux version 3.2.6 (root@greer) (gcc version 4.4.5 (Debian 4.4.5-8) )
> #1 SMP Mon Feb 20 17:05:10 CST 2012
> 
> WRT xfs_info:
> 
> ~$ cat /etc/mtab
> ...
> /dev/sda6 /home xfs rw 0 0
> ...
> 
> ~$ xfs_info /dev/sda6
> meta-data=/dev/sda6         isize=256    agcount=4, agsize=6103694 blks
>          =                  sectsz=512   attr=2
> data     =                  bsize=4096   blocks=24414775, imaxpct=25
>          =                  sunit=0      swidth=0 blks
> naming   =version 2         bsize=4096   ascii-ci=0
> log      =internal          bsize=4096   blocks=11921, version=2
>          =                  sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none              extsz=4096   blocks=0, rtextents=0
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
