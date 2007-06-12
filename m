Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 17:35:03 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5C0YxWt020703
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 17:35:00 -0700
Subject: Re: sunit not working
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <1181606134.7873.72.camel@holwrs01>
References: <1181606134.7873.72.camel@holwrs01>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 10:34:04 +1000
Message-Id: <1181608444.3758.73.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Salmon, Rene" <Rene.Salmon@bp.com>
Cc: xfs@oss.sgi.com

On Mon, 2007-06-11 at 18:55 -0500, Salmon, Rene wrote:
> As you can see the sunit gets set to 64 upon creation and not 512 like I
> asked.  Also if it try to give it some mount options it does the same
> thing.
> 
> sgi210a:~ # mount -o sunit=512,swidth=5120 /dev/mapper/mpath9 /mnt/

Its being reported in units of filesystem blocks, and its specified
in 512 byte units.  Pretty dopey, but thats why its different.

> sgi210a:~ # xfs_info /mnt/
> meta-data=/dev/mapper/mpath9     isize=256    agcount=32,
> agsize=56652352 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=1812874752,
> imaxpct=25
>          =                       sunit=64     swidth=640 blks,
> unwritten=1
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> sgi210a:~ # 

$ gdb -q
(gdb) p 512 * 512
$1 = 262144
(gdb) p 64 * 4096
$2 = 262144
(gdb)

(thats 262144 bytes, of course)

> Last I tried to subscribe to the list by sending email to
> ecartis@oss.sgi.com a couple of times but was unsuccessful should I send
> email elsewhere to subscribe?

Its a frikkin' lottery. :)  Keep trying and keep whining is how I ended
up getting back on (whining on IRC on #xfs helps too).

cheers.

-- 
Nathan
