Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 13:36:26 -0700 (PDT)
Message-ID: <469D24A6.6080409@mandriva.com>
Date: Tue, 17 Jul 2007 22:20:54 +0200
From: =?ISO-8859-1?Q?Giuseppe_Ghib=F2?= <ghibo@mandriva.com>
MIME-Version: 1.0
Subject: Re: [Advocacy] Re: 3ware 9650 tips
References: <582908739-1184695294-cardhu_decombobulator_blackberry.rim.net-122921225-@bxe015.bisx.prod.on.blackberry>
In-Reply-To: <582908739-1184695294-cardhu_decombobulator_blackberry.rim.net-122921225-@bxe015.bisx.prod.on.blackberry>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: b.j.smith@ieee.org
Cc: Simon Matter <simon.matter@invoca.ch>, xfs-bounce@oss.sgi.com, Stuart Levy <slevy@ncsa.uiuc.edu>, Joshua Baker-LePain <jlb17@duke.edu>, David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com

Bryan J Smith wrote:

> Matter, Simon wrote:  
>> I know that XFS had and maybe still has some minor issues -
>> but, if RedHat decided to use XFS and put the same effort into it
>> like they did with Ext3, those problems would have gone long ago.
> 
> Ditto.  XFS was the ultimate, complementary filesystem to Ext3.
> 
> In all honesty, I'm just looking forward to ZFS on RHEL, sorry to say.

ZFS won't appear officially in Linux until there will be change of
license, so right now it's released in userspace.

> Although I don't see that being "proven" for years, so I'm with XFS "on my own"
> when I deploy RHEL - which is, many times, the only viable filesystem.
> 
> --  

Indeed XFS is a lot faster than ext3 on many task (e.g. copy/moving
or delete huge files o creating filesystems or dumping with xfsdump),
and worked fine, until linux kernels around 2.6.15|16|17|18 when it had serious problems about
data corruptions. Furthermore when you run xfs_repair to fix such errors, you find that it lost
all the directory names, and places restored files into "random" dirs
named with "number" names.

See for instance:

http://lkml.org/lkml/2006/8/4/97
http://lkml.org/lkml/2006/8/28/88
or http://qa.mandriva.com/show_bug.cgi?id=24716

and sound the fix is not easy to be backportable to kernel series older than 2.6.18,
such as 2.6.17 (used for instance in ubuntu 7.04 and mandriva 2007.1).

Also in the recent 2.6.20|21 kernel series I found it has serious problems of
performance, especially when used in softraid (e.g. for storing
the vmware huge filedisks images a simple "sync" takes fifteen minutes in a raid1).

Bye
Giuseppe.
