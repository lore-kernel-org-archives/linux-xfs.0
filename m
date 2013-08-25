Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9ED7D7CBE
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 19:00:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 866B8304043
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 17:00:20 -0700 (PDT)
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	WPcvlc9X1riAKVm7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Aug 2013 17:00:19 -0700 (PDT)
Received: by mail-ie0-f171.google.com with SMTP id 9so3011163iec.16
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 17:00:19 -0700 (PDT)
Message-ID: <52194911.3050606@gmail.com>
Date: Sat, 24 Aug 2013 20:00:17 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: Default mkfs parms for my DVR drive
References: <1365641.4934.1377388085878.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <1365641.4934.1377388085878.JavaMail.root@benjamin.baylink.com>
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
To: xfs@oss.sgi.com

On 08/24/2013 07:48 PM, Jay Ashworth wrote:
> This is a Seagate ST3000DM001, all one volume, for my sister's DVR on
> which I've been doing this volume recovery work.  The default setup that
> mkfs.xfs returns with no parms supplies is this:
>
> meta-data=/dev/sda1              isize=256    agcount=4, agsize=183141568 blks
>           =                       sectsz=4096  attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=732566272, imaxpct=5
>           =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=357698, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> and that takes about 3 minutes to mkfs a 3TB drive.
>
> Anyone have some thoughts they wish to cast upon the waters about either part
> of that?

Dave, Eric, and the rest of the xfs team will tell you "use the defaults 
Luke".  For 99 and 44/100ths percent of users, this is the right choice.


I am guessing that some of the delay may be the speed of the interface 
to the disk ... but even then 3 minutes sounds long, unless something 
else is hitting the disk at the same time.

Which kernel version btw?  A quick 'uname -a' is a good thing.

Your hardware could also be somewhat slow ... Could you do an

	lshw -class disk -class storage


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
